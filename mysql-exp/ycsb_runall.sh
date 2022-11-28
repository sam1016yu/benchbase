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
	num_rows=$2
	field_size=$3
	R=$4
	W=$5
	num_chunk=$6
	chunk_size=$7

	set_buffer_size $buffer_pool $num_chunk $chunk_size
	#modify config file
	~/benchbase/mysql-exp/config_ycsb.py $num_terminal $num_rows $field_size $R $W $num_chunk $chunk_size
	cd ~/benchbase/target/benchbase-mysql
	#launch benchbase
	java -jar benchbase.jar -b ycsb \
	-c ~/benchbase/mysql-exp/sample_ycsb_config.xml \
	--create=true --load=true --execute=true \
	-d ~/results_ycsb/rows@${num_rows}~T@${num_terminal}~field_size@${field_size}~R@${R}~W@${W}~num_chunk@${num_chunk}~chunk_size@${chunk_size}
	#clean up binary log
	ssh miaoyu@server 'sudo mysql -se "PURGE BINARY LOGS BEFORE NOW()";'
}



run_one 200 10 10 1024

