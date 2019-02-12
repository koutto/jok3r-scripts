#!/usr/bin/env bash

sudo apt-get -y install libaio1 python-dev alien python-pip
# sudo alien --to-deb oracle-instantclient*-basic-*.rpm
# sudo alien --to-deb oracle-instantclient*-sqlplus-*.rpm
# sudo alien --to-deb oracle-instantclient*-devel-*.rpm
wget https://github.com/koutto/jok3r-scripts/raw/master/oracle/odat-dependencies/oracle-instantclient12.2-sqlplus_12.2.0.1.0-2_amd64.deb -O oracle-instantclient12.2-sqlplus_12.2.0.1.0-2_amd64.deb
wget https://github.com/koutto/jok3r-scripts/raw/master/oracle/odat-dependencies/oracle-instantclient18.3-basic_18.3.0.0.0-2_amd64.deb -O oracle-instantclient18.3-basic_18.3.0.0.0-2_amd64.deb
wget https://github.com/koutto/jok3r-scripts/raw/master/oracle/odat-dependencies/oracle-instantclient18.3-devel_18.3.0.0.0-2_amd64.deb -O oracle-instantclient18.3-devel_18.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient18.3-basic_18.3.0.0.0-2_amd64.deb
sudo dpkg -i oracle-instantclient12.2-sqlplus_12.2.0.1.0-2_amd64.deb
sudo dpkg -i oracle-instantclient18.3-devel_18.3.0.0.0-2_amd64.deb
export ORACLE_HOME=`file /usr/lib/oracle/*/client64/ | tail -n 1 | cut -d':' -f1`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
export PATH=$ORACLE_HOME/bin:$PATH
cd $ORACLE_HOME/lib/
sudo ln -s libclntsh.so.* libclntsh.so
sudo sh -c "echo `file /usr/lib/oracle/*/client64/ | tail -n 1 | cut -d':' -f1` > /etc/ld.so.conf.d/oracle.conf"
sudo ldconfig
sudo -s source /etc/profile
sudo pip2 install cx_Oracle
python2.7 -c 'import cx_Oracle' 
sudo apt-get install python-scapy
sudo pip2 install colorlog termcolor pycrypto passlib
sudo pip2 install argcomplete && sudo activate-global-python-argcomplete
sudo pip2 install pyinstaller