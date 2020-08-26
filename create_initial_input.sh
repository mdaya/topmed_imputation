#!/bin/bash

#Set arguments
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <plink_file_prefix> <out_dir>"
    exit
fi
plink_prefix=$1
out_dir=$2

#Remove SNPs with duplicate positions
plink --bfile $plink_prefix \
   --list-duplicate-vars suppress-first \
   --out tmp_dupl_check
cat tmp_dupl_check.dupvar | sed -e '1d' | cut -f4 > tmp_dupl_snpids.txt
plink --bfile $plink_prefix \
   --exclude tmp_dupl_snpids.txt \
   --make-bed --out tmp_no_dupl


#Create bed file to crossover from hg19 to hg38 
cat tmp_no_dupl.bim | cut -f1 | sed 's/^/chr/' > tmp_c1.txt
cat tmp_no_dupl.bim | cut -f4 > tmp_c2.txt
cat tmp_no_dupl.bim | cut -f4 > tmp_c3.txt
cat tmp_no_dupl.bim | cut -f2 > tmp_c4.txt
paste  tmp_c1.txt \
       tmp_c2.txt \
       tmp_c3.txt \
       tmp_c4.txt \
       >  tmp_in.bed

#Do crossover
CrossMap.py bed hg19ToHg38.over.chain \
            tmp_in.bed  \
            tmp_out.bed

#Extract only those SNPs that were successfully cross-overed
cut -f4 tmp_out.bed > tmp_snp_keep.txt
plink --bfile tmp_no_dupl \
      --extract tmp_snp_keep.txt \
      --make-bed --out tmp_gwas

#Update bim file positions
cat update_pos.R | R --vanilla

#Remove strand ambiguous SNPs
cat get_strand_amb_SNPs.R | R --vanilla
plink --bfile tmp_gwas \
      --exclude tmp_strand_remove_snps.txt \
      --make-bed --out tmp_gwas_no_AT_CG

#Perform pre-imputation QC - remove monomorphic SNPs, SNPs with high
#missingness, SNPs not in HWE
plink --bfile tmp_gwas_no_AT_CG \
      --maf 0.000001 --geno 0.05 --hwe 0.000001 \
      --make-bed --out ${out_dir}/pre_qc

#Create vcf files for uploading to imputation server for QC
#Note that the encoding for chromosome is e.g. chr22, not chr
for ((chr=1; chr<=22; chr++)); do
    plink --bfile ${out_dir}/pre_qc --chr $chr --recode vcf --out tmp_chr${chr}
    vcf-sort tmp_chr${chr}.vcf | sed -E 's/^([[:digit:]]+)/chr\1/' | bgzip -c > ${out_dir}/chr${chr}_pre_qc.vcf.gz
done

#Report SNP counts
orig_snp_nr=`wc -l ${plink_prefix}.bim`
crossover_snp_nr=`wc -l tmp_gwas.bim`
nonamb_snp_nr=`wc -l tmp_gwas_no_AT_CG.bim`
qc_snp_nr=`wc -l ${out_dir}/pre_qc.bim`
echo "Original SNP nr: $orig_snp_nr"
echo "Crossovered SNP nr: $crossover_snp_nr"
echo "Non-ambiguous SNP nr: $nonamb_snp_nr"
echo "Final SNP nr after QC: $qc_snp_nr"

#Cleanup
rm tmp_*
