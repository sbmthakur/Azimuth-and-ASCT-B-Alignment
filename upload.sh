#DIR_PATH=/c/Users/User/Desktop/IUB/CNS_parttime/CNS_assignment/Azimuth\ and\ ASCTB\ alignment

rscript dependencies.R
rscript extract_and_summarize.R
echo '' > index.md

LINK_PREFIX="https://github.com/maddy3940/Azimuth-and-ASCT-B-Alignment/tree/master/Data/Aligned Data"

for i in $(ls Data/Aligned\ Data/); 
do 
	link="$LINK_PREFIX/$i\n"
	echo -e "[$link]($link)" >> ./index.md; 
done
git add Data/Aligned\ Data/*.csv
git add index.md
git commit -m "Add index.md and csv files"

git push origin master