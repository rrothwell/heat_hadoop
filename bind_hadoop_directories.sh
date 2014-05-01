#!/bin/sh

# Cloudera application files.
#sudo mkdir -p /mnt/lib/flume-ng;  sudo mkdir -p /usr/lib/flume-ng;  sudo mount --bind /mnt/lib/flume-ng /usr/lib/flume-ng
sudo mkdir -p /mnt/lib/flume-ng
sudo cp -a /usr/lib/flume-ng/. /mnt/lib/flume-ng/
sudo rm -Rf /usr/lib/flume-ng
sudo mkdir /usr/lib/flume-ng
sudo mount --bind /mnt/lib/flume-ng /usr/lib/flume-ng

#sudo mkdir -p /mnt/lib/hadoop;  sudo mkdir -p /usr/lib/hadoop;  sudo mount --bind /mnt/lib/hadoop /usr/lib/hadoop
sudo mkdir -p /mnt/lib/hadoop
sudo cp -a /usr/lib/hadoop/. /mnt/lib/hadoop/
sudo rm -Rf /usr/lib/hadoop
sudo mkdir /usr/lib/hadoop
sudo mount --bind /mnt/lib/hadoop /usr/lib/hadoop

#sudo mkdir -p /mnt/lib/hadoop-0.20-mapreduce;  sudo mkdir -p /usr/lib/hadoop-0.20-mapreduce;  sudo mount --bind /mnt/lib/hadoop-0.20-mapreduce /usr/lib/hadoop-0.20-mapreduce
sudo mkdir -p /mnt/lib/hadoop-0.20-mapreduce
sudo cp -a /usr/lib/hadoop-0.20-mapreduce/. /mnt/lib/hadoop-0.20-mapreduce/
sudo rm -Rf /usr/lib/hadoop-0.20-mapreduce
sudo mkdir /usr/lib/hadoop-0.20-mapreduce
sudo mount --bind /mnt/lib/hadoop-0.20-mapreduce /usr/lib/hadoop-0.20-mapreduce

#sudo mkdir -p /mnt/lib/hadoop-hdfs;  sudo mkdir -p /usr/lib/hadoop-hdfs;  sudo mount --bind /mnt/lib/hadoop-hdfs /usr/lib/hadoop-hdfs
sudo mkdir -p /mnt/lib/hadoop-hdfs
sudo cp -a /usr/lib/hadoop-hdfs/. /mnt/lib/hadoop-hdfs/
sudo rm -Rf /usr/lib/hadoop-hdfs
sudo mkdir /usr/lib/hadoop-hdfs
sudo mount --bind /mnt/lib/hadoop-hdfs /usr/lib/hadoop-hdfs

#sudo mkdir -p /mnt/lib/hadoop-httpfs;  sudo mkdir -p /usr/lib/hadoop-httpfs;  sudo mount --bind /mnt/lib/hadoop-httpfs /usr/lib/hadoop-httpfs
sudo mkdir -p /mnt/lib/hadoop-httpfs
sudo cp -a /usr/lib/hadoop-httpfs/. /mnt/lib/hadoop-httpfs/
sudo rm -Rf /usr/lib/hadoop-httpfs
sudo mkdir /usr/lib/hadoop-httpfs
sudo mount --bind /mnt/lib/hadoop-httpfs /usr/lib/hadoop-httpfs

#sudo mkdir -p /mnt/lib/hadoop-mapreduce;  sudo mkdir -p /usr/lib/hadoop-mapreduce;  sudo mount --bind /mnt/lib/hadoop-mapreduce /usr/lib/hadoop-mapreduce
sudo mkdir -p /mnt/lib/hadoop-mapreduce
sudo cp -a /usr/lib/hadoop-mapreduce/. /mnt/lib/hadoop-mapreduce/
sudo rm -Rf /usr/lib/hadoop-mapreduce
sudo mkdir /usr/lib/hadoop-mapreduce
sudo mount --bind /mnt/lib/hadoop-mapreduce /usr/lib/hadoop-mapreduce

#sudo mkdir -p /mnt/lib/hadoop-yarn;  sudo mkdir -p /usr/lib/hadoop-yarn;  sudo mount --bind /mnt/lib/hadoop-yarn /usr/lib/hadoop-yarn
sudo mkdir -p /mnt/lib/hadoop-yarn
sudo cp -a /usr/lib/hadoop-yarn/. /mnt/lib/hadoop-yarn/
sudo rm -Rf /usr/lib/hadoop-yarn
sudo mkdir /usr/lib/hadoop-yarn
sudo mount --bind /mnt/lib/hadoop-yarn /usr/lib/hadoop-yarn

