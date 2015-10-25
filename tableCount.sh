#!/bin/bash
#Script to count the number of entries in dynamodb table using parallel scan
#first argument tablename. second scan regions (use value based on table size)
COUNTER=0
totalCount=0;
while [  $COUNTER -lt $2 ]; do
    output=$(aws dynamodb scan --table-name $1 --select COUNT --total-segments $2 --segment $COUNTER|grep ScannedCount|awk -F ":" '{print $2}')
    count=$(echo $output|sed -e 's/,//g')
    echo "count from segment $COUNTER : $count"
    let totalCount=totalCount+count	
    let COUNTER=COUNTER+1 
    done	
echo "Total Count is :"
echo $totalCount

