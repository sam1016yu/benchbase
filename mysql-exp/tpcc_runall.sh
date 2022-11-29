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
	result_dir=~/results_tpcc/WH@${num_WH}~T@${num_terminal}~num_chunk@${num_chunk}~chunk_size@${chunk_size}
	if [[ -d "$result_dir" ]];then
		echo "Already runned setting WH@${num_WH}~T@${num_terminal}~num_chunk@${num_chunk}~chunk_size@${chunk_size}"
		echo "===================================================="
		return 0
	fi
	#clean up binary log
	ssh miaoyu@server 'sudo mysql -se "PURGE BINARY LOGS BEFORE NOW()";'
	set_buffer_size $buffer_pool $num_chunk $chunk_size
	#modify config file
	~/benchbase/mysql-exp/config_tpcc.py $num_terminal $num_WH
	cd ~/benchbase/target/benchbase-mysql
	echo "Running setting: WH@${num_WH}~T@${num_terminal}~num_chunk@${num_chunk}~chunk_size@${chunk_size}"
	#launch benchbase
	java -jar benchbase.jar -b tpcc \
	-c ~/benchbase/mysql-exp/sample_tpcc_config.xml \
	--create=true --load=true --execute=true \
	-d $result_dir
	rm  $result_dir/*.raw.csv
}


for WH in 1 2 4 8 16 32 64 128
do
	for terminal in 1 2 4 8 16 32 64 128 256 512
	do
		for num_chunk in 1 2 4 8
		do
			for chunk_size in 1024 2048 4096 8192
			do	
				run_one $terminal $WH $num_chunk $chunk_size
				echo "************************"
			done
		done
	done
done

