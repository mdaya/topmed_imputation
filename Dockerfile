# work from latest LTS ubuntu release
FROM ubuntu:16.04

# run update and install necessary tools ubuntu tools
RUN apt-get update -y && apt-get install -y \
    curl \
    p7zip-full 

# install script to download and extract results
COPY unzip_imp_server_results.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/unzip_imp_server_results.sh