#sudo mkdir -p /mnt/lib/hbase;  sudo mkdir -p /usr/lib/hbase;  sudo mount --bind /mnt/lib/hbase /usr/lib/hbase
sudo mkdir -p /mnt/lib/hbase
sudo cp -a /usr/lib/hbase/. /mnt/lib/hbase/
sudo rm -Rf /usr/lib/hbase
sudo mkdir /usr/lib/hbase
sudo mount --bind /mnt/lib/hbase /usr/lib/hbase

#sudo mkdir -p /mnt/lib/hbase-solr;  sudo mkdir -p /usr/lib/hbase-solr;  sudo mount --bind /mnt/lib/hbase-solr /usr/lib/hbase-solr
sudo mkdir -p /mnt/lib/hbase-solr
sudo cp -a /usr/lib/hbase-solr/. /mnt/lib/hbase-solr/
sudo rm -Rf /usr/lib/hbase-solr
sudo mkdir /usr/lib/hbase-solr
sudo mount --bind /mnt/lib/hbase-solr /usr/lib/hbase-solr

#sudo mkdir -p /mnt/lib/hcatalog;  sudo mkdir -p /usr/lib/hcatalog;  sudo mount --bind /mnt/lib/hcatalog /usr/lib/hcatalog
sudo mkdir -p /mnt/lib/hcatalog
sudo cp -a /usr/lib/hcatalog/. /mnt/lib/hcatalog/
sudo rm -Rf /usr/lib/hcatalog
sudo mkdir /usr/lib/hcatalog
sudo mount --bind /mnt/lib/hcatalog /usr/lib/hcatalog

#sudo mkdir -p /mnt/lib/hive;  sudo mkdir -p /usr/lib/hive;  sudo mount --bind /mnt/lib/hive /usr/lib/hive
sudo mkdir -p /mnt/lib/hive
sudo cp -a /usr/lib/hive/. /mnt/lib/hive/
sudo rm -Rf /usr/lib/hive
sudo mkdir /usr/lib/hive
sudo mount --bind /mnt/lib/hive /usr/lib/hive

#sudo mkdir -p /mnt/lib/impala;  sudo mkdir -p /usr/lib/impala;  sudo mount --bind /mnt/lib/impala /usr/lib/impala
sudo mkdir -p /mnt/lib/impala
sudo cp -a /usr/lib/impala/. /mnt/lib/impala/
sudo rm -Rf /usr/lib/impala
sudo mkdir /usr/lib/impala
sudo mount --bind /mnt/lib/impala /usr/lib/impala

#sudo mkdir -p /mnt/lib/impala-shell;  sudo mkdir -p /usr/lib/impala-shell;  sudo mount --bind /mnt/lib/impala-shell /usr/lib/impala-shell
sudo mkdir -p /mnt/lib/impala-shell
sudo cp -a /usr/lib/impala-shell/. /mnt/lib/impala-shell/
sudo rm -Rf /usr/lib/impala-shell
sudo mkdir /usr/lib/impala-shell
sudo mount --bind /mnt/lib/impala-shell /usr/lib/impala-shell

#sudo mkdir -p /mnt/lib/mahout;  sudo mkdir -p /usr/lib/mahout;  sudo mount --bind /mnt/lib/mahout /usr/lib/mahout
sudo mkdir -p /mnt/lib/mahout
sudo cp -a /usr/lib/mahout/. /mnt/lib/mahout/
sudo rm -Rf /usr/lib/mahout
sudo mkdir /usr/lib/mahout
sudo mount --bind /mnt/lib/mahout /usr/lib/mahout

#sudo mkdir -p /mnt/lib/oozie;  sudo mkdir -p /usr/lib/oozie;  sudo mount --bind /mnt/lib/oozie /usr/lib/oozie
sudo mkdir -p /mnt/lib/oozie
sudo cp -a /usr/lib/oozie/. /mnt/lib/oozie/
sudo rm -Rf /usr/lib/oozie
sudo mkdir /usr/lib/oozie
sudo mount --bind /mnt/lib/oozie /usr/lib/oozie

