library(EnvStats)
library(ggplot2)
library(reshape2)

options(warn=-1)

setwd("/data/human_PBS/1000genome.pr_coding")

popnames = c("TSI", "GBR", "FIN", "YRI")

# For PED of Qst, use the transformed one

ped1= read.table("led.qst.abs.pr_coding.rmlow.transformed.txt", header = T)

peddf = as.data.frame(ped1[,1:4])
for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = ped1[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("ped.qst.h1.clean.abs", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)
  
}


peddf.rel=peddf/rowSums(peddf)
peddf.rel[, "geneid"] = ped1$geneid

boxplot(peddf.rel[,1:3], notch = T, outline = F, ylab="PBS relative")

for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = peddf.rel[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("ped.qst.h1.clean.rel", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)

}


# merge the abs and rel ones

pedqstmerge = merge(ped1, peddf.rel, by = "geneid")
write.table(pedqstmerge, file="ped.qst.h1.xabs.yrel.txt" ,  row.names = F, col.names = T, quote = F)


# For PED of Pst, use the transformed one

ped1= read.table("led.pst.h2.0.5.abs.pr_coding.rmlow.transformed.set0.txt", header = T)

peddf = as.data.frame(ped1[,1:4])
for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = ped1[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("ped.pst.h2.0.5.clean.abs", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)
  
}

peddf = as.data.frame(ped1[,1:4])
peddf.rel=peddf/rowSums(peddf)
peddf.rel[, "geneid"] = ped1$geneid

boxplot(peddf.rel[,1:3], notch = T, outline = F, ylab="PBS relative")

for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = peddf.rel[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("ped.pst.h2.0.5.clean.rel", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)
  
}

pedqstmerge = merge(ped1, peddf.rel, by = "geneid")
write.table(pedqstmerge, file="ped.pst.h2.0.5.xabs.yrel.txt" ,  row.names = F, col.names = T, quote = F)


# For PBS, use the transformed one

pbs1= read.table("led.fst.abs.pr_coding.rmlow.transformed.txt", header = T)

for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = pbs1[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("pbs.fst.clean.abs", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)
  
}


pbsdf = as.data.frame(pbs1[,1:4])
pbsdf.rel=pbsdf/rowSums(pbsdf)
pbsdf.rel[, "geneid"] = pbs1$geneid

boxplot(pbsdf.rel[,1:4], notch = T, outline = F, ylab="PBS relative")

for (j in 1:length(popnames)) {
  pop = popnames[j]
  branchdf = pbsdf.rel[, c("geneid", pop)]
  rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
  print(head(rankbranch))
  newfilename = paste("pbs.fst.clean.rel", pop,"txt", sep = ".")
  write.table(rankbranch$geneid, file = newfilename, row.names = F, col.names = F, quote = F)
}



pbsfstmerge = merge(pbs1, pbsdf.rel, by = "geneid")
write.table(pbsfstmerge, file="pbs.fst.xabs.yrel.txt" ,  row.names = F, col.names = T, quote = F)


## print out the largest ones

pedfiles = list.files(path = "/data/human_PBS/1000genome.pr_coding", pattern = "led.*.txt")

#sink(file = "top1.branch.abs.rel.txt")

for (i in 1:length(pedfiles)) {
  thisbranch = pedfiles[i]
  print(thisbranch)
  thisbranchdf = read.table(thisbranch, header = T)
  
  print("absolute branch length")
  
  for (j in 1:length(popnames)) {
    pop = popnames[j]
    branchdf = thisbranchdf[, c("geneid", pop)]
    rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
    print(head(rankbranch, 3))
    
  }
  
  branchdf = as.data.frame(thisbranchdf[,1:4])  
  pbsdf.rel=branchdf/rowSums(branchdf)
  pbsdf.rel[, "geneid"] = thisbranchdf$geneid
  
  #print(head(pbsdf.rel))
  
  print("relative branch length")
  for (j in 1:length(popnames)) {
    pop = popnames[j]
    branchdf = pbsdf.rel[, c("geneid", pop)]
    rankbranch = branchdf[order(as.numeric(branchdf[,pop]), decreasing = T),]
    print(head(rankbranch, 3))
    
  }
  
}
#sink()
