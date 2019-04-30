#!/usr/bin/env bash


GTF=Homo_sapiens.GRCh37.87.gtf



while read p; do
	echo "$p"
	base=${p%.bam}
	outf="${base}.counts.txt"
	url="ftp://ftp.ebi.ac.uk/pub/databases/microarray/data/experiment/GEUV/E-GEUV-1/processed/"
	downloads=$url$p
	echo $downloads
	wget $downloads
	./featureCounts -L -a $GTF  -o $outf $p
	rm -f $p
done <bam.file.names.txt


