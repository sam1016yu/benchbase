#!/bin/bash
set -e


set_buffer_size (){
	num_chunk=$1
	chunk_size=$2
	scp ~/benchbase/mysql-exp/set-buffer.sh miaoyu@server:~
	ssh miaoyu@server "sudo ~/set-buffer.sh  $num_chunk $chunk_size"
	sleep 2
}

run_one (){
	num_terminal=$1
	num_WH=$2
	num_chunk=$3
	chunk_size=$4
	set_buffer_size $buffer_pool $num_chunk $chunk_size
	#modify config file
	~/benchbase/mysql-exp/config_tpcc.py $num_terminal $num_WH
	cd ~/benchbase/target/benchbase-mysql
	#launch benchbase
	java -jar benchbase.jar -b tpcc \
	-c ~/benchbase/mysql-exp/sample_tpcc_config.xml \
	--create=true --load=true --execute=true \
	-d ~/results_tpcc/WH@${num_WH}~T@${num_terminal}~num_chunk@${num_chunk}~chunk_size@${chunk_size}
	#clean up binary log
	ssh miaoyu@server 'sudo mysql -se "PURGE BINARY LOGS BEFORE NOW()";'
}


run_one 5 5 4 512

