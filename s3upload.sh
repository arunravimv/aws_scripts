#!/bin/bash
#Script to upload first N files to s3 bucket from a folder
if [ "$2" == --recursive ];then
        du -sh $1
        echo "The start time is :"
        echo $(($(date +%s%N)/1000000))
        aws s3 cp $1 s3://my-bucket/$1/ $2
        echo "The end time is :"
        echo $((($(date +%s%N)-1)/1000000))
else
    	multiplier=1
        if [ $multiplier -lt $3 ];then
                multiplier=$3
        fi
	mkdir -p s3_tmp
        find $1/ -maxdepth 1 -type f |head -$2|xargs -i cp {} s3_tmp/
        du -sh s3_tmp
        echo $(($(date +%s%N)/1000000))
        COUNTER=0
        while [  $COUNTER -lt $multiplier ]; do
            aws s3 cp s3_tmp/ s3://my-bucket/$1/ --recursive
            let COUNTER=COUNTER+1
        done
	echo "The end time is :"
        echo $((($(date +%s%N)-1)/1000000))
        rm -r s3_tmp
fi


