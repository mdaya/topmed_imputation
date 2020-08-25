#!/bin/bash

if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <impute_dir> <zip_password>"
    exit
fi

impute_dir=$1
zip_password=$2


cd $impute_dir
for ((chr=1; chr<=22; chr++)); do
    7z e chr_${chr}.zip -y -p$zip_password
done
