for organ in Brain Gut Heart Kidney Liver Lung Muscle Spleen Testis Thyroid
do
	for pop in CB IR MC 
	do
		listnm="${pop}${organ}"
		mkdir $listnm
		newbashfile="get.counts.${listnm}.bash"
		newshfile="get.counts.${listnm}.sh"
		cp "get.counts.bash" $newbashfile
		cp "get.counts.sh" $newshfile
		sub1="s/get.counts.bash/${newbashfile}/g"
		echo $sub1
		sed -i $sub1 $newshfile
		newfilelist="${listnm}.files" 
		sub2="s/mouse.files/${newfilelist}/g"
		sed -i $sub2 $newbashfile
		newpath="mouse.expr\/${listnm}"
		sub3="s/mouse.expr/${newpath}/g"
		sed -i $sub3 $newshfile
		mv $newbashfile ./$listnm/$newbashfile
		mv $newshfile ./$listnm/$newshfile
		cp $newfilelist ./$listnm/$newfilelist
	done
done