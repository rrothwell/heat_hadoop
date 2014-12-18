export project_name=unicarbkb
export installer_account_username=installer
echo $installer_account_username
export installer_account_password=0^3Dfxx
export hadoop_slave_count=2
export hadoop_slave_timeout=15

export hadoop_base_domain=doesntexist.org
export hadoop_master_name=hadoop-master
export hadoop_auxiliary_name=hadoop-auxiliary
export hadoop_slave_name=hadoop-slave

export hadoop_master_ip=130.56.249.196
export hadoop_auxiliary_ip=130.56.249.78
export hadoop_slave_list=144.6.225.148,144.6.225.152

export hadoop_node_ip=$hadoop_master_ip
echo $hadoop_master_ip
export hadoop_master_domain="$hadoop_master_name.$hadoop_base_domain"
echo $hadoop_master_domain
export hadoop_auxiliary_domain="$hadoop_auxiliary_name.$hadoop_base_domain"
echo $hadoop_auxiliary_domain
export hadoop_auxiliary_hostname=
export hadoop_node_hostname=
/tmp/finalise_hadoop_installation.sh
