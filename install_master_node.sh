# ===========================================
# Install Master Node
# Based on Cloudera Hadoop version 4
#
# Installs the following services:
#	NameNode
#	TaskTracker
# ===========================================

# Resources:
# http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_4_4.html
# http://akbarahmed.com/2012/06/26/install-cloudera-cdh4-with-yarn-mrv2-in-pseudo-mode-on-ubuntu-12-04-lts/
# http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/

# Note: NOT using HA - High Availability.

# Preparation.
apt-get -y install python-software-properties

# cfn tools install
#apt-get -y install python-argparse cloud-init python-psutil python-pip
#apt-get -y remove python-boto
#pip install 'boto==2.5.2' heat-cfntools
#cfn-create-aws-symlinks -s /usr/local/bin/

# Download and install Java.
./install_java.sh

# Set up DNS
echo -e $hadoop_master_ip >> ~/diagnostic_messages;
echo -e $hadoop_master_name >> ~/diagnostic_messages;
echo -e $hadoop_master_domain >> ~/diagnostic_messages;

echo -e "$hadoop_master_ip\t$hadoop_master_domain\t$hadoop_master_name" >> /etc/hosts;

