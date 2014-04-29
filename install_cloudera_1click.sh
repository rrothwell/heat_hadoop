# ===========================================
# Install Cloudera Hadoop version 4
# ===========================================

# Preparation.
apt-get -y install python-software-properties


# Download and install Java on ALL machines.

#Register repo
add-apt-repository ppa:webupd8team/java
apt-get -q -y update 

# Bypass Oracle license dialog.
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# Install.
apt-get -y install oracle-java7-installer

# Register alternatives. Maybe some redundancy here.
apt-get install java-common 
apt-get install oracle-java7-set-default
update-java-alternatives -s java-7-oracle

# Set the JAVA environment variables.
echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment;
export JAVA_HOME=/usr/lib/jvm/java-7-oracle/





