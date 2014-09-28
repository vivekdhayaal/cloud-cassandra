Cassandra on Cloud
==================

Managing Cassandra nodes in cloud. This repository concentrates on bringing up
a Cassandra cluster, and all of it's management, on an OpenStack cloud.

Initially, there will be a shell script to bring up a Cassandra cloud. Very
soon, we'll be moving to using OpenStack Heat (also, maybe Puppet?).

Not only bringing up the cluster, but scaling, removal of dead nodes, even
multi-datacenter replication etc work is also planned.


Installation
------------
Install Cassandra on a fresh Trusty machine like so

    ./install-cassandra.sh jre-xuxx-linux-x64.tar.gz

As you can see, you will succeed only if you have Oracle's latest JRE tar file
at your hand.

Make sure you source `http_proxy` and `https_proxy` environment variables in
case you are behind proxy.


Using cloud images for deployment
---------------------------------
We'll start with using prebuilt images (images in which the operation specified
in 'Installation' section is already performed). We might change this in future
if we find that this doesn't work well with upgrades, or some other important
thing.
