setwd("/data/human_PBS/1000genome.pr_coding")

prcoding = read.table("GD462.est.4pop.deseq.fpkm.log.pr_coding.rmlow.txt", header = T)

hvalues = list.files(path= "/data/human_PBS/1000genome.pr_coding", pattern = "pst.5h2values") 

hs = c("0.5", "0.6", "0.7", "0.8", "0.9", "1")

for (i in 1:6) {           # go through the h values 
  # gather all the pairs of populations
  allpoppst = as.data.frame(matrix(data=NA, nrow=20736, ncol = 6))
  for (j in 1:length(hvalues)) {
    pstfile = read.table(hvalues[j], header = T)
    allpoppst[,j] = pstfile[,i]
  }
  colnames(allpoppst) = c("FIN_GBR", "FIN_TSI", "FIN_YRI", "GBR_TSI", "GBR_YRI", "TSI_YRI")
  rownames(allpoppst) = rownames(pstfile)
  allpoppst = allpoppst[rownames(allpoppst)%in%rownames(prcoding),]
  
  # keep a copy for PHYLIP
  write.table(allpoppst, row.names = T, col.names = T,
  quote = F, file = paste("pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2", hs[i], "txt", sep = "."))
  # plot the density
  # print(sort(apply(allpoppst, 2, median), decreasing = F))
  # data=melt(allpoppst, value.name = "value")
  # plots=ggplot(data, aes(x=value, fill=variable))+
  #   geom_density(alpha=0.25 )+
  #   ggtitle(paste("h =",hs[i], sep = " "))+
  #   xlim(-0.2,1.1)+
  #   xlab("Pst")
  # print(plots)
  
  #ggsave(paste("pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h", hs[i], "jpeg", sep = "."), plot=plots)
}
