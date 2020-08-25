#!/bin/bash

download_url=$1
zip_password=$2


curl -sL $download_url | bash

for ((chr=1; chr<=22; chr++)); do
    7z e chr_${chr}.zip -y -p$zip_password
done


