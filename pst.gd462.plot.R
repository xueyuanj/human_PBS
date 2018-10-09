# Pst part
library(stringr)
library(dplyr)
library(ggplot2)
library(reshape2)
setwd("/data/human_PBS/1000genome")

# Get the 10 combinations of 2-population pair
popfile=read.table("GD462.name.list.txt", header = F)
colnames(popfile)=c("individual", "pop")
population=unique(popfile[,"pop"])
population=sort(population)
pop_comb=combn(population, 2)

# Import the expression data
expdf=read.table("GD462.GeneQuantRPKM.50FN.samplename.resk10.txt", header = TRUE)

# Pst function
pst=function(gb, gw, h){
  pst_result=gb/(gb+2*gw*(h^2))
  return(pst_result)
}

# Do the calculation
for (i in 1:dim(pop_comb)[2]){
  # Get the individual IDs
  curpair=pop_comb[,i]
  pop_1=filter(popfile, pop==curpair[1])%>%select(individual)%>%unlist%>%as.vector
  pop_2=filter(popfile, pop==curpair[2])%>%select(individual)%>%unlist%>%as.vector
  
  # Get the expression data for two populations
  pop_1_exp=expdf[,which(colnames(expdf)%in%pop_1)]  ;pop_2_exp=expdf[,which(colnames(expdf)%in%pop_2)]
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
  
  # Try h=0.5 to h=1
  hrange=seq(0.5,1,0.1)
  hmatrix=sapply(hrange, pst, gb=pop_all_exp[,"between"], gw= pop_all_exp[,"within"]/(ncol(pop_1_exp)+ncol(pop_2_exp)-2))
  colnames(hmatrix)=paste("h=", hrange, sep = "")
  hmatrix=as.data.frame(hmatrix)
  hmatrix[,"geneid"] = substr(expdf[,"TargetID"],1,15)
  hmatrix[,"within"] = pop_all_exp[,"within"]/(ncol(pop_1_exp)+ncol(pop_2_exp)-2)
  hmatrix[,"between"] = pop_all_exp[,"between"]
  print(head(hmatrix))
  filename=paste(curpair[1],"_", curpair[2], ".pst.expr.gd462.bw.geneid.txt", sep = "")
  # keep of copy of Pst with different h values
  write.table(hmatrix, file = filename, quote = F, col.names = T, row.names = F, sep = "\t")
  
  # Plot the density, superimpose difference h-values
  # print(mean(hmatrix, na.rm=TRUE))
  #data=melt(hmatrix)
  
  # plots=ggplot(data, aes(x=value, fill=Var2))+
  #   geom_density(alpha=0.25 )+
  #   ggtitle(paste(curpair[1],"and", curpair[2], sep = " " ))
  # print(plots)
}
