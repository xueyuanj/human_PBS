## Population-specific sequence and expression differentiation in Europeans
The goal is the examine the population-specific divergence of genes
##
##
##Annotation file 

GRCh37.75

remove the header, then keep only protein-coding genes

$awk '$2=="protein_coding"&&$3=="gene"{print}' Homo_sapiens.GRCh37.75.noheader.gtf > Homo_sapiens.GRCh37.75.noheader.protein_coding.gene.gtf

There are 22810 genes.
##
##

##Sequence PBS part
##
##Download SNP data from 1000 genome website

ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/

##
##Remomve the header

$cat  ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.vcf |grep -v \#|cut -f 1-5 > variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt

##
##Remove INDEL. Keep only SNP

$awk 'length($4)==1&&length($5)==1' variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt > snp.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt

##
##To remove SNPs with MAF < 0.01, compute MAF. 

##Note that the MAF here is calculated using all the individuals in the dataset.

##Run remove.maf.sh on cluster. 

##remove.maf.sh is a wrapper script that implements remove.maf.R and remove.maf.bash

$ bash remove.maf.sh

##
##Calculate Hudson's Fst for each SNP site. 

##Keep the numerator and denominator in separate columns

##Run process.1000gn.sh on cluster

##process.1000gn.sh is wrapper script that implements process.1000gn.bash and keep.only.popofinterest

##Due to the large size of the dataset, run process.1000gn.sh independently for each chromosome

##Moreover, process.1000gn.bash splits the data into smaller files each containing 10000 lines. Then go through the files

$bash process.1000gn.sh

##
# 

copy.file.bash 	
process.1000gn.bash 	
recode.py 	
remove.maf.R
ratio.of.average.py 	
fst.pbs.distri.R 	 
##
##
Expression PBS part: 
To get Est, PBS of Est
get.counts.bash 	
fst.gd462.plot.R 	
getfilelist.bash 	
replace.string.py 	
expr.qc.Rmd


To get Pst: 
pst.gd462.plot.R 	
