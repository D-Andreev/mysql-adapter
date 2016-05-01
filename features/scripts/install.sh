#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server
/etc/init.d/mysql start --password= 
mysql -u root -p users < ./features/scripts/database.sql
