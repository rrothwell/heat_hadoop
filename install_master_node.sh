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

# Edit hdfs-site.xml on master, slave 1, slave 2, slave 3 etc..
# I dont know what the significance of having an nfs mount is at this stage.
# Don't have an nfs mount so will create a proxy for it at /mnt/storage/nfs/nn
# May need to change file paths to URI's file:///
# Suspect that the use of multiple mount points (/data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn)
# doesn't make much sense when we have access to just one large (ephemeral) volume per OpenStack VM.

cat <<DELIMITER > /etc/hadoop/conf.unicarbkb/hdfs-site.xml
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
        <value>HTTP/_HOST@master0unicarbkb.doesntexist.org</value>
    </property>
    <property>
        <name>dfs.web.authentication.kerberos.keytab</name>
        <value>/etc/hadoop/conf/HTTP.keytab</value> <!-- path to the HTTP keytab -->
    </property>
    <!-- End WebHDFS config. -->
</configuration>
DELIMITER

# The list of secondarynamenodes.
cat <<DELIMITER > /etc/hadoop/conf.unicarbkb/masters
$hadoop_auxiliary_domain
DELIMITER

# Create the directories and set the permissions
# Do on all cluster members.
mkdir -p /data/1/dfs/nn /nfsmount/dfs/nn
mkdir -p /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
chown -R hdfs:hdfs /data/1/dfs/nn /nfsmount/dfs/nn /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
chmod go-rx /data/1/dfs/nn /nfsmount/dfs/nn

# Format the hdfs file system as the hdfs user.
# ON the master only is OK.
sudo -u hdfs hadoop namenode -format

# -------------------------------------------
# Deploy MRv1: MapReduce version 1
# -------------------------------------------

# Edit mapred-site.xml
cat <<DELIMITER > /etc/hadoop/conf.unicarbkb/mapred-site.xml
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
        <value>/health_check.sh</value>
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

