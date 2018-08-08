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
	# if [ ! type java ];
	# then
	if ! [ -x "$(command -v java)" ]; then
			if [ -x "$(command -v yum)" ]; then
					echo "Installing through yum"
					#sudo yum -y install java-1.6.0-openjdk
			else
					if [ -x "$(command -v apt-get)" ]; then
							install_java
					fi
			fi
	fi
}

function set_swapiness()
{
	echo "Current Swapiness is: " && cat /proc/sys/vm/swappiness
	sudo sysctl vm.swappiness=0
	sudo sysctl -p
	echo "Updated Swapiness is: " && cat /proc/sys/vm/swappiness
}	

#******************************************************************
#			Dependent Functions
#******************************************************************
function install_java()
{
	echo "Installing java through apt-get"
}

echo "**********************"
check_os
echo "**********************"
check_pkgMgr
echo "**********************"
check_java_install
echo "**********************"
set_swapiness
echo "**********************"
