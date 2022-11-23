#!/bin/bash


cd ~/benchbase
 ./mvnw clean package -P mysql -DskipTests
cd ~/benchbase/target
tar xvzf benchbase-mysql.tgz