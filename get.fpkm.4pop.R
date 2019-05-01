library(ggfortify)
library(ggplot2)
library(DESeq2)
library(edgeR)
library(geneplotter)

setwd("/data/human_PBS/1000genome/expression")

exprfile=read.table("human.featurecounts.summary.header.txt", header = T)


headinfor = exprfile[,1:6]
# match list, remove CEU
popindivi = read.table("GD462.name.uniq.list.txt", header = F)
colnames(popindivi) =c("person", "population")
interepop = popindivi[which(popindivi$population!="CEU"),]
intereindis = interepop$person

interepopexpr = exprfile[,colnames(exprfile)%in%intereindis]
exprfile = cbind(headinfor, interepopexpr)

# filter genes which don't have at least 10 reads on each sample
exprfile=exprfile[rowSums(exprfile[,7:ncol(exprfile)])>=3710,]


# Get the IDs of genes that have low-expression
#fstremove = exprfile[rowSums(exprfile[,7:ncol(exprfile)])<3710,"Geneid"]
# Keep a copy, so those can be removed from Fst stuff later
#write.table(fstremove, file = "GD462.fpkm.deseq2.4populations.lowexpr.toberemove.txt", row.names = F, col.names = F, quote = F)

indilist = colnames(exprfile)[7:ncol(exprfile)]
correpop = interepop[which(interepop$person == indilist),"population"]
conditions = factor(correpop)
subdf = exprfile[,7:ncol(exprfile)]


# generate DESeq object
mouseexpr = DESeqDataSetFromMatrix(subdf, DataFrame(conditions), ~ conditions)
# normalize the sequencing depth
mouseexpr = estimateSizeFactors(mouseexpr)
# input the length of the gene
mcols(mouseexpr)$basepairs = exprfile$Length



# get the FPKM
mousefpkm = fpkm(mouseexpr, robust = T)
# Add the gene infor
tokeep = cbind(exprfile[,c(1,6)], mousefpkm)

filenm = "GD462.fpkm.deseq2.4populations.txt"
write.table(tokeep, file = filenm, row.names = F, col.names = T, quote = F, sep = "\t")

