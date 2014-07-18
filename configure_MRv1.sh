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
# configure_MRv1.sh
# ===========================================
# Create Directories and Install MapReduce v1 Configuration Across All Master and Slave Nodes
# Based on Cloudera Hadoop version 4
#
# ===========================================

# -------------------------------------------
# Deploy MRv1: MapReduce version 1
# -------------------------------------------

# Edit mapred-site.xml
cat <<DELIMITER > /etc/hadoop/conf.$project_name/mapred-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapred.job.tracker</name>
        <value>$hadoop_master_domain:8021</value>
    </property>
    <property>
        <name>mapred.local.dir</name>
        <value>/data/1/mapred/local,/data/2/mapred/local,/data/3/mapred/local,/data/4/mapred/local</value>
    </property>
    <!-- Begin Health Checker - health check script runs on slaves/datanodes. -->
    <property>
        <name>mapred.healthChecker.script.path</name>
        <value>/etc/hadoop/conf.$project_name/health_check.sh</value>
    </property>
    <property>
        <name>mapred.healthChecker.interval</name>
        <value>5000</value>
    </property>
    <property>
        <name>mapred.healthChecker.script.timeout</name>
        <value>50000</value>
    </property>
    <property>
        <name>mapred.healthChecker.script.args</name>
        <value></value>
    </property>
    <!-- End Health Checker. -->
</configuration>
DELIMITER


# Create the directories and set the permissions.
# Do this on all cluster machines. Otherwise tasktracker can't start up.
# Maybe move this to bind_hadoop_directories.sh
mkdir -p /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local
chown -R mapred:hadoop /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local
