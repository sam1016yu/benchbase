#!/bin/bash
set -e


# set_buffer_size (){
# 	num_chunk=$1
# 	chunk_size=$2
# 	scp ~/benchbase/mysql-exp/set-buffer.sh miaoyu@server:~
#     # set mysql bufffer pool size, both number of chunks and size of each chunk
# 	ssh miaoyu@server "sudo ~/set-buffer.sh  $num_chunk $chunk_size"
# 	sleep 2
# }
# ssh miaoyu@server 'sudo mysql -se "PURGE BINARY LOGS BEFORE NOW()";'


if (($# < 7))
then
    echo "missing arguments"
    exit 1
fi

num_terminal=$1
num_WH=$2
num_chunk=$3
chunk_size=$4
num_log=$5
log_size=$6
server_id=$7


# sudo systemctl stop mysql
# sudo rm -r /db/mysql/benchbase/
# sudo rsync -avzh /db/backup/benchbase /db/mysql/
# sudo systemctl start mysql

result_dir=~/results_tpcc/WH@${num_WH}~T@${num_terminal}~num_chunk@${num_chunk}~chunk_size@${chunk_size}~num_log@${num_log}~log_size@${log_size}
#modify config file
~/benchbase/mysql-exp/config_tpcc.py $num_terminal $num_WH $server_id
cd ~/benchbase/target/benchbase-mysql
#launch benchbase
java -jar benchbase.jar -b tpcc \
-c ~/benchbase/mysql-exp/sample_tpcc_config.xml \
--create=false --load=false --execute=true \
-d $result_dir
#clean raw result
rm  $result_dir/*.raw.csv

