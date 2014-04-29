# ===========================================
# Install Cloudera Hadoop version 4
# ===========================================
# Resources:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html
# http://akbarahmed.com/2012/06/26/install-cloudera-cdh4-with-yarn-mrv2-in-pseudo-mode-on-ubuntu-12-04-lts/
# http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/

# Note: NOT using HA - High Availability.

# -------------------------------------------
# Preparation
# -------------------------------------------

# Create in the NeCTAR dashboard, from the Ubuntu 12.04 (precise) image:
# m1.small, default/cluster/management security groups, sa availability zone.
# master0unicarbkb
# slave1unicarbkb
# slave2unicarbkb
# slave3unicarbkb

# Starting up
sudo apt-get update; sudo apt-get upgrade
sudo updatedb

# Download and install Java on ALL machines.
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_29.html
# And: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_29_1.html?scroll=topic_29_1
# But as far as I can tell the instructions there are not necessary as far as setting
# JAVA_HOME and PATH are concerned.

# From Oracle via RPM.
# It will be necessary to navigate to the web page and approve the licence
# and then copy the URL.
##### No: wget http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm

# Better java installation.
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
sudo update-java-alternatives -s java-7-oracle
sudo apt-get install oracle-java7-set-default

# Or just wack this in.
#sudo add-apt-repository ppa:webupd8team/java; sudo apt-get update; sudo apt-get install oracle-java7-installer; sudo update-java-alternatives -s java-7-oracle; sudo apt-get install oracle-java7-set-default

# Check with
java -version
# Below will work after the Hadoop stuff runs.
echo $JAVA_HOME

# -------------------------------------------
# Networking
# -------------------------------------------

# https://account.dyn.com/dns/dyndns/
# 130.220.208.92 master0unicarbkb.doesntexist.org
# 130.220.208.183 slave1unicarbkb.doesntexist.org
# 130.220.209.13 slave2unicarbkb.doesntexist.org
# 130.220.209.16 slave3unicarbkb.doesntexist.org

# Adjust /etc/hostname. Just short form is OK but need the short aliases in place in /etc/hosts.
# Will need to perform a soft reboot.
# E.g.
# master0unicarbkb
sudo vi /etc/hostname
# Note: /etc/sysconfig/network is not there on Ubuntu.

# Adjust /etc/hosts to map IP address seen in dashboard to 
# fully qualified domain name equivalent to name in /etc/hostname
# Will need to perform a soft reboot.
# E.g.
# 127.0.0.1 localhost
130.220.208.92 master0unicarbkb.doesntexist.org master0unicarbkb
130.220.208.183 slave1unicarbkb.doesntexist.org slave1unicarbkb
130.220.209.13 slave2unicarbkb.doesntexist.org slave2unicarbkb
130.220.209.16 slave3unicarbkb.doesntexist.org slave3unicarbkb

## The following lines are desirable for IPv6 capable hosts
# ::1 ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters
# ff02::3 ip6-allhosts

sudo vi /etc/hosts

# -------------------------------------------
# Setup the Hadoop Cluster Structure
# -------------------------------------------

# Now refer to this:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html

# install the "1 click" package. Do this for ALL machines.
wget http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb
sudo dpkg -i cdh4-repository_1.0_all.deb

# On each of the VM's in the cluster download and install the repo key.
curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -

# Install CHD4 with MRv1
# master runs the NameNode and JobTracker
# slave 1 runs the secondary name node
# slave 2, 3 runs the DataNode and the TaskTracker

# master: JobTracker host and  NameNode host
# Probably should have separate VM's for each.
# Ignore "start failed: message.
sudo apt-get update; sudo apt-get install hadoop-0.20-mapreduce-jobtracker
sudo apt-get update; sudo apt-get install hadoop-hdfs-namenode
sudo apt-get update; sudo apt-get install hadoop-client

# slave 1: SecondaryNameNode. Probably should be on an additional VM.
sudo apt-get update; sudo apt-get install hadoop-hdfs-secondarynamenode

# slave 1, 2 and 3
sudo apt-get update; sudo apt-get install hadoop-0.20-mapreduce-tasktracker hadoop-hdfs-datanode

# -------------------------------------------
# Storage Management
# -------------------------------------------

# Upload and run on ALL VM's.
# This is mainly for the master. 
# Maybe not necessary to apply the entire script to the slaves as some of the 
# directories will be for client apps only.
# If hadoop components are installed after this the relevant section in the script
# MUST be executed in isolation.
sudo ./bind_hadoop_directories.sh

# -------------------------------------------
# Install HDFS
# -------------------------------------------

