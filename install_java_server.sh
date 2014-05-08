#!/bin/bash -v
# ===========================================
# Install all packages needed for a Java server
#
# Sets up:
#	Java
#	DNS
#	Extras.
#
# ===========================================

# Preparation.
apt-get -y install python-software-properties python-setuptools 
#apt-get -y python-pip
#pip install python-heatclient

# cfn tools install - needed to support install packages, start services, handle updates, and wait for applications.
#apt-get -y install python-argparse cloud-init python-psutil python-pip
#apt-get -y remove python-boto
#pip install 'boto==2.5.2' heat-cfntools
#cfn-create-aws-symlinks -s /usr/local/bin/

# Download and install Java.
./install_java.sh

# Set up DNS in /etc/hosts
echo -e "$hadoop_instance_ip\t$hadoop_instance_domain\t$hadoop_instance_hostname\t$hadoop_instance_name" >> /etc/hosts;



