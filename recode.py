def counter(x):
	currdic={}
	for stuff in x:
		if stuff in currdic:
			thisone=currdic[stuff]
			newone=thisone+1
			currdic[stuff]=newone
		else:
			currdic[stuff]=1
	return currdic


snpdf=open("HGDP_snps.carja_2017.complete.txt", "r")


snpdata=snpdf.readlines()
header=snpdata[0]


recodedsnp=open("HGDP_snps.carja_2017.recoded.txt", "w")
recodedsnp.write(header)


for things in snpdata[1:]:
	datas=things.split()
	probenm=datas[0]
	recodedsnp.write(probenm+"\t")
	snplist=[]
	for therest in datas[1:]:
		snplist.append(therest[0]) 
		snplist.append(therest[1])
	counterdic=counter(snplist)
	# Get the keys sorted by dictionary values
	ordered=sorted(counterdic, key=counterdic.get, reverse=True)
	# Remove the ones when missing data is the major allel
	if len(ordered)==1:
		for i in range(0, len(datas)-1):
			recodedsnp.write("0"+"\t")
		recodedsnp.write("\n")
	elif len(ordered)==2:
		majorallele=ordered[0]
		minor=ordered[1]
		for perhaps in datas[1:]:
			if majorallele in perhaps and minor in perhaps:
				recodedsnp.write("1"+"\t")
			elif majorallele in perhaps:
				recodedsnp.write("0"+"\t")
			else:
				recodedsnp.write("2"+"\t")
		recodedsnp.write("\n")
	else:
		print "Ha?"
