#!/bin/sh -v
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
# bind_hadoop_directories.sh
# ===========================================

# Cloudera application files.
mkdir -p /mnt/lib/flume-ng
cp -a /usr/lib/flume-ng/. /mnt/lib/flume-ng/
rm -Rf /usr/lib/flume-ng
mkdir /usr/lib/flume-ng
mount --bind /mnt/lib/flume-ng /usr/lib/flume-ng

mkdir -p /mnt/lib/hadoop
cp -a /usr/lib/hadoop/. /mnt/lib/hadoop/
rm -Rf /usr/lib/hadoop
mkdir /usr/lib/hadoop
mount --bind /mnt/lib/hadoop /usr/lib/hadoop

mkdir -p /mnt/lib/hadoop-0.20-mapreduce
cp -a /usr/lib/hadoop-0.20-mapreduce/. /mnt/lib/hadoop-0.20-mapreduce/
rm -Rf /usr/lib/hadoop-0.20-mapreduce
mkdir /usr/lib/hadoop-0.20-mapreduce
mount --bind /mnt/lib/hadoop-0.20-mapreduce /usr/lib/hadoop-0.20-mapreduce

mkdir -p /mnt/lib/hadoop-hdfs
cp -a /usr/lib/hadoop-hdfs/. /mnt/lib/hadoop-hdfs/
rm -Rf /usr/lib/hadoop-hdfs
mkdir /usr/lib/hadoop-hdfs
mount --bind /mnt/lib/hadoop-hdfs /usr/lib/hadoop-hdfs

mkdir -p /mnt/lib/hadoop-httpfs
cp -a /usr/lib/hadoop-httpfs/. /mnt/lib/hadoop-httpfs/
rm -Rf /usr/lib/hadoop-httpfs
mkdir /usr/lib/hadoop-httpfs
mount --bind /mnt/lib/hadoop-httpfs /usr/lib/hadoop-httpfs

mkdir -p /mnt/lib/hadoop-mapreduce
cp -a /usr/lib/hadoop-mapreduce/. /mnt/lib/hadoop-mapreduce/
rm -Rf /usr/lib/hadoop-mapreduce
mkdir /usr/lib/hadoop-mapreduce
mount --bind /mnt/lib/hadoop-mapreduce /usr/lib/hadoop-mapreduce

mkdir -p /mnt/lib/hadoop-yarn
cp -a /usr/lib/hadoop-yarn/. /mnt/lib/hadoop-yarn/
rm -Rf /usr/lib/hadoop-yarn
mkdir /usr/lib/hadoop-yarn
mount --bind /mnt/lib/hadoop-yarn /usr/lib/hadoop-yarn

mkdir -p /mnt/lib/hbase
cp -a /usr/lib/hbase/. /mnt/lib/hbase/
rm -Rf /usr/lib/hbase
mkdir /usr/lib/hbase
mount --bind /mnt/lib/hbase /usr/lib/hbase

mkdir -p /mnt/lib/hbase-solr
cp -a /usr/lib/hbase-solr/. /mnt/lib/hbase-solr/
rm -Rf /usr/lib/hbase-solr
mkdir /usr/lib/hbase-solr
mount --bind /mnt/lib/hbase-solr /usr/lib/hbase-solr

mkdir -p /mnt/lib/hcatalog
cp -a /usr/lib/hcatalog/. /mnt/lib/hcatalog/
rm -Rf /usr/lib/hcatalog
mkdir /usr/lib/hcatalog
mount --bind /mnt/lib/hcatalog /usr/lib/hcatalog

mkdir -p /mnt/lib/hive
cp -a /usr/lib/hive/. /mnt/lib/hive/
rm -Rf /usr/lib/hive
mkdir /usr/lib/hive
mount --bind /mnt/lib/hive /usr/lib/hive

mkdir -p /mnt/lib/impala
cp -a /usr/lib/impala/. /mnt/lib/impala/
rm -Rf /usr/lib/impala
mkdir /usr/lib/impala
mount --bind /mnt/lib/impala /usr/lib/impala

mkdir -p /mnt/lib/impala-shell
cp -a /usr/lib/impala-shell/. /mnt/lib/impala-shell/
rm -Rf /usr/lib/impala-shell
mkdir /usr/lib/impala-shell
mount --bind /mnt/lib/impala-shell /usr/lib/impala-shell

mkdir -p /mnt/lib/mahout
cp -a /usr/lib/mahout/. /mnt/lib/mahout/
rm -Rf /usr/lib/mahout
mkdir /usr/lib/mahout
mount --bind /mnt/lib/mahout /usr/lib/mahout

mkdir -p /mnt/lib/oozie
cp -a /usr/lib/oozie/. /mnt/lib/oozie/
rm -Rf /usr/lib/oozie
mkdir /usr/lib/oozie
mount --bind /mnt/lib/oozie /usr/lib/oozie

mkdir -p /mnt/lib/pig
cp -a /usr/lib/pig/. /mnt/lib/pig/
rm -Rf /usr/lib/pig
mkdir /usr/lib/pig
mount --bind /mnt/lib/pig /usr/lib/pig

mkdir -p /mnt/lib/sqoop
cp -a /usr/lib/sqoop/. /mnt/lib/sqoop/
rm -Rf /usr/lib/sqoop
mkdir /usr/lib/sqoop
mount --bind /mnt/lib/sqoop /usr/lib/sqoop

mkdir -p /mnt/lib/sqoop2
cp -a /usr/lib/sqoop2/. /mnt/lib/sqoop2/
rm -Rf /usr/lib/sqoop2
mkdir /usr/lib/sqoop2
mount --bind /mnt/lib/sqoop2 /usr/lib/sqoop2

mkdir -p /mnt/lib/whirr
cp -a /usr/lib/whirr/. /mnt/lib/whirr/
rm -Rf /usr/lib/whirr
mkdir /usr/lib/whirr
mount --bind /mnt/lib/whirr /usr/lib/whirr

mkdir -p /mnt/lib/zookeeper
cp -a /usr/lib/zookeeper/. /mnt/lib/zookeeper/
rm -Rf /usr/lib/zookeeper
mkdir /usr/lib/zookeeper
mount --bind /mnt/lib/zookeeper /usr/lib/zookeeper

# Considering Cloudera extensions.
mkdir -p /mnt/opt/cloudera
cp -a /opt/cloudera/. /mnt/opt/cloudera/
rm -Rf /opt/cloudera
mkdir /opt/cloudera
mount --bind /mnt/opt/cloudera /opt/cloudera

# Cloudera home for data staging.
mkdir -p /mnt/home/cloudera
cp -a /home/cloudera/. /mnt/home/cloudera/
rm -Rf /home/cloudera
mkdir /home/cloudera
mount --bind /mnt/home/cloudera /home/cloudera

# For data we must consider hdfs storage
mkdir -p /mnt/data;   mkdir -p /data;  mount --bind /mnt/data /data
mkdir -p /mnt/nfsmount;   mkdir -p /nfsmount;  mount --bind /mnt/nfsmount /nfsmount

# For log files
mkdir -p /mnt/log/hadoop-hdfs
cp -a /var/log/hadoop-hdfs. /mnt/log/hadoop-hdfs/
rm -Rf /var/log/hadoop-hdfs
mkdir /var/log/hadoop-hdfs
mount --bind /mnt/log/hadoop-hdfs /var/log/hadoop-hdfs

mkdir -p /mnt/log/zookeeper;   mkdir -p /var/log/zookeeper;  mount --bind /mnt/log/zookeeper /var/log/zookeeper
