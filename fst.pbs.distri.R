library(stringr)
library(dplyr)
library(ggplot2)
library(reshape2)
setwd("/data/human_PBS/1000genome/snp/individ.all.ratio_of_average")

# Import the SNP fst data

fstinfor=list.files(path = "/data/human_PBS/1000genome/snp/individ.all.ratio_of_average", pattern = "maf_0.01" )


allthefst=data.frame(matrix(NA, nrow = 46493, ncol=ncol(pop_comb)))
allfstname=rep(NA, ncol(pop_comb))


# Subset the expression data
for (i in 1:dim(pop_comb)[2]){
  # Get the individual IDs
  curpair=unlist(strsplit(fstinfor[i], "[.]"))[9]
  print(curpair)
  # Calculate the difference between 
  currentone=read.table(fstinfor[i], header = F)
  #print(head(currentone))
  colnames(currentone) =c("geneid", "num", "den")
  fst_hudson = currentone$num/currentone$den
  fst_hudson[is.na(fst_hudson)] =0
  fst_hudson= ifelse(fst_hudson < 0, 0, fst_hudson)
  #fst_pair=currentone$fst
  allthefst[,i]=fst_hudson # change here for log plot
  allfstname[i]=curpair
  rownames(allthefst)=currentone$geneid
  
  # fst_pair=na.omit(fst_pair)
  print(median(fst_hudson))
  hist(log(fst_hudson), breaks = 500, main=curpair, xlim = c(-10,0))
}


colnames(allthefst)=allfstname
#write.table(allthefst, file = "All.fst.hudson.1000genome.allindividual.ratioofave.maf_0.01.genes.txt", row.names = T, col.names = T, quote = F, sep = "\t")

popfile=read.table("GD462.name.list.txt", header = F)
colnames(popfile)=c("individual", "pop")
population=unique(popfile[,"pop"])
population=sort(population)
pop_comb_branch=combn(population, 3)

for(i in 1:ncol(pop_comb_branch)){
  pops=as.vector(pop_comb_branch[,i])
  eachbranch=combn(pops, 2)
  relevantnm=paste(eachbranch[1,], eachbranch[2,], sep="_") 
  print(relevantnm)
  
  # Get the data of those three populations
  relevantdf=allthefst[,relevantnm]
  relevantdf=-log(1-relevantdf)
  
  # Calculate branch length for each population
  allpbs=data.frame(matrix(NA, nrow=nrow(relevantdf), ncol = length(pops), dimnames = list(NULL,pops) ))
  
  for(j in 1:length(pops)){
    minusb=paste(pops[-j], collapse ="_")
    pbs= abs(rowSums(relevantdf[,-which(names(relevantdf)==minusb)]) - relevantdf[,minusb])/2
    allpbs[,pops[j]]=pbs
  }
  
  #keep a copy
  triplet=paste(pops, collapse = "_")
  filename=paste("pbs.fst.1000genome.hudson.maf0.01.ratioofave", triplet, "txt", sep = ".")
  allpbs[,"geneid"]=rownames(allthefst)
  write.table(allpbs, file = filename, row.names = F, col.names = T, quote = F, sep = "\t")
    
  
  # allpbs=log(allpbs)
  # data=melt(allpbs, value.name = "value")
  # plots=ggplot(data, aes(x=value, fill=variable))+
  #   geom_density(alpha=0.25 )+
  #   ggtitle(paste(pops, collapse = "_"))+
  #   xlim(-10,0)+
  #   xlab("PBS")
  # print(plots)
  # 
  # boxp=ggplot(data, aes(x=variable, y=value, fill=variable))+
  #   geom_boxplot( notch = F, outlier.shape = NA)+
  #   ggtitle(paste(pops, collapse = "_"))+
  #   ylim(-10,0)
  # print(boxp)
  # 
  # print(apply(allpbs, 2, function(x)median(x, na.rm = TRUE)))
  # 
  # 
  # testresult=matrix(NA, nrow=1, ncol = 3)
  # colnames(testresult)=relevantnm
  # 
  # for(k in 1:ncol(eachbranch)){
  #   tstresult=wilcox.test(allpbs[,eachbranch[1,k]], allpbs[,eachbranch[2,k]], alternative = "two.sided")$p.value
  #   testresult[1,k]=tstresult
  # }
  # print(testresult)
}
