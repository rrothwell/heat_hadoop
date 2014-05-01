#!/bin/bash -v
# ===========================================
# Install Master Node
# Based on Cloudera Hadoop version 4
#
# Installs the following services:
#	NameNode
#	TaskTracker
# ===========================================

# Refer to this:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html

# Master: JobTracker host and  NameNode host
# Probably should have separate VM's for jobtracker and namenode.
# Ignore "start failed: message.
apt-get -y install hadoop-0.20-mapreduce-jobtracker hadoop-hdfs-namenode hadoop-client

# -------------------------------------------
# Storage Management
# -------------------------------------------

# Upload and run on ALL VM's.
# This is mainly for the master. 
# Maybe not necessary to apply the entire script to the slaves as some of the 
# directories will be for client apps only.
# If hadoop components are installed after this the relevant section in the script
# MUST be executed in isolation.
./bind_hadoop_directories.sh

# -------------------------------------------
# Install HDFS
# -------------------------------------------

# It looks like we can just set up the config files on the master
# and then copy the master's config directory to all the slaves.
# Not sure how far to go with this; does it include the secondary namenode as well?

# Now configure our cluster. On all machines in cluster.
cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.unicarbkb
update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.unicarbkb 50
update-alternatives --set hadoop-conf /etc/hadoop/conf.unicarbkb

# # Edit core-site.xml on master, slave 1, slave 2, slave 3 etc..
# Its easier to edit everything on the master and when finished 
# copy the entire config directory to the other cluster members.

cat <<DELIMITER > /etc/hadoop/conf.unicarbkb/core-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$hadoop_master_domain/</value>
    </property>
</configuration>
DELIMITER
