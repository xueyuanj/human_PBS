import re, glob

variantfile = open("Homo_sapiens.GRCh37.75.noheader.protein_coding.gene.gtf", "r")

variantdf = variantfile.readlines()

genenamedic = {}
genenamedic2 = {}


for variantdata in variantdf:
	ensemblid = variantdata.split()[9]
	genename = variantdata.split()[11]
	ensemblclean = re.search("\w+", ensemblid).group(0)
	nameclean = genename[1:-2]
	genenamedic[ensemblclean] = nameclean
	genenamedic2[nameclean] = ensemblclean



# conver the gene IDs, ranked gene ID/name

# xstfiles = glob.glob("led.*.abs.transformed.FIN_GBR_TSI_YRI.ranked.txt")

# for stfile in xstfiles:
# 	stdf = open(stfile, "r")
# 	newidfile = open(stfile+".genename", "w")
# 	stdata = stdf.readlines()
# 	for geneids in stdata:
# 		id1= geneids.split()[0]
# 		id2= geneids.split()[1]
# 		id3= geneids.split()[2]
# 		id4= geneids.split()[3]
# 		try:
# 			conv1=genenamedic[id1]
# 			conv2=genenamedic[id2]
# 			conv3=genenamedic[id3]
# 			conv4=genenamedic[id4]
# 			newidfile.write(id1+"\t"+ conv1+"\t" + id2+ "\t"+ conv2 + "\t"+ id3 +"\t" +conv3 + "\t"+ id4+ "\t"+ conv4+"\n")
# 		except KeyError:
# 			print "ha"



# 

# xstfiles = glob.glob("*.xabs.yrel.*")

# for stfile in xstfiles:
# 	stdf = open(stfile, "r")
# 	newidfile = open(stfile+".with_genename", "w")
# 	stdata = stdf.readlines()[1:]
# 	for geneids in stdata:
# 		id1= geneids.split()[0]
# 		tsiid = geneids.split()[1]
# 		gbrid = geneids.split()[2]
# 		finid = geneids.split()[3]
# 		yriid = geneids.split()[4]
# 		tsirel = geneids.split()[5]
# 		gbrrel = geneids.split()[6]
# 		finrel = geneids.split()[7]
# 		yrirel = geneids.split()[8]
# 		try:
# 			conv1=genenamedic[id1]
# 			newidfile.write(id1+"\t"+ conv1+"\t" + tsiid + "\t" + tsirel + "\t"  + gbrid +"\t" + gbrrel +"\t"  + finid+ "\t" +finrel +"\t"  +yriid+ "\t"+ yrirel+  "\n")
# 		except KeyError:
# 			print "ha"







# print len(genenamedic), len(genenamedic2)

humancnv = open("GRCh37_hg19_variants_2016-05-15.genenames.txt", "r")

cnvdf = humancnv.readlines()[1:]

uniqnames = {}

for cnvgenes in cnvdf:
	try:
		subtype = cnvgenes.split()[0]
		gnames = cnvgenes.split()[1]
		genelist = gnames.split(",")
		for actualgenes in genelist:
			try:
				relensemblid = genenamedic2[actualgenes]
				if relensemblid in uniqnames:
					present = uniqnames[relensemblid]
					if  subtype not in present :
						present.append(subtype)
						uniqnames[relensemblid] = present
				else:
					uniqnames[relensemblid] = [subtype]
			except KeyError:
				pass
	except IndexError:
		pass

newfiletokeep = open("GRCh37_hg19_variants_2016-05-15.ensemblid.genenames.txt", "w")

# for final in uniqnames:
# 	try:
# 		namefun = genenamedic[final]
# 		alltypes = sorted(uniqnames[final])
# 		newfiletokeep.write(final+"\t"+namefun +"\t")
# 		for heihei in alltypes:
# 			newfiletokeep.write(heihei+",")
# 		newfiletokeep.write("\n")
# 	except KeyError:
# 		pass