#sudo mkdir -p /mnt/lib/pig;  sudo mkdir -p /usr/lib/pig;  sudo mount --bind /mnt/lib/pig /usr/lib/pig
sudo mkdir -p /mnt/lib/pig
sudo cp -a /usr/lib/pig/. /mnt/lib/pig/
sudo rm -Rf /usr/lib/pig
sudo mkdir /usr/lib/pig
sudo mount --bind /mnt/lib/pig /usr/lib/pig

#sudo mkdir -p /mnt/lib/sqoop;  sudo mkdir -p /usr/lib/sqoop;  sudo mount --bind /mnt/lib/sqoop /usr/lib/sqoop
sudo mkdir -p /mnt/lib/sqoop
sudo cp -a /usr/lib/sqoop/. /mnt/lib/sqoop/
sudo rm -Rf /usr/lib/sqoop
sudo mkdir /usr/lib/sqoop
sudo mount --bind /mnt/lib/sqoop /usr/lib/sqoop

#sudo mkdir -p /mnt/lib/sqoop2;  sudo mkdir -p /usr/lib/sqoop2;  sudo mount --bind /mnt/lib/sqoop2 /usr/lib/sqoop2
sudo mkdir -p /mnt/lib/sqoop2
sudo cp -a /usr/lib/sqoop2/. /mnt/lib/sqoop2/
sudo rm -Rf /usr/lib/sqoop2
sudo mkdir /usr/lib/sqoop2
sudo mount --bind /mnt/lib/sqoop2 /usr/lib/sqoop2

#sudo mkdir -p /mnt/lib/whirr;  sudo mkdir -p /usr/lib/whirr;  sudo mount --bind /mnt/lib/whirr /usr/lib/whirr
sudo mkdir -p /mnt/lib/whirr
sudo cp -a /usr/lib/whirr/. /mnt/lib/whirr/
sudo rm -Rf /usr/lib/whirr
sudo mkdir /usr/lib/whirr
sudo mount --bind /mnt/lib/whirr /usr/lib/whirr

#sudo mkdir -p /mnt/lib/zookeeper;  sudo mkdir -p /usr/lib/zookeeper;  sudo mount --bind /mnt/lib/zookeeper /usr/lib/zookeeper
sudo mkdir -p /mnt/lib/zookeeper
sudo cp -a /usr/lib/zookeeper/. /mnt/lib/zookeeper/
sudo rm -Rf /usr/lib/zookeeper
sudo mkdir /usr/lib/zookeeper
sudo mount --bind /mnt/lib/zookeeper /usr/lib/zookeeper

# Considering Cloudera extensions.
#sudo mkdir -p /mnt/opt/cloudera;  sudo mkdir -p /opt/cloudera;  sudo mount --bind /mnt/opt/cloudera /opt/cloudera
sudo mkdir -p /mnt/opt/cloudera
sudo cp -a /opt/cloudera/. /mnt/opt/cloudera/
sudo rm -Rf /opt/cloudera
sudo mkdir /opt/cloudera
sudo mount --bind /mnt/opt/cloudera /opt/cloudera

# Cloudera home for data staging.
#sudo mkdir -p /mnt/home/cloudera;  sudo mkdir -p /home/cloudera;  sudo mount --bind /mnt/home/cloudera /home/cloudera
sudo mkdir -p /mnt/home/cloudera
sudo cp -a /home/cloudera/. /mnt/home/cloudera/
sudo rm -Rf /home/cloudera
sudo mkdir /home/cloudera
sudo mount --bind /mnt/home/cloudera /home/cloudera

# For data we must consider hdfs storage
sudo mkdir -p /mnt/data;   sudo mkdir -p /data;  sudo mount --bind /mnt/data /data
sudo mkdir -p /mnt/nfsmount;   sudo mkdir -p /nfsmount;  sudo mount --bind /mnt/nfsmount /nfsmount

# For log files
#sudo mkdir -p /mnt/log/hadoop-hdfs;   sudo mkdir -p /var/log/hadoop-hdfs;  sudo mount --bind /mnt/log/hadoop-hdfs /var/log/hadoop-hdfs
sudo mkdir -p /mnt/log/hadoop-hdfs
sudo cp -a /var/log/hadoop-hdfs. /mnt/log/hadoop-hdfs/
sudo rm -Rf /var/log/hadoop-hdfs
sudo mkdir /var/log/hadoop-hdfs
sudo mount --bind /mnt/log/hadoop-hdfs /var/log/hadoop-hdfs

sudo mkdir -p /mnt/log/zookeeper;   sudo mkdir -p /var/log/zookeeper;  sudo mount --bind /mnt/log/zookeeper /var/log/zookeeper