# It looks like we can just set up the config files on the master
# and then copy the master's config directory to all the slaves.
# Not sure how far to go with this; does it include the secondary namenode as well?

# Now configure our cluster. On all machines in cluster.
sudo cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.unicarbkb

# Configure everything individually 
# OR just upload and unpack the pre-configured conf.unicarbkb directory to each member of the cluster.
# As shown on the next 2 lines.
# The process following that assumes we need to build the config files from scratch.
cd /
sudo tar -xvf ~/conf.unicarbkb.tgz

sudo update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.unicarbkb 50
sudo update-alternatives --set hadoop-conf /etc/hadoop/conf.unicarbkb

# Edit core-site.xml on master, slave 1, slave 2, slave 3 etc..
# Its easier to edit everything on the master and when finished 
# copy the entire config directory to the other cluster members.
sudo vi /etc/hadoop/conf.unicarbkb/core-site.xml
#<configuration>
#        <property>
#                <name>fs.defaultFS</name>
#                <value>hdfs://master0unicarbkb.doesntexist.org/</value>
#        </property>
#</configuration>

# Edit hdfs-site.xml on master, slave 1, slave 2, slave 3 etc..
# I dont know what the significance of having an nfs mount is at this stage.
# Don't have an nfs mount so will create a proxy for it at /mnt/storage/nfs/nn
# May need to change file paths to URI's file:///
# Suspect that the use of multiple mount points (/data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn)
# doesn't make much sense when we have access to just one large (ephemeral) volume per OpenStack VM.

sudo vi /etc/hadoop/conf.unicarbkb/hdfs-site.xml
#<configuration>
#  <property>
#     <name>dfs.name.dir</name>
#     <value>/var/lib/hadoop-hdfs/cache/hdfs/dfs/name</value>
#  </property>
#  <property>
#       <name>dfs.permissions.superusergroup</name>
#      <value>hadoop</value>
#  </property>
#  <property>
#    <name>dfs.namenode.name.dir</name>
#    <value>file:///data/1/dfs/nn,file:///nfsmount/dfs/nn</value>
#  </property>
#  <property>
#    <name>dfs.datanode.data.dir</name>
#    <value>file:///data/1/dfs/dn,file:///data/2/dfs/dn,file:///data/3/dfs/dn,file:///data/4/dfs/dn</value>
#  </property>
#  <property>
#    <name>dfs.datanode.failed.volumes.tolerated</name>
#    <value>3</value>
#  </property>
#</configuration>

# Create the directories and set the permissions
# Move this to install_cloudera_1click.sh 
# Do on all cluster members.
sudo mkdir -p /data/1/dfs/nn /nfsmount/dfs/nn
sudo mkdir -p /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
sudo chown -R hdfs:hdfs /data/1/dfs/nn /nfsmount/dfs/nn /data/1/dfs/dn /data/2/dfs/dn /data/3/dfs/dn /data/4/dfs/dn
sudo chmod go-rx /data/1/dfs/nn /nfsmount/dfs/nn

# Format the hdfs file system as the hdfs user.
# ON the master only is OK.
sudo -u hdfs hadoop namenode -format

# Configure nfs file system mount
# Not yet working
# mount -t nfs -o tcp,soft,intr,timeo=10,retrans=10, <server>:<export> <mount_point>
#where <server> is the remote host, <export> is the exported file system, and <mount_point> is the local mount point

# -------------------------------------------
# Configure the secondary name node
# -------------------------------------------
# Resource: http://blog.cloudera.com/blog/2009/02/multi-host-secondarynamenode-configuration/
# Ideally the secondary name node should be run on a separate VM, neither master or slave.
# In master0 create the masters file and add the hostname of the 
# VM where the secondary name node will run.
sudo vi /etc/hadoop/conf.unicarbkb/masters

# the content is:
# slave1unicarbkb.doesntexist.org

# In slave1 add the following to hdfs-site.xml to point back to the name node machine.
# <property>
#    <name>dfs.namenode.http-address</name>
#    <value>master0unicarbkb.doesntexist.org:50070</value>
#    <description>The address and the base port on which the dfs NameNode Web UI will listen.
#    </description>
# </property>
  
# -------------------------------------------
# Miscellaneous
# -------------------------------------------

# Configure trash. Edit core-site.xml on all machines.
sudo vi /etc/hadoop/conf.unicarbkb/core-site.xml
# <property>
#     <name>fs.trash.interval</name>
#     <value>60</value>
#     </property>
# <property>
#     <name>fs.trash.checkpoint.interval</name>
#     <value>15</value>
# </property>

