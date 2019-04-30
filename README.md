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

Remomve the header

$cat  ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.vcf |grep -v \#|cut -f 1-5 > variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt

Keep only SNP

$awk 'length($4)==1&&length($5)==1' variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt > snp.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.txt


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
