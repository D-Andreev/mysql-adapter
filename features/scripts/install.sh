#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server
service mysql start
