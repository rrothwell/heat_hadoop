#!/bin/bash -v
# ===========================================
# Configure Master Node
# Based on Cloudera Hadoop version 4
#
# Configures the following services:
#	NameNode
# ===========================================

echo -n "Slaves: $hadoop_slave_list"

echo -n "" > slaves
COUNTER=1
IFS=","
for slave in $hadoop_slave_list; do
    echo "$hadoop_slave_name-$COUNTER.$hadoop_base_domain" >> slaves
    COUNTER=$((COUNTER+1))
done


echo <<DELIMITER > /etc/zookeeper/conf.dist/zoo.cfg
maxClientCnxns=50
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
dataDir=/var/lib/zookeeper
# the port at which the clients will connect
clientPort=2181
DELIMITER

#server.2=slave1unicarbkb.doesntexist.org:2888:3888
#server.3=slave2unicarbkb.doesntexist.org:2888:3888
#server.4=slave3unicarbkb.doesntexist.org:2888:3888

COUNTER=1
IFS=","
for slave in $hadoop_slave_list; do
    echo "server.$COUNTER=$hadoop_slave_name-$COUNTER.$hadoop_base_domain:2888:3888" >> /etc/zookeeper/conf.dist/zoo.cfg
    COUNTER=$((COUNTER+1))
done
