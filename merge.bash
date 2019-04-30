
for i in `seq 1 22`
do
	find  -type f -name "ALL.chr$i.*.txt" -exec cat {} \; > "snp.1000genome.fst.hudson.chr${i}.txt"
	echo $i
done
