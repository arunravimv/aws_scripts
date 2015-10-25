#!/bin/bash
#bash inspect.sh 2015-10-25 13:25:56 member_id
#PS: date given above is in UTC
#script to find time of upload of a json that ends with memberid (json is inside zip)
mkdir -p inspectTempDir
target=$(date -d $1" "$2 '+%Y-%m-%d %H:%M:%S');
echo $target;
aws s3 ls s3://my-bucket/order/ims/ --summarize|awk -v tDate="$target" -F " " '{thisDate=$1" "$2; if(thisDate>=tDate) print $4;}'|head -n -2|xargs -I zip aws s3 cp s3://my-bucket/order/ims/zip inspectTempDir/
find inspectTempDir -maxdepth 1 -type f|xargs -I file sh -c 'export f="file"; unzip $f -d `echo $f|cut -d. -f1`;rm $f'
echo "Obtaining time, by which this members transaction was uploaded";
find inspectTempDir -maxdepth 2 -type f|grep "$3.json"|awk -F "/" '{print $2".zip"}'|xargs -I zip aws s3 ls s3://my-bucket/order/ims/zip --summarize
rm -r inspectTempDir;
