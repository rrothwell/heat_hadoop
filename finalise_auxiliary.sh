#!/bin/bash -v
# ===========================================
# Finalise installation on auxiliary
# Based on Cloudera Hadoop version 4
#
# Adjust configuration of remote VM's and then starts the services
# ===========================================

update-rc.d hadoop-hdfs-secondarynamenode defaults
service hadoop-hdfs-secondarynamenode start



