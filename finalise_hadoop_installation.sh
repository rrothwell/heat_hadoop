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

set expected_vm_count=1+hadoop_slave_count
echo "Expected VM count: $expected_vm_count"

# Setup for timeout.

current_time_secs=`date +%s`
# 5min as seconds
let duration_secs=1*60	
let timeout_secs=current_time_secs+duration_secs

# Loop for timeout.
# The loop checks each of the remote VM's for the existence of a file at /tmp/installation_finished.
# This file is created as the final step of the installation code on each VM.
# If a full complement of VM's is ready the setup process can be finalised.

try_counter=0
while [  $current_time_secs -lt $timeout_secs ]; do

	vm_count=0
	
	message="Installation on $hadoop_auxiliary_ip NOT finished." 
	if sshpass -p $installer_account_password scp -o StrictHostKeyChecking=no installer@$hadoop_auxiliary_ip:/tmp/installation_finished ./ >&/dev/null ; then
		let vm_count=vm_count+1 
		message="Installation on $hadoop_auxiliary_ip finished." ;
		echo $message
	fi
	
	slave_counter=1
	IFS=","
	for slave_node_ip in $hadoop_slave_list; do
		message="Installation on slave $slave_node_ip with IP address $slave_node_ip NOT finished." 
		if sshpass -p $installer_account_password scp -o StrictHostKeyChecking=no installer@$slave_node_ip:/tmp/installation_finished ./ >&/dev/null ; then
			let vm_count=vm_count+1 
			message="Installation on slave $slave_node_ip with IP address $slave_node_ip is finished." ;
		fi
		echo $message
		let slave_counter=slave_counter+1
	done

	if [  $vm_count -eq $expected_vm_count ]; then
		break 
	fi
	echo "The try counter is $try_counter"
	let try_counter=try_counter+1 
	current_time_secs=`date +%s`
done

# Verify that timeout did not trigger. If it did we give up.

if [  $vm_count -eq $expected_vm_count ]; then
	echo "All VMs now ready to be finalised. "
else
	echo "All VMs not ready within time limit. "
	# Giveup.
	exit 1
fi

# All VM's are good, so complete the installation

sshpass -p $installer_account_password ssh installer@$hadoop_auxiliary_ip 'bash -s' < finalise_auxiliary.sh

exit 0



