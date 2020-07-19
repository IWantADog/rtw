#!/bin/sh

read -p "please input new file name : " input;
filename="${input}.rst"
filepath="$(pwd)/$(date '+%Y/%m/%d')"
full_name="${filepath}/${filename}"

if [ -f ${full_name} ]; then
	echo "!!! Sorry !!!\n${full_name} existed!"
else
	mkdir -p ${filepath}
	touch ${full_name}
	echo "${full_name} created."
fi
