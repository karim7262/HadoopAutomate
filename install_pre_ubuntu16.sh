#!/usr/bin/env bash
# ==================================================================
# install_pre_ubuntu16.sh: install all prereq check for ubuntu 16.04
# ===================================================================
#
# Copyright CloudAge
#
# You are responsible for reviewing and testing any scripts you run thoroughly before use in any non-testing environment.
# VER=1.0.0

# Check if not Ubuntu/Debian then exit
#####################################
if [ "$(uname)" = 'Darwin' ];
then
        echo -e "\nThis tool runs on Linux only, not Mac OS."
        exit 1
fi

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

#Check Package Manager(apt,yum)
##############################
if [ -x "$(command -v apt-get)" ]; then
        echo "apt package found"
fi

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
                        echo "Installing java through apt-get"
                        #sudo apt-get install openjdk-6-jre
                fi
        fi
fi
