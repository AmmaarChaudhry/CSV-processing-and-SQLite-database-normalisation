
in_path="$1"
out_path="$2"

header=$(cat $in_path | head -n 1)



#If there is no outpath, we overwrite the input file
if [ -z $out_path ]; then
	#echo "no output path"
	#sort $in_path | uniq > $in_path
	touch tmp.csv

	sed 1d $in_path |
	awk 'BEGIN { RS="\r\n"; ORS="\0" } { print }' |
	sort -zu |
	awk 'BEGIN { RS="\0"; ORS="\r\n" } { print }' > tmp.csv
	{ echo $header; cat tmp.csv; } > $in_path

	
else
	touch tmp.csv
	sed 1d $in_path |
	awk 'BEGIN { RS="\r\n"; ORS="\0" } { print }' |
        sort -zu |
        awk 'BEGIN { RS="\0"; ORS="\r\n" } { print }' > tmp.csv
        #{ echo $header; cat $out_path; } > header_and_uniq_file && mv header_and_uniq_file $out_path
	{ echo $header; cat tmp.csv; } > $out_path
fi

#Note: Due to embedded new lines in the csv rows, using regular sort will break the csv file (it will break apart rows if they contain new lines)
#To fix this we use awk to change the end of row indicator (\r\n) into \0. Then, when sorting we indicate that we want to take \0 as the row seperator.
#At the end we reverse this, so the format is consistent with the original CSV file. We also have to remove the header line before sorting, and then add
#it back at the end.
