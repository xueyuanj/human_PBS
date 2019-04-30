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

##Expression PBS part

##Download bam files from GEUVADIS project

##List of individual bam files

$curl ftp://ftp.ebi.ac.uk/pub/databases/microarray/data/experiment/GEUV/E-GEUV-1/processed/*.bam > bam.file.list

$cat bam.file.list |grep 'bam$' > bamfile.list

##Select last column

--> bam.file.names.txt

##Use featureCounts to get the count of reads of each gene



##
##
##Sequence PBS part
##
##Download SNP data from 1000 genome website

ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/

##Modify the getfilelist.bash to download gz files for each chromosome

##
##To remove SNPs with MAF < 0.01, compute MAF. 

##Note that the MAF here is calculated using all the individuals in the dataset.

##Run remove.maf.sh on cluster. 

##remove.maf.sh is a wrapper script that implements remove.maf.R and remove.maf.bash

$ bash remove.maf.sh

##
##Calculate Hudson's Fst for each SNP site. 

##Use all the individuals in the four populations

##Keep the numerator and denominator in separate columns

##Run process.1000gn.sh on cluster

##process.1000gn.sh is wrapper script that implements process.1000gn.bash and keep.only.popofinterest

##Due to the large size, run process.1000gn.sh independently for each chromosome

##Moreover, process.1000gn.bash splits the data into smaller files each containing 10000 lines. Then go through the files

$bash process.1000gn.sh

##Afterwards, merge all the smaller files into one chromosome file

$bash merge.bash

##
##Map the SNP to genes

##The annotation file for protein-coding genes is above

##Use map.probe.py, which also removes INDEL and keep only SNPs

$ python map.probe.py

##
##Calculate ratio of average for Hudson's Fst for each gene

##Run python map.probe.py on each chromosome

##map.probe.py use all the information obtained previously, including SNP with MAP > 0.01, snp to gene map, and Hudson's Fst

$ Python map.probe.py

##
##Use the expression data to remove lowly expressed ones

##This is the working file

fst.hudson.1000genome.4pop.allindividual.ratioofave.maf0.01.pr_coding.rmlow.txt


copy.file.bash 	

recode.py 	


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
