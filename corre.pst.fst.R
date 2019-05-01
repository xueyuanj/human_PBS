library(dplyr)

setwd("/data/human_PBS/1000genome.pr_coding")


corretst=function(x, y){
  testpearson=cor.test(x,y, method="pearson")
  pearson_coef=testpearson$estimate
  pearson_p=testpearson$p.value
  testspearman=cor.test(x,y, method="spearman", exact = F)
  spearman_coef=testspearman$estimate
  spearman_p=testspearman$p.value
  
  correplot= plot(x, y, pch=19,cex.main=1,cex.lab=0.8,xlab="", ylab="", main=paste("r =", round(pearson_coef, digits=4), "P =", round(pearson_p, digits=4), "\nrho =",round(spearman_coef, digits=4), "P =", round(spearman_p, digits=4) ))
  
  print(correplot)
}


pstfile = read.table("pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2.0.5.txt", header = T)
fstfile = read.table("fst.hudson.1000genome.4pop.allindividual.ratioofave.maf0.01.pr_coding.rmlow.txt", header = T)

for (i in 1:ncol(pstfile)) {
  pstpair = as.data.frame(pstfile[,i])
  fstpair = as.data.frame(fstfile[,i])
  pstpair[,"geneid"] = row.names(pstfile) 
  fstpair[,"geneid"] = row.names(fstfile)
  
  mergetwo = merge(pstpair, fstpair, by ="geneid")
  
  corretst(mergetwo[,2], mergetwo[, 3])
}
