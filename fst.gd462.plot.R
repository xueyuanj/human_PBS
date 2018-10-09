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


#allthefst=data.frame(matrix(NA, nrow = nrow(expdf), ncol=ncol(pop_comb)))
#allfstname=rep(NA, ncol(pop_comb))
#rownames(allthefst)=expdf[,"TargetID"]

# Subset the expression data
for (i in 1:dim(pop_comb)[2]){
  # Get the individual IDs
  curpair=pop_comb[,i]
  print(curpair)
  pop_1=filter(popfile, pop==curpair[1])%>%select(individual)%>%unlist%>%as.vector
  pop_2=filter(popfile, pop==curpair[2])%>%select(individual)%>%unlist%>%as.vector

  # Get the expression data for two populations
  pop_1_exp=expdf[,which(colnames(expdf)%in%pop_1)]  ;pop_2_exp=expdf[,which(colnames(expdf)%in%pop_2)]
  
  # Calculate the difference within
  pop_comb_1=combn(colnames(pop_1_exp), 2)
  pop_1_sum = apply( pop_comb_1, 2, function(x) return(abs(expdf[,x[1]]-expdf[,x[2]])) )
  pi_1=rowSums(pop_1_sum)/ncol(pop_1_sum)
  
  pop_comb_2=combn(colnames(pop_2_exp), 2)
  pop_2_sum = apply( pop_comb_2, 2, function(x) return(abs(expdf[,x[1]]-expdf[,x[2]])) )
  pi_2=rowSums(pop_2_sum)/ncol(pop_2_sum)
  
  pi_within=pi_1*length(pop_1)/sum(length(pop_1)+length(pop_2))    +pi_2*length(pop_2)/sum(length(pop_1)+length(pop_2))
  
  # Calculate the difference between 
  pop_comb_2=t(expand.grid(colnames(pop_1_exp), colnames(pop_2_exp)) )
  pop_between=apply(pop_comb_2, 2, function(x) return(abs(expdf[,x[1]]-expdf[,x[2]]) ))
  pi_between=rowSums(pop_between)/ncol(pop_between)
  
  pi_table = cbind(pi_within, pi_between)
  rownames(pi_table)=expdf[,"TargetID"]
  
  # keep a copy of the pi between and pi within
  write.table(pi_table, file = paste(paste(curpair, collapse = "_"),"est.pi_within_between.txt", sep = "."), row.names = T, col.names = T, quote = F, sep = "\t")
  
  print(head(pi_table))
  # Calculate Fst
  #fst_pair=(pi_between-pi_within)/pi_between
  #fst_pair=ifelse(fst_pair<0, 0, fst_pair)
  
  # Store them
  #allfstname[i]=paste(curpair[1], curpair[2], sep = "_" )
  #allthefst[,i]=fst_pair # change here for log plot
  
  #fst_pair=na.omit(fst_pair)
  #print(median(fst_pair))
  #plot(hist(fst_pair, breaks = 1000), main=paste(curpair[1],"and", curpair[2], sep = " " ), xlim = c(0,1), xaxs="i")
  
  
  #fst_pair=as.data.frame(fst_pair)
  
  # Plot the distribution
  # colnames(fst_pair)="Fst"
  # density_plot=ggplot(fst_pair, aes(x=Fst)) +
  #   geom_density()+
  #   xlim(-1,2)+
  #   ylim(0,1.6)+
  #   ggtitle(paste(curpair[1],"and", curpair[2], sep = " " ))
  # print(density_plot)
}


colnames(allthefst)=allfstname
data=melt(allthefst, value.name = "value")
plots=ggplot(data, aes(x=value, fill=variable))+
  geom_density(alpha=0.25 )+
  #ggtitle(paste(pops, collapse = "_"))+
  xlim(-10,0)+
  xlab("log(Est)")
print(plots)


write.table(allthefst ,file = "GD462.est.exp.v1.txt", quote=FALSE, row.names=TRUE)
