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
# start_hdfs_master.sh
# ===========================================
# Create Directories and Install Common Configuration Across All Nodes
# Based on Cloudera Hadoop version 4
#
# ===========================================

echo "Startup the HDFS file system."

# -------------------------------------------
# Format and Start HDFS
# -------------------------------------------

# Format the hdfs file system as the hdfs user.
# ON the master only is OK.
sudo -u hdfs hadoop namenode -format
service hadoop-hdfs-namenode start
service hadoop-0.20-mapreduce-jobtracker start
