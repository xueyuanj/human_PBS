import re

def check_in(x, y):
	if int(x) > int(y[0]) and int(x) < int(y[1]):
		return True
	else:
		return False

chrnum=[]
for i in range(1,23):
	#chrnum.append(str(
#i="X"
	expfile="Homo_sapiens.GRCh37.75.noheader.gene." +str(i)+ ".pr_coding.gtf"
	expf=open(expfile, "r")
	methyfile="variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502." + str(i) + ".txt"
	methydf=open(methyfile, "r")
	resultfile= "snp.genes.1000genome.fst.hudson.chr"+ str(i) + ".matches.txt"
	resultdf=open(resultfile, "w")
	expdata=expf.readlines()
	methydata=methydf.readlines()
	for hualu in methydata:
		position=hualu.split()[1]
		snp1= hualu.split()[3]
		snp2= hualu.split()[4]
		if len(snp1)==1 and len(snp2)==1:
			for shui in expdata:
				start=shui.split()[3]
				end=shui.split()[4]
				geneid=shui.split()[9]
				geneid_r=re.search("\w+", geneid).group(0)
				genecoor=[start, end]
				if check_in(position, genecoor):
					print position, genecoor
					resultdf.write(geneid_r+"\t"+hualu.strip("\n")+ "\n")
				else:
					continue


#snpdf=open("variant.1000genome.phase3_shapeit2_mvncall_integrated_v5b.20130502.1.txt", "r")

#snpdata=snpdf.readlines()
