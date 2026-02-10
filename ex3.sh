##echo "Enter a csv filepath: "
#read filepath
#echo "Enter a named heading: "
#read heading
#echo "Enter the number of rows: "
#read rows

filepath="$1"
heading="$2"
rows="$3"

declare -i counter=0

#echo $heading

# top_line stores the header of the file
top_line="$(head -n 1 $filepath)"

#searches to check if the input heading is present in top_line
heading_check=$(echo $top_line | grep -o "$heading")


if [ -z $heading_check ]; then
	echo "Heading not found"
	exit
else
	##heading_nline swaps commas for new lines in heading, makes counting easier
	heading_nline=$(echo $top_line | sed 's/,/\n/g')
	#echo "$heading_nline"
	##for loop below identifies the numerical position of the selected header 
	IFS=$'\n'
	for  line in $heading_nline; do
		counter+=1
		#echo "$counter line: $line"
		if [ $line == $heading_check ]; then
			break
		fi
	done

fi

# sorts the file (while ignoring the header)
#file_no_header=$( tail -n+2 $filepath | sort -t "," -r -k $counter)

touch tmpe3.csv

sed 1d $filepath |
awk 'BEGIN { RS="\r\n"; ORS="\0" } { print }' |
sort -t "," -k $counter -zu -r |
awk 'BEGIN { RS="\0"; ORS="\r\n" } { print }' > tmpe3.csv


if [ -z $rows ]; then
	#echo "$file_no_header"
	echo $top_line
	cat tmpe3.csv
else
	#echo "$file_no_header" | head -n $rows
	echo $top_line
	cat tmpe3.csv | head -n $rows
fi




