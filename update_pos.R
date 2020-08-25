in.bed <- read.table("tmp_out.bed")[,c(2,4)]
names(in.bed)[1] <- "NEW.POS"
in.bim <- read.table("tmp_gwas.bim")[,c(1,2,5,6)]
in.bim$ORDER <- seq(1, length(in.bim$V1))
merged <- merge(in.bim, in.bed, by.x="V2", by.y="V4")
merged <- merged[order(merged$ORDER),]
out.bim <- data.frame(V1=merged$V1,
                      V2=merged$V2,
                      V3=rep(0,length(in.bim$V1)),
                      V4=merged$NEW.POS,
                      V5=merged$V5,
                      V6=merged$V6)
write.table(out.bim, "tmp_gwas.bim",  sep="\t", quote=F, row.names=F, col.names=F)
