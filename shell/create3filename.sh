#!/bin/bash
#Program: create 3 files which named by user's input and date command

#让使用者输入文件名称
echo "I will use 'touch' command to create 3 files."
read -p "Please input your filename: " fn
#判断是否真的输入成功
fn=${fn:-'filename'}
#取得所需文件名
d1=$(date -d "2 days ago" +%Y%m%d)
d2=$(date -d "1 days ago" +%Y%m%d)
d3=$(date +%Y%m%d)
f1=${fn}_$d1
f2=${fn}_$d2
f3=${fn}_$d3
#建立文件
touch $f1
touch $f2
touch $f3
