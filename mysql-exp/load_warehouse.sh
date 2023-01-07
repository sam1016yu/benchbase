#!/bin/bash


if (($# < 2))
then
    echo "need to speficy number of warehouse and server id"
    exit 1
fi

num_terminal=10
num_WH=$1
server_id=$2
~/benchbase/mysql-exp/config_tpcc.py $num_terminal $num_WH $server_id
mkdir ~/dummy_result
cd ~/benchbase/target/benchbase-mysql
#launch benchbase
java -jar benchbase.jar -b tpcc \
-c ~/benchbase/mysql-exp/sample_tpcc_config.xml \
--create=true --load=true --execute=false \
-d  ~/dummy_result
rm -rf ~/dummy_result
# sudo rsync -avzh /db/mysql/benchbase /db/backup/
