library(dplyr)
library(R.utils)
library(stringr)

setwd("/storage/home/x/xjj5003/scratch/temp/part1")


args = commandArgs(trailingOnly=TRUE)
print(args[1] )
snpdf = read.table(args[1], header = F )

fst_h_keep = snpdf[,1:5]
# Get the SNP part
pop_1_exp=snpdf[,6:ncol(snpdf)]


fa1 = (rowSums(pop_1_exp=="0|0")*2+rowSums(pop_1_exp=="1|0") + rowSums(pop_1_exp=="0|1"))/(2*ncol(pop_1_exp))
fb1 = 1-fa1

maf=min(fa1,fb1)
# Calculate the numerator

mafkeep=cbind(fst_h_keep, maf)

write.table(mafkeep, file="temp.maf.txt", row.names=F, col.names=F, quote=F, sep="\t", append=F)

# write.table(datatokeep, file =  "1000genome.snp.test.txt" , row.names = T)
