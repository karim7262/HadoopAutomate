#!/usr/bin/env bash
# ==================================================================
# install_pre_ubuntu16.sh: install all prereq check for ubuntu 16.04
# ===================================================================
#
# Copyright CloudAge
#
# You are responsible for reviewing and testing any scripts you run thoroughly before use in any non-testing environment.
# VER=1.0.0
function check_os()
{
	#Check OS
	#########
	unameOut="$(uname -a)"
	case "${unameOut}" in
		Linux*)     machine="Linux Found";;
		Darwin*)    machine="Mac Found";;
		CYGWIN*)    machine="Cygwin Found";;
		MINGW*)     machine="MinGw Found";;
		*)          machine="UNKNOWN:${unameOut}"
	esac
	echo ${machine}
}

function check_pkgMgr()
{
	#Check Package Manager(apt,yum)
	##############################
	if [ -x "$(command -v apt-get)" ]; then
			echo "apt package found"
	fi
}

function check_java_install()
{
	#Check Java if not present install
	################################## 
	if ! [ -x "$(command -v java)" ]; then
			if [ -x "$(command -v yum)" ]; then
					echo "Installing through yum..Update Require...."
					#sudo yum -y install java-1.6.0-openjdk
					#install_yum_java
			elif [ -x "$(command -v apt-get)" ]; then
					install_apt_java
			fi
	else
		echo "Java Already Installed"
	fi
}

function check_ntp_install()
{ 
	# Configure NTP
	###############
	if ! [ -x "$(command -v ntp)" ]; then
		sudo apt-get install ntp -y
		timedatectl status
		timedatectl list-timezones
		sudo timedatectl set-timezone Asia/Kolkata
		sudo ntpq -p
		# sudo nano /etc/ntp.conf
	fi 
}

function root_reservedspace()
{
	echo "Root Reserved Space"
	sudo mkfs.ext4 -m 0 /dev/xvda1
	lsblk
	sudo tune2fs -m 0 /dev/xvda1
}

function set_swappiness()
{
	echo "setting swappiness"
	echo "Current Swappiness is: " && cat /proc/sys/vm/swappiness
	sudo sysctl vm.swappiness=1
	sudo sysctl -p
	echo "Updated Swappiness is: " && cat /proc/sys/vm/swappiness
}	

function set_ipv6()
{
	echo "disable ipv6"
	echo "Current IPV6 Status are(all,default,lo) : " && cat /proc/sys/net/ipv6/conf/all/disable_ipv6 && cat /proc/sys/net/ipv6/conf/default/disable_ipv6 && cat /proc/sys/net/ipv6/conf/lo/disable_ipv6
	sudo sysctl net.ipv6.conf.all.disable_ipv6=1
	sudo sysctl net.ipv6.conf.default.disable_ipv6=1
	sudo sysctl net.ipv6.conf.lo.disable_ipv6=1 
	sudo sysctl -p
	echo "Updated IPV6 Status are(all,default,lo) : " && cat /proc/sys/net/ipv6/conf/all/disable_ipv6 && cat /proc/sys/net/ipv6/conf/default/disable_ipv6 && cat /proc/sys/net/ipv6/conf/lo/disable_ipv6
}

function set_iptables()
{
	echo "disable iptables"
	sudo iptables -L -n
	sudo ufw status
	sudo ufw disable
}

function set_hugepageTransparent()
{
	echo "hugepage transparent"
	#Method 1
	# https://askubuntu.com/questions/597372/how-do-i-modify-sys-kernel-mm-transparent-hugepage-enabled
	# sudo apt-get install sysfsutils

	
	#Method 2
	# echo "Method2 for Hugepage Transparent"
	# sudo sed -i '/exit 0/d' /etc/rc.local
	# echo "Removed exit 0"
	# sudo su -c 'cat >>/etc/rc.local <<EOL
	# if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
	  # echo never > /sys/kernel/mm/transparent_hugepage/enabled
	# fi
	# if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
	   # echo never > /sys/kernel/mm/transparent_hugepage/defrag
	# fi
	# exit 0
	# EOL'
	# source /etc/rc.local
	# echo "added multiple if blocks"
	# sudo -i
	# echo "after sudo -i"

	# echo "after source rc.local"
	# exit
	# echo "after exit called"

	##Method 3
    # sudo sed -i '/exit 0/d' /etc/rc.local
    ##sudo su
    # sudo echo 'if test -f /sys/kernel/mm/transparent_hugepage/enabled; then' >> /etc/rc.local
    # sudo echo '  echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
    # sudo echo 'fi' >> /etc/rc.local
    # sudo echo 'if test -f /sys/kernel/mm/transparent_hugepage/defrag; then' >> /etc/rc.local
    # sudo echo '   echo never > /sys/kernel/mm/transparent_hugepage/defrag' >> /etc/rc.local
    # sudo echo 'fi' >> /etc/rc.local
    # sudo echo 'exit 0' >> /etc/rc.local
    # source /etc/rc.local

    # Method 4
    if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
        echo never > /sys/kernel/mm/transparent_hugepage/enabled
    fi
    if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
        echo never > /sys/kernel/mm/transparent_hugepage/defrag
    fi
    echo "All Lines added now exiting"
}



#******************************************************************
#			Dependent Functions
#******************************************************************

function install_apt_java()
{
	echo "Installing java through apt-get"
	sudo apt-get install -y python-software-properties debconf-utils
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo apt-get update
	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	sudo apt-get install -y oracle-java8-installer
}

# echo "**********************"
# check_os
# echo "**********************"
# check_pkgMgr
# echo "**********************"
# check_java_install
# echo "**********************"
# set_swappiness
# echo "**********************"
# set_ipv6
# echo "*****iptables wont remove any issues*****************"
# set_iptables
# echo "**********************"
set_hugepageTransparent
# echo "**********************"
# check_ntp_install
# echo "**********************"
# root_reservedspace
# echo "**********************"
