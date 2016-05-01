#!/usr/bin/env bash
sudo -E apt-get -q -y install mysql-server
/etc/init.d/mysql start
mysql -u root -p users < ./features/scripts/database.sql
