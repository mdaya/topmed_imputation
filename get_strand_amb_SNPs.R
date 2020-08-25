bim <- read.table("tmp_gwas.bim", stringsAsFactors=F)
snps <- bim$V2[((bim$V5 == "A") & (bim$V6 == "T")) |
	       ((bim$V5 == "T") & (bim$V6 == "A")) |
	       ((bim$V5 == "C") & (bim$V6 == "G")) |
	       ((bim$V5 == "G") & (bim$V6 == "C"))]
write.table(snps, "tmp_strand_remove_snps.txt",  sep="\t", quote=F, row.names=F, col.names=F)
