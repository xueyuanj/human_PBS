# Population-specific sequence and expression differentiation in Europeans
The goal is the examine the population-specific divergence of genes
##
##
## Annotation file 

##GRCh37.75

remove the header, then keep only protein-coding genes

$awk '$2=="protein_coding"&&$3=="gene"{print}' Homo_sapiens.GRCh37.75.noheader.gtf > Homo_sapiens.GRCh37.75.noheader.protein_coding.gene.gtf

There are 22810 genes.
##
##

## 1. Gene expression analyses

### 1.1 Download bam files from GEUVADIS project

##List of individual bam files

$curl ftp://ftp.ebi.ac.uk/pub/databases/microarray/data/experiment/GEUV/E-GEUV-1/processed/*.bam > bam.file.list

$cat bam.file.list |grep 'bam$' > bamfile.list

##Select last column

--> bam.file.names.txt

### 1.2 Use featureCounts to get the number of reads for each gene

##Run get.counts.sh on cluster

##get.counts.sh is a wrapper script which implements get.counts.bash

$bash get.counts.sh

--> human.featurecounts.summary.txt

##
### 1.3 Use DESeq2 to normalize the count data and get FPKM value

##Remove the CEU population

##Remove lowly-expressed genes: the ones don't have at least 10 reads on each sample

##Normalization applies the "median ratio method"

$R get.fpkm.4pop.R

--> GD462.fpkm.deseq2.4populations.txt

##
### 1.4 Calculate P<sub>ST</sub> when h<sup>2</sup> =0.5 and h<sup>2</sup>=1

##Log transform the FPKM by log(FPKM+1)

##The script will give h<sup>2</sup> =0.5, 0.6, 0.7, 0.8, 0.9, and 1 for each population pair

$R pst.expr.1000gn.R

--> #.pst.5h2values.4pop.fpkm.log.txt

##Merge the population pairs for P<sub>ST</sub> when h<sup>2</sup> =0.5 and h<sup>2</sup>=1

$ R pst.6hvalues.R

--> pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2.0.5.txt

--> pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2.1.txt


##
##
## 2. Population-genetic analyses
##
### 2.1 Download SNP data from 1000 genome website

ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/

##Modify the getfilelist.bash to download gz files for each chromosome

##
### 2.2 To remove SNPs with MAF < 0.01, compute MAF. 

##Note that the MAF here is calculated using all the individuals in the dataset.

##Run remove.maf.sh on cluster. 

##remove.maf.sh is a wrapper script that implements remove.maf.R and remove.maf.bash

$ bash remove.maf.sh

##
### 2.3 Calculate Hudson's F<sub>ST</sub> for each SNP site. 

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
### 2.4 Map the SNP to genes

##The annotation file for protein-coding genes is above

##Use map.probe.py, which also removes INDEL and keep only SNPs

$ python map.probe.py

##
### 2.5 Calculate ratio of average for Hudson's F<sub>ST</sub> for each gene

##Run python map.probe.py on each chromosome

##map.probe.py use all the information obtained previously, including SNP with MAP > 0.01, snp to gene map, and Hudson's F<sub>ST</sub>

$ Python map.probe.py

##
##Use the expression data to remove lowly expressed ones

##This is the working file

fst.hudson.1000genome.4pop.allindividual.ratioofave.maf0.01.pr_coding.rmlow.txt

##
##
## 3. Phylogenetic analyses
##
### 3.1 Construct population tree using PHYLIP

##This part generates Figure 1

##Convert the F<sub>ST</sub> and P<sub>ST</sub> file into a matrix

$ python get.matrix.py

--> fst.hudson.1000genome.4pop.allindividual.ratioofave.maf0.01.pr_coding.rmlow.phylip

--> pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2.0.5.phylip

--> pst.4pop.deseq.fpkm.log.pr_coding.rmlow.h2.1.phylip
	
##Run neighbor program in PHYLIP package to get gene trees

##The algorithm used is UPGMA, which is implemented by neighbor program

$ neighbor

##Parameters in order: N, M, 12977(sequence)/13075(expression), random seed, 1, Y

##Run consense to get the population tree based on gene trees

$ consense

##Parameter: R

##
### 3.2 Calculate sequence and expression PBS<sub>4</sub>

##Log transform the F<sub>ST</sub> and P<sub>ST</sub> by E<sub>X,Y</sub> = (1-Z<sub>ST</sub>(X,Y))

##Follow the formula:

##PBS<sub>4,A</sub> = 1/4(2E<sub>A,B</sub> + E<sub>A,C</sub> + E<sub>A,D</sub> - E<sub>B,C</sub> - E<sub>B,D</sub>)

