#!/bin/bash -v
# ===========================================
# Copyright NeCTAR, May 2014, all rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions 
# and limitations under the License.
# ===========================================
# install_slave_node.sh
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
