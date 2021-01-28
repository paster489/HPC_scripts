#!/bin/sh
#------------------------------------------------------------
# Zabbix agent installation on OL8 tools
# Created by Inga on 26/02/2021
#------------------------------------------------------------
# Input: machine hostname where zabbix installation need be done - only one machine
# Output: N/A
# Process:
#         1) Check the linux version and that getenforce is disable
#         2) Check that zabbix is not installed on this machine
#         3) Install zabbix agent
#         4) Save the original zabbix_agentd.conf as zabbix_agentd.conf.orig
#         5) Update zabbix_agentd.conf  
#         6) Start and enable zabbix-agent
#         7) Check if zabbix-agent is running:
#             7a) If yes: save machine hostname /storage/sysinfo/zabbix_storage/zabbix_hostname_list.txt
#             7b) If not: print error for this machine
#        *) Frontend => http://132.72.137.175:8080/zabbix/hosts.php, server => slwk    
#
#-----------------------------------------------------------
# 1)  Check the version of  Linux and that getenforce is disable
#------------------------------------------------------------
echo
echo ".................................................................."
echo -e "   \e[38;5;256mCheck if getenforce is disable \e[0m"
echo ".................................................................."

getenforce_check=$(getenforce)
if [ "$getenforce_check" == "Disabled" ]; then
       	echo -e "   \e[32mOK\e[0m: getenforce is disable"
else
	echo -e "   \e[35mWARNING!\e[0m Please disable getenforce"
	exit
fi

echo
echo ".................................................................."
echo -e "   \e[38;5;256mCheck the version of Linux  \e[0m"
echo ".................................................................."

linux_ver=$(cat /etc/redhat-release | awk -F 'release' '{print $2}'|cut -d. -f1  | cut -d' ' -f2)
if [ $linux_ver -lt 6 ]; then
	echo -e "   \e[35mWARNING!\e[0m Linux version below 6, please update linux"
	exit
else
	echo -e "   \e[32mOK\e[0m:"   $(cat /etc/redhat-release) 
fi

#------------------------------------------------------------
# 2) Check that zabbix is not installed on this machine
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256mCheck if zabbix already exists  \e[0m"
echo ".................................................................."
script_name=zabbix_agent_install
zabbix_installed=$(ps -ef | grep zabbix | grep -v grep | grep -v $script_name)
if [ -z "$zabbix_installed" ]; then
	echo -e "   \e[32mOK\e[0m: Zabbix does not exist"
else
	echo -e "   \e[35mWARNING!\e[0m Zabbix already exists"
	exit
fi
echo

#------------------------------------------------------------
# 3) Install zabbix agent
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256mrpm download  \e[0m"
echo ".................................................................."
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
echo -e "   \e[32mOK\e[0m: rpm successfully downloaded"
echo

echo ".................................................................."
echo -e "   \e[38;5;256mZabbix instalation  \e[0m"
echo ".................................................................."

if [ $linux_ver -eq 8 ]; then
	echo "installing with dnf"
	echo "--------------------------"	
	dnf install zabbix-agent zabbix-get -y
	echo
	#dnf clean all
else
	echo "installing with yum"
	echo "--------------------------"
	yum install zabbix-agent zabbix-get -y
        echo	
	#yum clean all
fi

echo -e "   \e[32mOK\e[0m: Zabbix installed"
echo

#------------------------------------------------------------
# 4)Save the original zabbix_agentd.conf as zabbix_agentd.conf.orig 
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256mSave the original zabbix_agentd.conf as zabbix_agentd.conf.orig  \e[0m"
echo ".................................................................."

cd /etc/zabbix/
cp -f zabbix_agentd.conf zabbix_agentd.conf.orig
echo

#------------------------------------------------------------
# 5) Update zabbix_agentd.conf with
#          Zabbix Server IP = 172.20.7.235 (slwk) and
#          Hostanme = HPC_zabbix
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256mUpdate zabbix_agentd.conf file  \e[0m"
echo ".................................................................."

default_Server="Server=127.0.0.1"
correct_Server="Server=172.20.7.235"

default_ServerActive="ServerActive=127.0.0.1"
correct_ServerActive="ServerActive=172.20.7.235"

default_Hostname="Hostname=Zabbix server"
correct_Hostname="#Hostname=Zabbix server"

default_HostnameItem="# HostnameItem=system.hostname"
correct_HostnameItem="HostnameItem=system.hostname"

default_HostMetadataItem="# HostMetadataItem="
correct_HostMetadataItem="HostMetadataItem=release"

default_UserParameter="# UserParameter="
correct_UserParameter="UserParameter=release,cat /etc/redhat-release"

sed -i "s|$default_Server|$correct_Server|" zabbix_agentd.conf
sed -i "s|$default_ServerActive|$correct_ServerActive|" zabbix_agentd.conf
sed -i "s|$default_Hostname|$correct_Hostname|" zabbix_agentd.conf
sed -i "s|$default_HostnameItem|$correct_HostnameItem|" zabbix_agentd.conf
sed -i "s|$default_HostMetadataItem|$correct_HostMetadataItem|" zabbix_agentd.conf
sed -i "s|$default_UserParameter|$correct_UserParameter|" zabbix_agentd.conf

echo

#------------------------------------------------------------
# 6) Start and enable zabbix-agent
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256mEnable zabbix-agent  \e[0m"
echo ".................................................................."
systemctl enable zabbix-agent
echo

echo ".................................................................."
echo -e "   \e[38;5;256mStart zabbix-agent  \e[0m"
echo ".................................................................."
systemctl start zabbix-agent
echo

echo ".................................................................."
echo -e "   \e[38;5;256mStatus of zabbix-agent  \e[0m"
echo ".................................................................."
systemctl status zabbix-agent --no-pager
echo

#------------------------------------------------------------
# 7) Check if zabbix-agent is running
#         7a) If yes:
#                   7a.b) save machine hostname /storage/sysinfo/zabbix_storage
#         7b) If not:
#                   7b.a) print error for this machine
#------------------------------------------------------------
echo ".................................................................."
echo -e "   \e[38;5;256m Check if zabbix-agent is running  \e[0m"
echo ".................................................................."

storage=/storage/sysinfo/zabbix_storage
if [ ! -f $storage/zabbix_hostname_list.txt ]; then
	touch $storage/zabbix_hostname_list.txt
fi

zabbix_installed=$(ps -ef | grep zabbix | grep -v grep | grep -v zabbix_install)
if [ -z "$zabbix_installed" ]; then
	echo -e "   \e[35mWARNING!\e[0m Zabbix is not running. Please T/S."
	exit
else
	echo -e "   \e[32mOK\e[0m: Zabbix is running"
	sge_hostname=$(hostname)
	echo $sge_hostname " -> "  $(date +"%D %T") " -> "  $(cat /etc/redhat-release)  >> $storage/zabbix_hostname_list.txt
fi

echo
echo "END OF THE SCRIPT. By-by"
echo





