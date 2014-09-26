#! /bin/bash
export OS_REGION_NAME=RegionOne
export OS_IDENTITY_API_VERSION=2.0
export OS_PASSWORD=<PASS>
export OS_AUTH_URL=http://10.135.126.20:5000/v2.0
export OS_USERNAME=demo
export OS_TENANT_NAME=demo
export OS_VOLUME_API_VERSION=2
export OS_CACERT=/opt/stack/data/CA/int-ca/ca-chain.pem
export OS_NO_CACHE=1

IMG_ID=$(glance image-list | grep datastax-cassandra | awk '{print $2}')

# TODO add support for multiple seed nodes
export SEED_NODES=1
export TOTAL_NODES=1
export NODE_FLAVOR=m1.small

# Append an integer per script run so that it becomes easy to distinguish between
# different script runs
RAND_INT=$RANDOM

for i in $(seq 1 $TOTAL_NODES); do
    nova boot --image $IMG_ID --flavor $NODE_FLAVOR --key-name \
        rushi --nic net-id=96ff1d4f-5777-429d-8547-16d724b911ae --user-data seed-userdata.sh \
        cassandra$RAND_INT-$i | grep "^| id " | awk '{print $4}'
done
