#!/bin/bash -v
# ===========================================
# Create Directories and Install Common Configuration Across All Nodes
# Based on Cloudera Hadoop version 4
#
# ===========================================


# -------------------------------------------
# Format and Start HDFS
# -------------------------------------------

# Format the hdfs file system as the hdfs user.
# ON the master only is OK.
sudo -u hdfs hadoop namenode -format
