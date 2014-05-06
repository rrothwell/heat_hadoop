#!/bin/bash -v
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

chown -R hadoop:hadoop /etc/hadoop/conf.$project_name/health_check.sh
chmod ugo+x /etc/hadoop/conf.$project_name/health_check.sh
