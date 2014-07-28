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
# Finalise installation
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the Hadoop services
# ===========================================

echo "Establish configuration that depends on all nodes being up and running."

# Remote account details.
user=$installer_account_username
password=$installer_account_password

let expected_vm_count=hadoop_slave_count+2
echo "Expected VM count: $expected_vm_count"

# Setup for timeout.

current_time_secs=`date +%s`
# 5min as seconds
let duration_secs=5*60	
let timeout_secs=current_time_secs+duration_secs

# Loop for timeout.
# The loop checks each of the remote VM's for the existence of a file at /tmp/installation_finished.
# This file is created as the final step of the installation code on each VM.
# If a full complement of VM's is ready the setup process can be finalised.

try_counter=0
while [  $current_time_secs -lt $timeout_secs ]; do

	vm_count=0
	
	message="Installation on auxiliary $hadoop_auxiliary_ip NOT finished." 
	if sshpass -p $password scp -o StrictHostKeyChecking=no $user\@$hadoop_auxiliary_ip:/tmp/installation_finished ./ >&/dev/null ; then
		let vm_count=vm_count+1 
		message="Installation auxiliary on $hadoop_auxiliary_ip finished." ;
	fi
	echo $message
	
	message="Installation on slave $hadoop_slave_ip NOT finished." 
	if sshpass -p $password scp -o StrictHostKeyChecking=no $user\@$hadoop_slave_ip:/tmp/installation_finished ./ >&/dev/null ; then
		let vm_count=vm_count+1 
		message="Installation slave on $hadoop_slave_ip finished." ;
	fi
	echo $message
	
	slave_index=0
	IFS=","
	for slave_node_ip in $hadoop_slave_list; do
		message="Installation on slave $slave_index with IP address $slave_node_ip NOT finished." 
		if sshpass -p $password scp -o StrictHostKeyChecking=no $user\@$slave_node_ip:/tmp/installation_finished ./ >&/dev/null ; then
			let vm_count=vm_count+1 
			message="Installation on slave $slave_index with IP address $slave_node_ip is finished." ;
		fi
		echo $message
		let slave_index=slave_index+1
	done

	if [  "$vm_count" -eq "$expected_vm_count" ]; then
		break 
	fi
	let try_counter=try_counter+1 
	echo "The try count is $try_counter"
	current_time_secs=`date +%s`
	
	sleep 1
done

# Verify that timeout did not trigger. If it did we give up.

if [  "$vm_count" -eq "$expected_vm_count" ]; then
	echo "All VMs now ready to be finalised. "
else
	echo "All VMs not ready within time limit. "
	# Giveup.
	exit 1
fi

# All VM's are good, so complete the installation

# Distribute the /etc/hosts file.

# Set up DNS in /etc/hosts on master/auxiliary/slaves.
# This adds more entries to what is already set up on an instance by instance basis.

extra_hosts="\n\n# Hadoop Cluster Group\n\
\n$hadoop_master_ip\t$hadoop_master_domain\t$hadoop_master_name\
\n$hadoop_auxiliary_ip\t$hadoop_auxiliary_domain\t$hadoop_auxiliary_name\
\n$hadoop_slave_ip\t$hadoop_slave_domain_0\t$hadoop_slave_name_0"

slave_index=0
IFS=","
for slave_node_ip in $hadoop_slave_list; do
	actual_slave_name="${hadoop_slave_name}-${slave_index}"
    hadoop_slave_domain="${actual_slave_name}.${hadoop_base_domain}"
	extra_hosts+="\n$slave_node_ip\t$hadoop_slave_domain\t$actual_slave_name"
	let slave_index=slave_index+1
done

echo "About to transfer extra hosts to /etc/hosts on master $hadoop_master_ip.\n"
echo -e $extra_hosts >> /etc/hosts;

echo "About to transfer extra hosts to /etc/hosts on auxiliary $hadoop_auxiliary_ip.\n"
sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$hadoop_auxiliary_ip 'bash -s' <<ENDSSH
	touch ~/host_list
	echo -e "$extra_hosts" >> ~/host_list;
ENDSSH

