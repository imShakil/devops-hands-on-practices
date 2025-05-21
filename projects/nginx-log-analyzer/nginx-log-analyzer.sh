#!/usr/bin/bash

# given a nginx-access.log file as an argument
# Analyze nginx-access.log and report
# - Top 5 IP Address with the most requests
# - Top 5 most requested paths 
# - Top 5 response status code
# - Top 5 user agents


# check if file path is provided
if [ $# -eq 0 ]; then
    echo "Error: No such file is found"
    echo "Usage: $0 /path/to/file"
    exit 1
fi

# read file from argument and check if exists

file=$1

if [ ! -f "$file" ]; then
    echo "Error: File doesn't exist at $file"
    exit 1
fi

echo "We are processing $file for further Analyze..."

# 

# Top 5 IP Addresses with the most requests

echo "Top 5 IP Addresses with Most Requests"
awk '{print $1}' $file | sort | uniq -c | sort --heapsort -r | awk '{printf "%s - %s requests\n", $2, $1}' | head -n 5
echo 


# Top 5 Mosts Requested paths
echo "Top 5 mosts requested paths"
awk '{print $7}' $file | sort | uniq -c | sort --heapsort -r | awk '{print $2 " - " $1 " requests" }' | head -n 5
echo

# Top 5 response status code
echo "Top 5 response status code"
grep -oE ' [1-5][0-9]{2} ' $file | sort | uniq -c | sort --heapsort -r | awk '{print $2 " - " $1 " requests" }' | head -n 5
#awk '{print $9}' $file | sort | uniq -c | sort --heapsort -r | awk '{print $2 " _ "$1}' | head -n 5
echo

# Top 5 user agents
echo "Top 5 user agents"
awk -F '"' '{print $6}' $file | sort | uniq -c | sort --heapsort -r | head -n 5
echo

