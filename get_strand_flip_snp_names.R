args <- commandArgs(trailingOnly = TRUE)
pre.qc.dir <- args[1]

snp.frame <- read.delim(paste0(pre.qc.dir, "/snps-excluded.txt"), stringsAsFactors = F)
snp.frame <- snp.frame[grep("Strand flip", snp.frame$FilterType),]
snp.frame$chr <- as.numeric(gsub("chr", "", unlist(strsplit(snp.frame$X.Position, split=":"))[seq(1,dim(snp.frame)[1]*4,4)]))
snp.frame$pos <- as.numeric(unlist(strsplit(snp.frame$X.Position, split=":"))[seq(2,dim(snp.frame)[1]*4,4)])
snp.frame$chr.pos <- paste0(snp.frame$chr, ":", snp.frame$pos)
bim <- read.table(paste0(pre.qc.dir, "/pre_qc.bim"), stringsAsFactors = F)
bim$chr.pos <- paste0(bim$V1, ":", bim$V4)
snps <- bim$V2[bim$chr.pos %in% snp.frame$chr.pos]
write.table(snps, "tmp_flip.txt",  sep="\t", quote=F, row.names=F, col.names=F)
