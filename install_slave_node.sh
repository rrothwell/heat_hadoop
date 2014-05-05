#!/bin/bash -v
# ===========================================
# Install Slave Node
# Based on Cloudera Hadoop version 4
#
# Installs the following services:
#	DataNode
# ===========================================

# Refer to this:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html

# Master: TaskTracker host and  DataNode host
# Probably should have separate VM's for tasktracker and namenode.
# Ignore "start failed: message.
apt-get -y install hadoop-0.20-mapreduce-tasktracker hadoop-hdfs-datanode
