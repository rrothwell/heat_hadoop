#!/bin/bash
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
# start_hdfs_slave.sh
# ===========================================
# Finalise installation on slave
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the services
# ===========================================

echo "Startup ZoopKeeper"

chown :zookeeper /var/log/zookeeper
chmod g+w /var/log/zookeeper

sudo service zookeeper-server init --myid=`cat /home/installer/finaliser` --force
sudo service zookeeper-server start

service hadoop-hdfs-datanode start
service hadoop-0.20-mapreduce-tasktracker start


