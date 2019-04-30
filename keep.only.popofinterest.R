library(dplyr)
library(R.utils)
library(stringr)

setwd("/storage/home/x/xjj5003/scratch/temp")


# Get the 10 combinations of 2-population pair
popfile=read.table("snp.1000genome.indiv_pop.4pop.txt", header = F)
colnames(popfile)=c("individual", "pop")
population=unique(popfile[,"pop"])
population=sort(population)
pop_comb=combn(population, 2)


args = commandArgs(trailingOnly=TRUE)
print(args[1] )
snpdf = read.table(args[1], header = T )

fst_h_keep = snpdf[,1:5]

for (i in 1:dim(pop_comb)[2]){
  # Get the individual IDs
  curpair=pop_comb[,i]
  pop_1=filter(popfile, pop==curpair[1])%>%select(individual)%>%unlist%>%as.vector
  pop_2=filter(popfile, pop==curpair[2])%>%select(individual)%>%unlist%>%as.vector
  
  # Get the expression data for two populations
  pop_1_exp=snpdf[,which(colnames(snpdf)%in%pop_1)];pop_2_exp=snpdf[,which(colnames(snpdf)%in%pop_2)]
  
  # Calculate the p1 and p2
  fa1 = (rowSums(pop_1_exp=="0|0")*2+rowSums(pop_1_exp=="1|0") + rowSums(pop_1_exp=="0|1"))/(2*ncol(pop_1_exp))
  fa2 = (rowSums(pop_2_exp=="0|0")*2+rowSums(pop_2_exp=="1|0") + rowSums(pop_2_exp=="0|1"))/(2*ncol(pop_2_exp))
  
  
  # Calculate the numerator
  fst_num = (fa1 - fa2)^2 -fa1*(1-fa1)/(ncol(pop_1_exp)-1) - fa2*(1-fa2)/(ncol(pop_2_exp)-1)
  fst_den = fa1*(1-fa2) + fa2*(1-fa1)
  
  #fst_hudson=fst_num/fst_den
  #fst_hudson[is.na(fst_hudson)] =0
  
  
  #hist(fst_hudson, breaks = 1000, main= paste(curpair[1], curpair[2], sep = "_" ))
  
  # If Fst < 0, assign 0 to it
  
  #fst_hudson= ifelse(fst_hudson < 0, 0, fst_hudson)
  #hist(fst_hudson, breaks = 1000, main= paste(curpair[1], curpair[2], sep = "_" ))
  
  fst_h_keep = cbind(fst_h_keep , fst_num, fst_den)
  #fstfilen=paste(paste(curpair[1], curpair[2], sep = "_" ), "hudson.fst.txt", sep=".")
  print(head(fst_h_keep))
 # write.table(fst_h_keep, file = "temp.fst.hudson.txt", row.names = F,col.names=F, quote = F, sep = "\t", append = F)
}



write.table(fst_h_keep, file="temp.fst.hudson.txt", row.names=F, col.names=F, quote=F, sep="\t", append=F)

# write.table(datatokeep, file =  "1000genome.snp.test.txt" , row.names = T)
