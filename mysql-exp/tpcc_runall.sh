#!/bin/bash
set -e

##directory:
result_dir=~/results/

##file name
change_config=Config
wh=1

for (( t=1; t<=2; t+=1 ))
do
	java $change_config $t >> config_output
        java -jar benchbase.jar -b tpcc -c config/mysql/sample_tpcc_config.xml --create=true --load=true --execute=true -d ~/results/tpcc/wh${wh}/t${t} >> exec_output
done || exit 1

