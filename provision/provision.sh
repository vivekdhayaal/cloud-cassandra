#! /bin/bash

set -eux

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
export NONSEED_NODES=2
export NODE_FLAVOR=m1.small

# Append an integer per script run so that it becomes easy to distinguish between
# different script runs
RAND_INT=$RANDOM

# Boot up seed nodes
nova boot --image $IMG_ID --flavor $NODE_FLAVOR --key-name \
    rushi --nic net-id=96ff1d4f-5777-429d-8547-16d724b911ae --user-data seed-userdata.sh \
    cassandra$RAND_INT-seed | grep "^| id " | awk '{print $4}'

# Wait enough to be reasonably sure that the seed node is up and working
# TODO check seed node status using nodetool command and grepping it #arghh
sleep 90

# Update nonseed-userdata.sh
SEED_IP=$(nova list  | grep $RAND_INT | awk '{print $(NF-1)}' | cut -d'=' -f2)
cp nonseed-userdata.sh nonseed-userdata-$RAND_INT.sh
sed -i s/__SEED_IP__/$SEED_IP/g nonseed-userdata-$RAND_INT.sh

for i in $(seq 1 $NONSEED_NODES); do
    nova boot --image $IMG_ID --flavor $NODE_FLAVOR --key-name \
        rushi --nic net-id=96ff1d4f-5777-429d-8547-16d724b911ae \
        --user-data nonseed-userdata-$RAND_INT.sh cassandra$RAND_INT-$i | \
        grep "^| id " | awk '{print $4}'
done

rm nonseed-userdata-$RAND_INT.sh
