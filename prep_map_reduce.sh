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
# prep_map_reduce.sh
# ===========================================
# Set up the directory structure in the HDFS 
# and run a test map reduce job.
# Based on Cloudera Hadoop version 4
#
# ===========================================


echo "Final prep and test of the map reduce system."

# Remote account details.
user=$installer_account_username
password=$installer_account_password

# -------------------------------------------
# Create the HDFS /tmp Directory
# -------------------------------------------

sudo -u hdfs hdfs dfs -mkdir /tmp
sudo -u hdfs hdfs dfs -chmod -R 1777 /tmp

# -------------------------------------------
# Create MapReduce /var directories
# -------------------------------------------

sudo -u hdfs hdfs dfs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
sudo -u hdfs hdfs dfs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
sudo -u hdfs hdfs dfs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred

# -------------------------------------------
# Create and Configure the mapred.system.dir Directory in the HDFS
# -------------------------------------------

sudo -u hdfs hdfs dfs -mkdir /tmp/mapred/system
sudo -u hdfs hdfs dfs -chown mapred:hadoop /tmp/mapred/system

# -------------------------------------------
# Start the map reduce system.
# -------------------------------------------

# Start JobTracker before TaskTracker.
service hadoop-0.20-mapreduce-jobtracker start

IFS=","
for slave_node_ip in $hadoop_slave_list; do
	echo "About to start task tracker on slave $slave_node_ip.\n"
	sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$slave_node_ip 'bash -s' <<ENDSSH
	touch ~/mapred_start
ENDSSH
done


# -------------------------------------------
# Now test the installation.
#
# Create the user unix accounts with home directories.
# Give the users superuser privileges in hadoop.
# Create a HDFS Home Directory for each MapReduce User. Do this on the master.
# -------------------------------------------

useradd -d /home/joebloggs -m joebloggs
usermod -a -G hadoop joebloggs
sudo -u hdfs hdfs dfs -mkdir  /user/bbaggins; sudo -u hdfs hdfs dfs -chown bbaggins /user/bbaggins

useradd -d /home/bbaggins -m bbaggins
usermod -a -G hadoop bbaggins
sudo -u hdfs hdfs dfs -mkdir  /user/joebloggs; sudo -u hdfs hdfs dfs -chown joebloggs /user/joebloggs

# Verify.
# ls /home
# sudo -u hdfs hdfs dfs -ls -R /

# -------------------------------------------
# Download test content
# -------------------------------------------

cd ~
mkdir map_reduce-test-data; cd map_reduce-test-data
wget http://www.gutenberg.org/cache/epub/20417/pg20417.txt; \
wget http://www.gutenberg.org/cache/epub/5000/pg5000.txt; \
wget http://www.gutenberg.org/cache/epub/4300/pg4300.txt; \
wget http://www.gutenberg.org/cache/epub/132/pg132.txt; \
wget http://www.gutenberg.org/cache/epub/1661/pg1661.txt; \
wget http://www.gutenberg.org/cache/epub/972/pg972.txt; \
wget http://www.gutenberg.org/cache/epub/19699/pg19699.txt
cd ~
cp -R map_reduce-test-data /home/joebloggs
chown -R joebloggs:hadoop /home/joebloggs/map_reduce-test-data
sudo -u joebloggs hdfs dfs -copyFromLocal /home/joebloggs/map_reduce-test-data /user/joebloggs

#sudo -u hdfs hdfs dfs -ls -R /

# -------------------------------------------
# Define an output directory in the the HDFS
# -------------------------------------------

sudo -u joebloggs hdfs dfs -mkdir -p /user/joebloggs/test_output
sudo -u joebloggs hdfs dfs -chmod ugo+w /user/joebloggs/test_output

# -------------------------------------------
# Now run the job. Do this by hand.
# -------------------------------------------

#sudo  -u joebloggs hadoop jar /usr/lib/hadoop-0.20-mapreduce/hadoop-examples.jar wordcount /user/joebloggs/map_reduce-test-data /user/joebloggs/test_output/gutenberg-output
#sudo -u hdfs hdfs dfs -ls -R /
#sudo -u hdfs hdfs dfs -cat /user/joebloggs/test_output/gutenberg-output/part-r-00000
#sudo -u joebloggs hdfs dfs -rm -R /user/joebloggs/test_output/gutenberg-output





