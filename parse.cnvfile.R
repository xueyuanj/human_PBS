library(dplyr)

setwd("/data/human_PBS/1000genome.pr_coding")

cnvfile = read.table("GRCh37_hg19_variants_2016-05-15.txt", header = T, sep = "\t")

variantones = filter(cnvfile, varianttype=="CNV")%>%select(variantsubtype, genes)

# Keep a copy of the variant information

write.table(variantones, file = "GRCh37_hg19_variants_2016-05-15.genenames.txt", row.names = F, 
            col.names = T, quote = F, sep = "\t")
#variantgeneids = as.vector(variantones$genes)
