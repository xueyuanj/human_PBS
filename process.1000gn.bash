
for filename in *.gz
do
    echo $filename
    base=${filename%.gz}
    echo $base
    gunzip -c "$filename" > temp.vcf
    cat temp.vcf|grep -v \# > temp.noheader.vcf
    rm -f temp.vcf
    split -l 10000 temp.noheader.vcf segment
    rm -f temp.noheader.vcf
    for segfiles in segment*
    do
        echo $segfiles
        cat 1000genome.header.txt "$segfiles" > temp.header.vcf
        Rscript  keep.only.popofinterest.R temp.header.vcf
        rm -f temp.header.vcf
        mv temp.fst.hudson.txt "${base}.${segfiles}.txt"
        echo "${base}.${segfiles}.txt" 
        rm -f $segfiles
    done
    find -type f -name "${base}.*.txt" -exec cat {} \; > "${base}.fst.hudson.txt"
    
done
