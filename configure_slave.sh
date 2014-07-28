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
# configure_slave.sh
# ===========================================
# Configure Slave Node
# Based on Cloudera Hadoop version 4
#
# Configures the following services:
#	DataNode
# ===========================================

# Edit the health checker script and ensure its executable
# configure_common.sh sets up the file mapred-site.xml so that points to the health_check.sh file.
cat <<DELIMITER  > /etc/hadoop/conf.$project_name/health_check.sh
#!/bin/bash
if ! jps | grep -q DataNode ; then
 echo ERROR: datanode not up
fi
DELIMITER

# TODO RR: check correct user for this script.
#chown -R hadoop:hadoop /etc/hadoop/conf.$project_name/health_check.sh

chmod ugo+x /etc/hadoop/conf.$project_name/health_check.sh
