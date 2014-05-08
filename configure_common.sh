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
# configure_common.sh
# ===========================================
# Create Directories and Install Common Configuration Across All Nodes
# Based on Cloudera Hadoop version 4
#
# Installs the following config files:
#	core-site.xml
# ===========================================

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
# Install Core
# -------------------------------------------

# It looks like we can just set up the config files on the master
# and then copy the master's config directory to all the slaves.
# Not sure how far to go with this; does it include the secondary namenode as well?

# Now configure our cluster. On all machines in cluster.
cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.$project_name
update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.$project_name 50
update-alternatives --set hadoop-conf /etc/hadoop/conf.$project_name

# # Edit core-site.xml on master, slave 1, slave 2, slave 3 etc..
# Its easier to edit everything on the master and when finished 
# copy the entire config directory to the other cluster members.

cat <<DELIMITER > /etc/hadoop/conf.$project_name/core-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$hadoop_master_domain/</value>
    </property>
    <!-- Begin trash configuration. -->
    <property>
        <name>fs.trash.interval</name>
        <value>60</value>
    </property>
    <property>
        <name>fs.trash.checkpoint.interval</name>
        <value>15</value>
    </property>
    <!-- End trash configuration. -->
</configuration>
DELIMITER

# The list of secondarynamenodes.
cat <<DELIMITER > /etc/hadoop/conf.$project_name/masters
$hadoop_auxiliary_domain
DELIMITER

