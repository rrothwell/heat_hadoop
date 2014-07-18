#!/bin/bash -v
# ===========================================
# Install Common Code for Node
# Based on Cloudera Hadoop version 4
#
# The base install will include:
# 	MRv1
#	HDFS
#
# Sets up:
#	Java
#	DNS
#	Access to Hadoop package.
#
# Note: NOT using HA - High Availability.

# Resources:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html
# http://akbarahmed.com/2012/06/26/install-cloudera-cdh4-with-yarn-mrv2-in-pseudo-mode-on-ubuntu-12-04-lts/
# http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/
# ===========================================

# Preparation.
apt-get -y install python-software-properties python-setuptools 
#apt-get -y python-pip
#pip install python-heatclient

# cfn tools install - needed to support install packages, start services, handle updates, and wait for applications.
#apt-get -y install python-argparse cloud-init python-psutil python-pip
#apt-get -y remove python-boto
#pip install 'boto==2.5.2' heat-cfntools
#cfn-create-aws-symlinks -s /usr/local/bin/

# Download and install Java.
./install_java.sh

# Set up DNS in /etc/hosts
# Code moved to finalise script.
#echo -e "$hadoop_instance_ip\t$hadoop_instance_domain\t$hadoop_instance_hostname\t$hadoop_instance_name" >> /etc/hosts;

# Setup access to the Hadoop packages
# Now refer to this:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html

# reference the "1 click" package. Do this for ALL machines.
wget http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb
dpkg -i cdh4-repository_1.0_all.deb
# Install the repo key.
wget -qO - http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
apt-get update

#apt-get install zookeeper zookeeper-server
#zookeeper-server init --myid=1 # --force
#service zookeeper-server start
#vi /etc/zookeeper/conf.dist/zoo.cfg

# We use this to move files into position after they are transfered to the installer directory by the master.
apt-get install  inoticoming