# Configure WebHDFS.
# On all cluster machines:
sudo vi /etc/hadoop/conf.unicarbkb/hdfs-site.xml
#  <property>
#    <name>dfs.webhdfs.enabled</name>
#    <value>true</value>
#  </property>
#  <property>
#    <name>dfs.web.authentication.kerberos.principal</name>
#    <value>HTTP/_HOST@master0unicarbkb.doesntexist.org</value>
#  </property>
#  <property>
#    <name>dfs.web.authentication.kerberos.keytab</name>
#    <value>/etc/hadoop/conf/HTTP.keytab</value> <!-- path to the HTTP keytab -->
#  </property>

# -------------------------------------------
# Deploy MRv1: MapReduce version 1
# -------------------------------------------

# Edit mapred-site.xml
sudo vi /etc/hadoop/conf.unicarbkb/mapred-site.xml
# With content
#<configuration>
#  <property>
#    <name>mapred.job.tracker</name>
#    <value>master0unicarbkb.doesntexist.org:8021</value>
#  </property>
#  <property>
#    <name>mapred.local.dir</name>
#    <value>/data/1/mapred/local,/data/2/mapred/local,/data/3/mapred/local,/data/4/mapred/local</value>
#  </property>
#</configuration>

# Create the directories and set the permissions.
# Do this on all cluster machines. Otherwise tasktracker can't start up.
# Maybe move this to bind_hadoop_directories.sh
sudo mkdir -p /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local
sudo chown -R mapred:hadoop /data/1/mapred/local /data/2/mapred/local /data/3/mapred/local /data/4/mapred/local

# Create a health check script on each data node/slave:
#sudo vi health_check.sh
# With content:
 
cat > health_check.sh << EOF
#!/bin/bash
if ! jps | grep -q DataNode ; then
 echo ERROR: datanode not up
fi
EOF
sudo mv health_check.sh /etc/hadoop/con f.unicarbkb
#chown/chmod for execution by TaskTracker

sudo vi /etc/hadoop/conf.unicarbkb/mapred-site.xml
# With content
#<configuration>
#  <property>
#    <name>mapred.healthChecker.script.path</name>
#    <value>/health_check.sh</value>
#  </property>
#  <property>
#    <name>mapred.healthChecker.interval</name>
#    <value>5000</value>
#  </property>
#  <property>
#    <name>mapred.healthChecker.script.timeout</name>
#    <value>50000</value>
#  </property>
#  <property>
#    <name>mapred.healthChecker.script.args</name>
#    <value></value>
#  </property>
#</configuration>

# -------------------------------------------
# Distribute the configuration to the Slaves
# -------------------------------------------

# Push the custom configuration directory to all nodes on the cluster
# Create a public/private key pair in .ssh on the master
ssh-keygen -t rsa -b 4096
# Call the file when prompted cluster_master_rsa, do not specify a password.
# Copy cluster_master_rsa to the desktop using ssh and then copy up to the slaves.
# Cat the public key file to authorized keys
cd ~/.ssh; cat cluster_master_rsa.pub >> authorized_keys
# Fix the permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

#sudo scp -r /etc/hadoop/conf.unicarbkb ubuntu@master0unicarbkb.doesntexist.org:/etc/hadoop/conf.unicarbkb
sudo scp -r -i ~/.ssh/cluster_master_rsa /etc/hadoop/conf.unicarbkb ubuntu@slave1unicarbkb.doesntexist.org:conf.unicarbkb
sudo scp -r -i ~/.ssh/cluster_master_rsa /etc/hadoop/conf.unicarbkb ubuntu@slave2unicarbkb.doesntexist.org:conf.unicarbkb
sudo scp -r -i ~/.ssh/cluster_master_rsa /etc/hadoop/conf.unicarbkb ubuntu@slave3unicarbkb.doesntexist.org:conf.unicarbkb

# Login to the respective slaves again and move the configuration files:
sudo mv ~/conf.unicarbkb /etc/hadoop/conf.unicarbkb
sudo chown -R root:root /etc/hadoop/conf.unicarbkb

# Set alternatives. On ALL machines in the cluster.
sudo update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.unicarbkb 50
sudo update-alternatives --set hadoop-conf /etc/hadoop/conf.unicarbkb

# Start HDFS on ALL cluster nodes.
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done
# Check out and log for failures.
# OR just use 
sudo service --status-all
# to identify the services adnd stat them up as follows:
# On the master
sudo service hadoop-hdfs-namenode start
# On slave 1
sudo service hadoop-hdfs-secondarynamenode start
# On slave 1, 2 and 3
sudo service hadoop-hdfs-datanode start

