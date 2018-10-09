import glob, re

poppairs=["CEU_FIN", "CEU_GRB", "CEU_TSI", "CEU_YRI", "FIN_GRB", "FIN_TSI", "FIN_YRI", "GRB_TSI", "GRB_YRI", "TSI_YRI"]

i=1

# the SNPs with MAF > 0.01
largesnps =[]
larsnp=open("ALL.chr"+str(i)+".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.maf.txt.bigthan0.01", "r")
larsnpdf=larsnp.readlines()
for snpinfor in larsnpdf:
	snpid=snpinfor.split()[2]
	largesnps.append(snpid)

print len(largesnps)
snpgenef=open("snp.genes.1000genome.fst.hudson.chr"+str(i)+".matches.txt", "r")

snpgenedic={}
snpdf=snpgenef.readlines()
for snps in snpdf:
	snpid=snps.split()[3]
	geneid=snps.split()[0]
	if snpid in largesnps:
		if geneid in snpgenedic:
			snpgenedic[geneid].append(snpid)
		else:
			snpgenedic[geneid]=[snpid]
	else:
		continue
	print snpgenedic	
print len(snpgenedic)

fstfile=open("ALL.chr"+str(i)+".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.fst.hudson.txt", "r")
fstinfor=fstfile.readlines()


for j in range(0,10):
	snpdic={}
	currentp = poppairs[j]
	print currentp
	cleanfilenm="snp.genes.1000genome.allindividualin5pop.fst.hudron.raioofave.maf0.01."+currentp+".chr"+str(i)+".txt"
	print cleanfilenm
	cleanfile=open(cleanfilenm, "w")
	for fsts in fstinfor:
		numerator=fsts.split()[j*2+5]
		denominator=fsts.split()[j*2+6]
		snpid=fsts.split()[2]
		snpdic[snpid] = [float(numerator), float(denominator)]
	#loop through the genes
	for genes in snpgenedic:
		associatedsnp=snpgenedic[genes]
		fst_num=0
		fst_den=0
		for snpshaha in associatedsnp:
			if snpshaha in snpdic:
				fst_num+=snpdic[snpshaha][0]
				fst_den+=snpdic[snpshaha][1]
		cleanfile.write(genes+"\t" +str(fst_num)+"\t"+str(fst_den)+ "\n")


"""
for pairs in pairfiles:
	genefstfile=pairs+".gene"
	genefstdf=open(genefstfile, "w")
	snpdic={}
	pairdf=open(pairs, "r")
	fstinfor=pairdf.readlines()[1:]
	for fsts in fstinfor:
		numerator=fsts.split()[3]
		denominator=fsts.split()[4]
		snpid=fsts.split()[0]
		snpdic[snpid] = [float(numerator), float(denominator)]
	# loop through the genes
	for genes in snpgenedic:
		associatedsnp=snpgenedic[genes]
		fst_num=0
		fst_den=0
		for snpshaha in associatedsnp:
			if snpshaha in snpdic:
				fst_num+=snpdic[snpshaha][0]
				fst_den+=snpdic[snpshaha][1]
		genefstdf.write(genes+"\t" +str(fst_num)+"\t"+str(fst_den)+ "\n")

"""
