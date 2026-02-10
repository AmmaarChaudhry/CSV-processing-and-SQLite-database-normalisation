#!/bin/bash

#echo "Enter a url: "
#read user_url
#echo "Enter a filepath: "
#read filepath

user_url="$1"
filepath="$2"

#user_url="https://ofb-interactive.soton.ac.uk/files/cw/faculties.csv"

if [ -z "$filepath" ]; then
	        
	#echo "No filepath inputted"
	curl $user_url | head
else
	curl -o $filepath $user_url
        #echo "a filepath was detected"
fi


#curl https://ofb-interactive.soton.ac.uk/files/cw/students.csv -o students.csv
#curl https://ofb-interactive.soton.ac.uk/files/cw/faculties.csv -o faculties.csv


#head students.csv
#head faculties.csv
