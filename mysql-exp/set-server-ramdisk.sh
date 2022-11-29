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

if grep -q "max_connections" /etc/mysql/my.cnf
then
sudo sed -i "s/^max_connections.*/max_connections = 1026/g" /etc/mysql/my.cnf
else
sudo sh -c "echo '[mysqld]' >> /etc/mysql/my.cnf"
sudo sh -c "echo 'max_connections = 1026' >> /etc/mysql/my.cnf"
# sudo systemctl restart mysql
fi
sudo systemctl start mysql
sudo mysql < create-user.sql

