#!/bin/sh
#PBS -l walltime=96:00:00
#PBS -l nodes=1:ppn=8
#PBS -l pmem=2gb
#PBS -m abe
#PBS -M xjj5003@psu.edu
#PBS -j oe

module load R/3.4 #as in $module av python  
cd /storage/home/xjj5003/scratch/human_4pop/maf
date
bash remove.maf.bash
date 


