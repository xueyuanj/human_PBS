library(dplyr)
library(EnvStats)
setwd("~/Documents/progress_report/2019-3-25")

duplist = read.table("GRCh37_hg19_variants_2016-05-15.ensemblid.genenames.txt", header = F, sep = "\t")
colnames(duplist) = c("ensembl", "genename", "subtype")

cleanxst = list.files(path= "~/Documents/progress_report/2019-3-25", pattern = "led.*.txt")

### Fst
  thisst = cleanxst[1]
  maintitle = unlist(strsplit(thisst, "[.]"))[2]
  print(maintitle)
  thisdf = read.table(thisst, header = T)
  
  #uplimit = median(thisdf[,4])+0.23
  # cnv versus 
  dupdf = thisdf[which(thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  singledf = thisdf[which(!thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  
  dupdf = as.data.frame(dupdf)
  singledf = as.data.frame(singledf)
  
  # print(head(dupdf))
  # Compare the CNV versu no CNV for all populations
  
  
  #par(mgp=c(1.95,1,0), mar=c(3,1,3,2.5))
  
  # Pick the max, mean and median out of the four populations
  
  ### max
  maxcnvs = apply(dupdf, 1, max)
  maxsingles= apply(singledf, 1, max)
  
  # cube root
  maxcnvs = maxcnvs^(1/3); maxsingles = maxsingles^(1/3)
  #par(mgp=c(2.5,1,0), mar=c(3,6,1,3))
  
  #par(mgp=c(3,1,0), mar=c(3,6,1,3))
  
  maxtest = as.data.frame(cbind(maxsingles, maxcnvs))
  par(mgp=c(3,1,0), mar=c(3,5.5,3.3,0.5))
  #maxcnvs = log(maxcnvs) ; maxsingles = log(maxsingles)
  boxplot(maxsingles,maxcnvs,  col = c("lightgray", "lightblue"), border = c( "black", "#225EA8"), boxlwd=3,
          ylab=expression(PBS[4]^frac(1,3)~of~italic(F)[ST]), names = c("Genes w/o CNVs", "Genes w/ CNVs"), outline = F, notch = T,
          ylim=c(0.1, 1), boxwex=0.65,  cex.lab= 3.1 , font.lab=4, cex.axis=2)  #main= expression(italic("PED")~of~italic(F['st']) ), #, expression(" of F"['st'])),  
          #cex.main= 3 )
  #abline(h = 0.9, v=0:1, lty = 1, lwd=2)
  #print(c(median(maxcnvs), median(maxsingles)))
  par(mgp=c(3.2,1.4,0), mar=c(3,5.7,4,0.5))
  boxplot(maxsingles,maxcnvs,  col = c("lightgray", "lightblue"), border = c( "black", "#225EA8"), boxlwd=4,
          ylab=expression(PBS[4]), names = c("No CNVs", "CNVs"), outline = F, notch = T, outwex= 1,
          ylim=c(0.1, 1), boxwex=0.65,  cex.lab= 3 ,  cex.axis=2.5, cex.main=3, lwd=2.3,  main=expression(italic(F)[ST]))  #main= expression(italic("PED")~of~italic(F['st']) ), #, expression(" of F"['st'])),  
  #cex.main= 3 )
  
  #print(twoSamplePermutationTestLocation(maxcnvs, maxsingles, fcn="median", alternative="two.sided", n.permutations=1000)$p.value)
  
## Pst
  
  thisst = cleanxst[2]
  maintitle = unlist(strsplit(thisst, "[.]"))[2]
  print(maintitle)
  thisdf = read.table(thisst, header = T)
  
  #uplimit = median(thisdf[,4])+0.23
  # cnv versus 
  dupdf = thisdf[which(thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  singledf = thisdf[which(!thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  
  dupdf = as.data.frame(dupdf)
  singledf = as.data.frame(singledf)
  
  # print(head(dupdf))
  # Compare the CNV versu no CNV for all populations
  
  
  #par(mgp=c(1.95,1,0))
  
  # Pick the max, mean and median out of the four populations
  
  ### max
  maxcnvs = apply(dupdf, 1, max)
  maxsingles= apply(singledf, 1, max)
  
  # cube root
  maxcnvs = maxcnvs^(1/3) ; maxsingles = maxsingles^(1/3)
  boxplot(maxsingles,maxcnvs,  border = c( "black" ,"#225EA8"), boxlwd=2.5, col = c("lightgray", "lightblue" ), 
          ylab=expression(PED[4]^frac(1,3)~of~italic(P)[ST]~"("~italic(h)^2~"= 0.5)"), names = c("Genes w/o CNVs", "Genes w/ CNVs"), outline = F, notch = T,
          ylim=c(0.5, 1.9),boxwex=0.65,  cex.lab= 3.1 , font.lab=4, cex.axis=2 ) #, main= expression(italic("PED")~of~italic(Q['st']) ), #, expression(" of F"['st'])),  
  #cex.main= 3 )
  #print(twoSamplePermutationTestLocation(maxcnvs, maxsingles, fcn="median", alternative="two.sided", n.permutations=1000)$p.value)
  #par(mgp=c(3,1.4,0), mar=c(3,5.5,2.7,0.5))
  par(mgp=c(3.2,1.4,0), mar=c(3,5.7,4,0.5))
  boxplot(maxsingles,maxcnvs,  col = c("lightgray", "lightblue"), border = c( "black", "#225EA8"), boxlwd=4,
          ylab=expression(PBS[4]), names = c("No CNVs", "CNVs"), outline = F, notch = T, outwex= 1,
          ylim=c(0.5, 1.9), boxwex=0.65,  cex.lab= 3 ,  cex.axis=2.5, cex.main=3, lwd=2.3,  main=expression(italic(P)[ST]~"("~italic(h)^2~"= 0.5)")) 
  
  
## Qst
  thisst = cleanxst[3]
  maintitle = unlist(strsplit(thisst, "[.]"))[2]
  print(maintitle)
  thisdf = read.table(thisst, header = T)
  
  #uplimit = median(thisdf[,4])+0.23
  # cnv versus 
  dupdf = thisdf[which(thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  singledf = thisdf[which(!thisdf[,5]%in%duplist[,"ensembl"]),1:4]
  
  dupdf = as.data.frame(dupdf)
  singledf = as.data.frame(singledf)
  
  # print(head(dupdf))
  # Compare the CNV versu no CNV for all populations
  
  
  #par(mgp=c(1.95,1,0))
  
  # Pick the max, mean and median out of the four populations
  
  ### max
  maxcnvs = apply(dupdf, 1, max)
  maxsingles= apply(singledf, 1, max)
  
  # cube root
  maxcnvs = maxcnvs^(1/3) ; maxsingles = maxsingles^(1/3)
  boxplot(maxsingles,maxcnvs,  border = c( "black" ,"#225EA8"), boxlwd=2.5, col = c("lightgray", "lightblue" ), 
          ylab=expression(PED[4]^frac(1,3)~of~italic(P)[ST]~"("~italic(h)^2~"= 1)"), names = c("Genes w/o CNVs", "Genes w/ CNVs"), outline = F, notch = T,
          ylim=c(0.5, 1.9), boxwex=0.65,  cex.lab= 3.1 , font.lab=4, cex.axis=2 ) #, main= expression(italic("PED")~of~italic(Q['st']) ), #, expression(" of F"['st'])),  
          #cex.main= 3 )
  print(twoSamplePermutationTestLocation(maxcnvs, maxsingles, fcn="median", alternative="two.sided", n.permutations=1000)$p.value)
  
  par(mgp=c(3.2,1.4,0), mar=c(3,5.7,4,0.5))
  boxplot(maxsingles,maxcnvs,  col = c("lightgray", "lightblue"), border = c( "black", "#225EA8"), boxlwd=4,
          ylab=expression(PBS[4]), names = c("No CNVs", "CNVs"), outline = F, notch = T, outwex= 1,
          ylim=c(0.5, 1.9), boxwex=0.65,  cex.lab= 3 ,  cex.axis=2.5, cex.main=3, lwd=2.3,  main=expression(italic(P)[ST]~"("~italic(h)^2~"= 1)")) 
  