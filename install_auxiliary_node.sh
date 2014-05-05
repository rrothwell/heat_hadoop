#!/bin/bash -v
# ===========================================
# Install Auxiliary Node
# Based on Cloudera Hadoop version 4
#
# Installs the following services:
#	SecondaryNameNode
# ===========================================

# Refer to this:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html

# Auxiliary: SecondaryNameNode host
# Ignore "start failed: message.
apt-get -y install hadoop-hdfs-secondarynamenode
