#!/usr/bin/python

import xml.etree.ElementTree as ET
import sys


if len(sys.argv) < 6:
    print("Input:<numTerminals> <numScaleFactor> <fieldSize> <reads> <writes>")
    
assert int(sys.argv[4]) + int(sys.argv[5]) == 100, "r/w ratio should sum to 100"
    
fpath = "/users/miaoyu/benchbase/mysql-exp/sample_ycsb_config.xml"

tree = ET.parse(fpath)
root = tree.getroot()

root.find("terminals").text = sys.argv[1]
root.find("scalefactor").text = sys.argv[2]
root.find("fieldSize").text = sys.argv[3]
root.findall(".//weights")[0].text = f"{sys.argv[4]},{sys.argv[5]},0,0,0,0"

tree.write(fpath)