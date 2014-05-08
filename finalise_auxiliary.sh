#!/bin/bash -v
# ===========================================
# Finalise installation on auxiliary
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the services
# ===========================================

remote_password="0^3Dfxx"
auxilary_node_ip=130.56.249.85

sudo update-rc.d hadoop-hdfs-secondarynamenode defaults
service hadoop-hdfs-secondarynamenode start



