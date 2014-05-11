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
# Finalise installation
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the Hadoop services
# ===========================================

# Remote account details.
user=$installer_account_username
password=$installer_account_password

let expected_vm_count=hadoop_slave_count+1
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
done

# Verify that timeout did not trigger. If it did we give up.

if [  "$vm_count" -eq "$expected_vm_count" ]; then
	echo "All VMs now ready to be finalised. "
else
	echo "All VMs not ready within time limit. "
	# Giveup.
	exit 1
fi

# Set up DNS in /etc/hosts on master.
echo -e "$hadoop_master_ip\t$hadoop_master_domain\t$hadoop_master_hostname\t$hadoop_master_name" >> /etc/hosts;
echo -e "$hadoop_auxiliary_ip\t$hadoop_auxiliary_domain\t$hadoop_auxiliary_hostname\t$hadoop_auxiliary_name" >> /etc/hosts;
slave_index=0
IFS=","
for slave_node_ip in $hadoop_slave_list; do
	actual_slave_name="$hadoop_slave_name_$slave_index"
    hadoop_slave_domain=actual_slave_name._base_domain_
	echo -e "$slave_node_ip\t$hadoop_slave_domain\t$hadoop_slave_hostname\t$actual_slave_name" >> /etc/hosts;
	let slave_index=slave_index+1
done

# All VM's are good, so complete the installation

sshpass -p $installer_account_password ssh $user\@$hadoop_auxiliary_ip 'bash -s' < finalise_auxiliary.sh

exit 0

# E.g. command line for testing:
# export installer_account_username=installer;export installer_account_password=0^3Dfxx;export hadoop_slave_count=2;export hadoop_auxiliary_ip=130.220.208.87;export hadoop_slave_list=130.56.248.178,130.56.249.90;./test.sh



