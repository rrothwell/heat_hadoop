#!/bin/bash -v
# ===========================================
# Finalise installation
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the services
# ===========================================

remote_password="0^3Dfxx"
expected_vm_count=2
auxilary_node_ip=130.56.249.85
slave_node_ip=130.220.208.87

current_time_secs=`date +%s`
# 5min as seconds
let duration_secs=1*60	
let timeout_secs=current_time_secs+duration_secs

counter=0
while [  $current_time_secs -lt $timeout_secs ]; do

	vm_count=0
	
	message="Installation on $auxilary_node_ip NOT finished." 
	if sshpass -p $remote_password scp -o StrictHostKeyChecking=no installer@$auxilary_node_ip:/tmp/installation_finished ./ >&/dev/null ; then
		let vm_count=vm_count+1 
		message="Installation on $auxilary_node_ip finished." ;
		echo $message
	fi
	message="Installation on $slave_node_ip NOT finished." 
	if sshpass -p $remote_password scp -o StrictHostKeyChecking=no installer@$slave_node_ip:/tmp/installation_finished ./ >&/dev/null ; then
		let vm_count=vm_count+1 
		message="Installation on $slave_node_ip finished." ;
		echo $message
	fi
	if [  $vm_count -eq $expected_vm_count ]; then
		break 
	fi
	echo The counter is $counter
	let counter=counter+1 
	current_time_secs=`date +%s`
done

if [  $vm_count -eq $expected_vm_count ]; then
	echo "All VMs now read to be finalised. "
else
	echo "All VMs not ready within time limit. "
	break
fi

sshpass -p $remote_password ssh installer@$auxilary_node_ip 'bash -s' < finalise_auxiliary.sh




