#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys


if len(sys.argv) < 3:
    print("Input:<numTerminals> <numScaleFactor>")
    
fpath = "/users/miaoyu/benchbase/mysql-exp/sample_tpcc_config.xml"

tree = ET.parse(fpath)
root = tree.getroot()

root.find("terminals").text = sys.argv[1]
root.find("scalefactor").text = sys.argv[2]

tree.write(fpath)