#!/usr/bin/env bash


GTF=Mus_musculus.GRCm38.93.chr.gtf
BAM=accepted_hits.bam


while read p; do
	echo "$p"
	base=${p%/accepted_hits.bam}
	outf="${base}.counts.txt"
	url="http://wwwuser.gwdg.de/~evolbio/evolgen/wildmouse/m_m_domesticus/transcriptomes/bam_gtf/"
	downloads=$url$p
	wget $downloads
	./featureCounts -p -a $GTF  -o $outf $BAM
	rm -f $BAM
done <mouse.files