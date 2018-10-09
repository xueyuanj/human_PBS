#!/bin/bash          

        
for i in {2..22}
do
	echo $i
	cp ratio.of.average.py "ratio.of.average.$i.py"
	sub="s/i=1/i=${i}/g"
	echo $sub
	sed -i $sub "ratio.of.average.$i.py"
	cp running.1.sh "running.$i.sh"
	sub2="s/average.py/average.${i}.py/g" 
	sed -i $sub2 "running.$i.sh"q
done
