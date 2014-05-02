#!/bin/bash -v
# ===========================================
# Configure Master Node
# Based on Cloudera Hadoop version 4
#
# Configures the following services:
#	NameNode
# ===========================================

echo -n "" > slaves
COUNTER=1
IFS=","
for instance in $INSTANCES; do
    echo "$hadoop_slave_name-$COUNTER.$hadoop_base_domain" >> slaves
    COUNTER=$((COUNTER+1))
done
