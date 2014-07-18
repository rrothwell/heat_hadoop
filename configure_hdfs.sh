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
# configure_hdfs.sh
# ===========================================
# Create Directories and Install Common Configuration Across All Nodes
# Based on Cloudera Hadoop version 4
#
# Installs the following config files:
#	hdfs-site.xml
# ===========================================

echo "Establish configuration common to all cluster members."

# -------------------------------------------
# Configure HDFS
# -------------------------------------------

# Edit hdfs-site.xml on master, slave 1, slave 2, slave 3 etc..
# I don't know what the significance of having an nfs mount is at this stage.
# Don't have an nfs mount so will create a proxy for it at /mnt/storage/nfs/nn
# May need to change file paths to URI's file:///
# Suspect that the use of multiple mount points (/data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn)
# doesn't make much sense when we have access to just one large (ephemeral) volume per OpenStack VM.

cat <<DELIMITER > /etc/hadoop/conf.$project_name/hdfs-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.name.dir</name>
        <value>/var/lib/hadoop-hdfs/cache/hdfs/dfs/name</value>
    </property>
    <property>
        <name>dfs.permissions.superusergroup</name>
        <value>hadoop</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///data/1/dfs/nn,file:///nfsmount/dfs/nn</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///data/1/dfs/dn,file:///data/2/dfs/dn,file:///data/3/dfs/dn,file:///data/4/dfs/dn</value>
    </property>
    <property>
        <name>dfs.datanode.failed.volumes.tolerated</name>
        <value>3</value>
    </property>
    <!-- Begin secondarynamenode config - needs this to find the primary namenode. -->
    <property>
        <name>dfs.namenode.http-address</name>
        <value>$hadoop_master_domain:50070</value>
        <description>The address and the base port on which the dfs NameNode Web UI will listen.
        </description>
    </property>
    <!-- End secondarynamenode config. -->
    <!-- Begin WebHDFS config. -->
    <property>
        <name>dfs.webhdfs.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>dfs.web.authentication.kerberos.principal</name>
        <value>HTTP/_HOST@$hadoop_master_domain</value>
    </property>
    <property>
        <name>dfs.web.authentication.kerberos.keytab</name>
        <value>/etc/hadoop/conf/HTTP.keytab</value> <!-- path to the HTTP keytab -->
    </property>
    <!-- End WebHDFS config. -->
</configuration>
DELIMITER

# Create the directories and set the permissions
# Do on all cluster members.
mkdir -p /data/1/dfs/nn /nfsmount/dfs/nn
mkdir -p /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
chown -R hdfs:hdfs /data/1/dfs/nn /nfsmount/dfs/nn /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
chmod go-rx /data/1/dfs/nn /nfsmount/dfs/nn
