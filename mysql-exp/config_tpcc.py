#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys


if len(sys.argv) < 4:
    print("Input:<numTerminals> <numScaleFactor> <server id>")
    exit(1)
    
server_ip = "jdbc:mysql://10.10.1.{}:3306/benchbase?rewriteBatchedStatements=true".format(sys.argv[3])
fpath = "/users/miaoyu/benchbase/mysql-exp/sample_tpcc_config.xml"

tree = ET.parse(fpath)
root = tree.getroot()

root.find("terminals").text = sys.argv[1]
root.find("scalefactor").text = sys.argv[2]
root.find("url").text = server_ip

tree.write(fpath)