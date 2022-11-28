#!/bin/bash

# need to first run to create a 100GB partition
# sudo fdisk /dev/sdb

sudo mkdir /hdddb
sudo chmod 777 /hdddb
sudo mkfs.ext4 /dev/sdb1
sudo mount /dev/sdb1 /hdddb
sudo chown mysql:mysql /hdddb

sudo systemctl stop mysql
sudo rsync -avzh /var/lib/mysql/ /hdddb
sudo sed -i 's/^alias.*/alias \/var\/lib\/mysql\/ -> \/hdddb,/g' /etc/apparmor.d/tunables/alias
sudo systemctl restart apparmor
sudo sed -i 's/^datadir.*/datadir = \/hdddb/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl start mysql
sudo mysql < create-user.sql
