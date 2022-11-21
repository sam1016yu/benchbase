#!/bin/bash

sudo mkdir /ramdb
sudo chmod 777 /ramdb
sudo mount -t tmpfs -o size=100G ramdb /ramdb
sudo chown mysql:mysql /ramdb

sudo systemctl stop mysql
sudo rsync -avzh /var/lib/mysql/ /ramdb
sudo sed -i 's/^alias.*/alias \/var\/lib\/mysql\/ -> \/ramdb,/g' /etc/apparmor.d/tunables/alias
sudo systemctl restart apparmor
sudo sed -i 's/^datadir.*/datadir = \/ramdb/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl start mysql
sudo mysql < create-user.sql
