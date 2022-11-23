#!/bin/bash


# settings are in MB

# config_file=/users/miaoyu/benchbase/mysql-exp/mysqld.cnf
# innodb_buffer_pool_size=128
# innodb_buffer_pool_instances=1          
# innodb_buffer_pool_chunk_size=128


config_file=/etc/mysql/mysql.conf.d/mysqld.cnf
innodb_buffer_pool_instances=$1          
innodb_buffer_pool_chunk_size=$2

         
innodb_buffer_pool_chunk_size=$((innodb_buffer_pool_chunk_size*1024*1024))
innodb_buffer_pool_size=$((innodb_buffer_pool_chunk_size*innodb_buffer_pool_instances)) 

if (($# < 2))
then
    echo "Usage: set-buffer.sh <innodb_buffer_pool_size> <innodb_buffer_pool_instances> <innodb_buffer_pool_chunk_size>"
    exit 1
fi

# if (( innodb_buffer_pool_chunk_size * innodb_buffer_pool_instances > innodb_buffer_pool_size ));then
#     echo "invalid buffer pool settings"
#     exit 1
# fi


sudo systemctl stop mysql

if grep -q 'innodb_buffer_pool_size' $config_file
then
    sudo sed -i "s/^innodb_buffer_pool_size.*/innodb_buffer_pool_size = ${innodb_buffer_pool_size}/g" $config_file
    sudo sed -i "s/^innodb_buffer_pool_instances.*/innodb_buffer_pool_instances = ${innodb_buffer_pool_instances}/g" $config_file
    sudo sed -i "s/^innodb_buffer_pool_chunk_size.*/innodb_buffer_pool_chunk_size = ${innodb_buffer_pool_chunk_size}/g" $config_file
else
    sudo echo "innodb_buffer_pool_size = ${innodb_buffer_pool_size}" >> $config_file
    sudo echo "innodb_buffer_pool_instances = ${innodb_buffer_pool_instances}" >> $config_file
    sudo echo "innodb_buffer_pool_chunk_size = ${innodb_buffer_pool_chunk_size}" >> $config_file
    sudo echo "# " >> $config_file
fi

sudo systemctl start mysql