setwd("/data/human_PBS/1000genome/expression")


library(stringr)
library(dplyr)
library(ggplot2)
library(reshape2)


# Get the 10 combinations of 2-population pair
popfile=read.table("GD462.name.uniq.list.txt", header = F)
colnames(popfile) = c( "individual", "pop")
popfile= popfile[which(popfile$pop!="CEU"),]
population=sort(unique(popfile[,"pop"]))
pop_comb=combn(population, 2)

# Import the expression data

expdf.ori=read.table("GD462.fpkm.deseq2.4populations.txt", header = TRUE)

# log transform the fpkm values
expdf = log(expdf.ori[, 3:ncol(expdf.ori)]+1)

# Pst function
pst=function(gb, gw, h){
  pst_result=gb/(gb+2*gw*h)
  return(pst_result)
}

# Do the calculation
for (i in 1:dim(pop_comb)[2]){
  # Get the individual IDs
  curpair=pop_comb[,i]
  pop_1=filter(popfile, pop==curpair[1])%>%select(individual)%>%unlist%>%as.vector
  pop_2=filter(popfile, pop==curpair[2])%>%select(individual)%>%unlist%>%as.vector
  
  # Get the expression data for two populations
  pop_1_exp=expdf[,which(colnames(expdf)%in%pop_1)];pop_2_exp=expdf[,which(colnames(expdf)%in%pop_2)]
  pop_all_exp=cbind(pop_1_exp, pop_2_exp)
  
  # Calculate the mean of all the populations
  pop_all_exp[,"mean_all"]=rowSums(pop_all_exp)/ncol(pop_all_exp)
  
  # Calculate the mean of the two population respectively
  pop_all_exp[,"mean_pop1"]=rowSums(pop_1_exp)/ncol(pop_1_exp)
  pop_all_exp[,"mean_pop2"]=rowSums(pop_2_exp)/ncol(pop_2_exp)
  
  # Calculate variation within
  pop_all_exp[,"within"]=rowSums((pop_1_exp - pop_all_exp[,"mean_pop1"])^2)+rowSums((pop_2_exp - pop_all_exp[,"mean_pop2"])^2)
  
  # Calculate variation among
  pop_all_exp[,"between"]=ncol(pop_1_exp)*(pop_all_exp[,"mean_pop1"]-pop_all_exp[,"mean_all"])^2 +
    ncol(pop_2_exp)*(pop_all_exp[,"mean_pop2"]-pop_all_exp[,"mean_all"])^2
  
  # Try h^2=0.5 to h^2=1
  hrange=seq(0.5,1,0.1)
  hmatrix=sapply(hrange, pst, gb=pop_all_exp[,"between"], gw= pop_all_exp[,"within"]/(ncol(pop_1_exp)+ncol(pop_2_exp)-2))
  colnames(hmatrix)=paste("h=", hrange, sep = "")
  rownames(hmatrix) = expdf.ori$Geneid

 hmatrix=as.data.frame(hmatrix)
 hmatrix[,"sigma_between"] = pop_all_exp[,"between"]
 hmatrix[,"sigma_within"] = pop_all_exp[,"within"]/(ncol(pop_1_exp)+ncol(pop_2_exp)-2)
 write.table(hmatrix, file = paste(paste(curpair, collapse = "_"), "pst.5h2values.4pop.fpkm.log.txt", sep = "."), quote = F, row.names = T, col.names = T)
  # 
  
  # Plot the density, superimpose difference h-values
  # print(mean(hmatrix, na.rm=TRUE))
  # data=melt(hmatrix)
  # 
  # plots=ggplot(data, aes(x=value, fill=Var2))+
  #   geom_density(alpha=0.25 )+
  #   ggtitle(paste(curpair[1],"and", curpair[2], sep = " " ))
  # print(plots)
}
