#PBS -l walltime=96:00:00
#PBS -l nodes=1:ppn=8
#PBS -l pmem=2gb
#PBS -m abe
#PBS -M xjj5003@psu.edu
#PBS -j oe

# module load python/2.7.9 #as in $module av python  
cd /storage/home/xjj5003/scratch/human.bam
date

bash get.counts.bash

date