# Create the HDFS /tmp Directory
# Since there is only one distributed file system 
# I am assuming this only has to be done on the master
# and then the slaves will pick it up.
sudo -u hdfs hadoop fs -mkdir /tmp
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp

# Create MapReduce /var directories
# Since there is only one distributed file system 
# I am assuming this only has to be done on the master
# and then the slaves will pick it up.
sudo -u hdfs hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
sudo -u hdfs hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
sudo -u hdfs hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred

# Verify the HDFS File Structure, on each member of the cluster.
sudo -u hdfs hadoop fs -ls -R /
# Got this which is sort of OK but the owner was expected, according to the docs, 
#  to be "hdfs supergroup" instead of "hdfs hadoop":
# Do I need to "fix" this?
# No, in hdfs-site.xml dfs.permissions.supergroup is define to be hadoop.
# drwxrwxrwt   - hdfs hadoop          0 2014-02-24 00:15 /tmp
# drwxr-xr-x   - hdfs hadoop          0 2014-02-24 00:18 /var
# drwxr-xr-x   - hdfs hadoop          0 2014-02-24 00:18 /var/lib
# drwxr-xr-x   - hdfs hadoop          0 2014-02-24 00:18 /var/lib/hadoop-hdfs
# drwxr-xr-x   - hdfs hadoop          0 2014-02-24 00:18 /var/lib/hadoop-hdfs/cache
# drwxr-xr-x   - mapred hadoop          0 2014-02-24 00:18 /var/lib/hadoop-hdfs/cache/mapred
# drwxr-xr-x   - mapred hadoop          0 2014-02-24 00:18 /var/lib/hadoop-hdfs/cache/mapred/mapred
# drwxrwxrwt   - mapred hadoop          0 2014-02-24 00:18 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging

# Create and Configure the mapred.system.dir Directory in HDFS
sudo -u hdfs hadoop fs -mkdir /tmp/mapred/system
sudo -u hdfs hadoop fs -chown mapred:hadoop /tmp/mapred/system

# Start MapReduce
# On ALL the slaves.
sudo service hadoop-0.20-mapreduce-tasktracker start
# On the master
sudo service hadoop-0.20-mapreduce-jobtracker start

# Create the user accounts with home directories
sudo useradd -d /home/rrothwell -m rrothwell
sudo useradd -d /home/mcampbell -m mcampbell

# Create a Home Directory for each MapReduce User. Do this on the master.
sudo -u hdfs hadoop fs -mkdir  /user/mcampbell; sudo -u hdfs hadoop fs -chown mcampbell /user/mcampbell
sudo -u hdfs hadoop fs -mkdir  /user/rrothwell; sudo -u hdfs hadoop fs -chown rrothwell /user/rrothwell

# Run on startup configuration
# On the master
sudo update-rc.d hadoop-hdfs-namenode defaults
sudo update-rc.d hadoop-0.20-mapreduce-jobtracker defaults
# On slave 1.
sudo update-rc.d hadoop-hdfs-secondarynamenode defaults
# On ALL slaves
sudo update-rc.d hadoop-0.20-mapreduce-tasktracker defaults
sudo update-rc.d hadoop-hdfs-datanode defaults
# But all commands complained that the startup stuff was already in place. So not needed?

# -------------------------------------------
# Done! Testing map reduce next.
# -------------------------------------------

# Check storage usage.
# Master.
df -h
# Result 
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/vda1       9.9G  1.6G  7.9G  17% /
# udev            2.0G   12K  2.0G   1% /dev
# tmpfs           792M  224K  791M   1% /run
# none            5.0M     0  5.0M   0% /run/lock
# none            2.0G     0  2.0G   0% /run/shm
# /dev/vdb         30G  173M   28G   1% /mnt

# Slave
# Result 
# ubuntu@slave2unicarbkb:~$ df -h
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/vda1       9.9G  1.5G  7.9G  16% /
# udev            2.0G  8.0K  2.0G   1% /dev
# tmpfs           792M  228K  791M   1% /run
# none            5.0M     0  5.0M   0% /run/lock
# none            2.0G     0  2.0G   0% /run/shm
# /dev/vdb         30G  173M   28G   1% /mnt

# In the OpenStack Dashboard, add a management security group for web interfaces to Hadoop
# 50070 = NameNode daemon
# 50030 = JobTracker daemon
# 50060 = TaskTracker daemon
# 50075
# 7180  = Cloudera Monitor

# Address this later:
# 2014-02-24 22:56:16,925 WARN org.apache.hadoop.mapred.TaskTracker: TaskTracker's totalMemoryAllottedForTasks is -1 and reserved physical memory is not configured. TaskMemoryManager is disabled.