echo "About to transfer extra hosts to /etc/hosts on slave $hadoop_slave_ip.\n"
sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$hadoop_slave_ip 'bash -s' <<ENDSSH
	touch ~/host_list
	echo -e "$extra_hosts" >> ~/host_list;
ENDSSH

sshpass -p 0^3Dfxx ssh -o StrictHostKeyChecking=no installer@130.220.208.118 'bash -s' <<ENDSSH
	touch ~/host_list
	echo -e "$extra_hosts" >> ~/host_list;
ENDSSH


IFS=","
for slave_node_ip in $hadoop_slave_list; do
	echo "About to transfer extra hosts to /etc/hosts on slave $slave_node_ip.\n"
	sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$slave_node_ip 'bash -s' <<ENDSSH
		touch ~/host_list
		echo -e "$extra_hosts" >> ~/host_list;
ENDSSH
done

# Distribute the slaves file.

slave_file="/etc/hadoop/conf.$project_name/slaves"
sshpass -p $password scp -o StrictHostKeyChecking=no $slave_file $user\@$hadoop_auxiliary_ip:~
sshpass -p $password scp -o StrictHostKeyChecking=no $slave_file $user\@$hadoop_slave_ip:~
slave_index=0
IFS=","
for slave_node_ip in $hadoop_slave_list; do
	sshpass -p $password scp -o StrictHostKeyChecking=no $slave_file $user\@$slave_node_ip:~
	let slave_index=slave_index+1
done

# Distribute the ZooKeeper configuration file.

zoo_file="/etc/zookeeper/conf.dist/zoo.cfg"
sshpass -p $password scp -o StrictHostKeyChecking=no $zoo_file $user\@$hadoop_auxiliary_ip:~
sshpass -p $password scp -o StrictHostKeyChecking=no $zoo_file $user\@$hadoop_slave_ip:~
slave_index=0
IFS=","
for slave_node_ip in $hadoop_slave_list; do
	sshpass -p $password scp -o StrictHostKeyChecking=no $zoo_file $user\@$slave_node_ip:~
	let slave_index=slave_index+1
done

# Start up the zookeeper server on master.

ENSEMBLE_ID=1

touch /var/log/zookeeper/zookeeper.out
chown zookeeper:zookeeper /var/log/zookeeper/zookeeper.out

service zookeeper-server init --myid=$ENSEMBLE_ID --force
service zookeeper-server start

# Trigger the start scripts running as root on each cluster node.
# A dummy file is created so inotify then runs the start script.

ENSEMBLE_ID=$((ENSEMBLE_ID+1))
echo "About to trigger finalise on auxiliary $hadoop_auxiliary_ip.\n"
sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$hadoop_auxiliary_ip 'bash -s' <<ENDSSH
	touch ~/finaliser
	echo $ENSEMBLE_ID  > ~/finaliser
ENDSSH

ENSEMBLE_ID=$((ENSEMBLE_ID+1))
echo "About to trigger finalise on slave $hadoop_slave_ip.\n"
sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$hadoop_slave_ip 'bash -s' <<ENDSSH
	touch ~/finaliser
	echo $ENSEMBLE_ID  > ~/finaliser
ENDSSH

ENSEMBLE_ID=$((ENSEMBLE_ID+1))
IFS=","
for slave_node_ip in $hadoop_slave_list; do
	echo "About to trigger finalise on slave $slave_node_ip.\n"
	sshpass -p $password ssh -o StrictHostKeyChecking=no $user\@$slave_node_ip 'bash -s' <<ENDSSH
	touch ~/finaliser
	echo $ENSEMBLE_ID  > ~/finaliser
ENDSSH
	ENSEMBLE_ID=$((ENSEMBLE_ID+1))
done

exit 0

# Example command line for testing:
#export project_name=unicarbkb;\
#export installer_account_username=installer;\
#export installer_account_password=0^3Dfxx;\
#export hadoop_slave_count=2;\
#export hadoop_auxiliary_ip=130.220.208.147;\
#export hadoop_slave_ip=130.220.208.118;\
#export hadoop_slave_list=130.56.250.128,130.56.250.196;\
#~/test.sh



