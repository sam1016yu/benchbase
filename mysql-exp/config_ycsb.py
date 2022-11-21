#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys


if len(sys.argv) < 5:
    print("Input:<numTerminals> <numScaleFactor> <reads> <writes>")
    
assert int(sys.argv[3]) + int(sys.argv[4]) == 100, "r/w ratio should sum to 100"
    
fpath = "/users/miaoyu/benchbase/mysql-exp/sample_ycsb_config.xml"

tree = ET.parse(fpath)
root = tree.getroot()

root.find("terminals").text = sys.argv[1]
root.find("scalefactor").text = sys.argv[2]
root.findall(".//weights")[0].text = f"{sys.argv[3]},{sys.argv[4]},0,0,0,0"

tree.write(fpath)