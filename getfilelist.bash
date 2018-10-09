for organ in Brain Gut Heart Kidney Liver Lung Muscle Spleen Testis Thyroid
do
	for pop in CB IR MC 
	do
		listnm="${pop}${organ}.files"
		url="http://wwwuser.gwdg.de/~evolbio/evolgen/wildmouse/m_m_domesticus/transcriptomes/bam_gtf/"
		downloads=$url$listnm
		echo $downloads
		wget $downloads
	done
done