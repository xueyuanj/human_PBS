import glob

files=glob.glob("snp.gene.chr*.clean.vcf.header.*")

for snpfile in files:
	thissnpf=open(snpfile, "r")
	newfile=open(snpfile+".verticalline", "w")
	snpdata=thissnpf.readlines()
	for stuff in snpdata:
		if "./." in stuff:
			pass
		else:
			newfile.write(stuff.replace("/", "|"))