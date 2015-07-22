#!/bin/bash
set -x

# TODO add check for no args
# TODO (optional) check if arg is of type *.tar.gz

TAR=$1
EXTRACT_DIR=`tar tzf  $TAR | head -1 | sed -e 's@/.*@@'`
tar -xzvf $TAR

sudo mkdir -p /usr/lib/jvm

sudo mv $EXTRACT_DIR /usr/lib/jvm
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$EXTRACT_DIR/bin/java" 1
sudo update-alternatives --set java /usr/lib/jvm/$EXTRACT_DIR/bin/java
java -version

# TODO add check: if this file with this data is already present, do not write to it
echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -

sudo -E apt-get update
sudo -E apt-get install --assume-yes dsc22 cassandra-tools

sudo service cassandra stop
sudo rm -rf /var/lib/cassandra/data/system/*
