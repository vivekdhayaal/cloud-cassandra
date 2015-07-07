#!/bin/bash
set -x

# Usage: ./configure-cassandra.sh hostname publicip seeds dc_name rack_name
# TODO(Vivek Dhayaal): ensure that 5 args are passed mandatorily

sudo sh -c "sed -e 's/_listen_address_/$1/' multi-dc-config/cassandra.yaml > /etc/cassandra/cassandra.yaml"
sudo sh -c "sed -i 's/_broadcast_address_/$2/' /etc/cassandra/cassandra.yaml"
sudo sh -c "sed -i -e 's/_rpc_address_/$1/' /etc/cassandra/cassandra.yaml"
sudo sh -c "sed -i -e 's/_seeds_/$3/' /etc/cassandra/cassandra.yaml"
sudo sh -c "sed -e 's/_hostname_/$2/' multi-dc-config/cassandra-env.sh > /etc/cassandra/cassandra-env.sh"
sudo sh -c "sed -e 's/_dc_name_/$4/' multi-dc-config/cassandra-rackdc.properties > /etc/cassandra/cassandra-rackdc.properties"
sudo sh -c "sed -i -e 's/_rack_name_/$5/' /etc/cassandra/cassandra-rackdc.properties"

sudo service cassandra start

echo "waiting 30s for cassandra services start up"
sleep 30

nodetool status

