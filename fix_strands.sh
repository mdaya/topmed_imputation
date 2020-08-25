#!/bin/bash

#Set arguments
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <pre_qc_dir> <post_qc_dir>"
    exit
fi
pre_qc_dir=$1
post_qc_dir=$2


#Get list of SNPs to flip
cat get_strand_flip_snp_names.R | R --vanilla --args $pre_qc_dir

#Create vcf files for uploading to imputation server for QC
#Note that the encoding for chromosome is e.g. chr22, not chr
for ((chr=1; chr<=22; chr++)); do
    plink --bfile ${pre_qc_dir}/pre_qc --flip tmp_flip.txt --chr $chr --recode vcf --out tmp_chr${chr}
    vcf-sort tmp_chr${chr}.vcf | sed -E 's/^([[:digit:]]+)/chr\1/' | bgzip -c > ${post_qc_dir}/chr${chr}_post_qc.vcf.gz
done

#Cleanup
rm tmp_*
