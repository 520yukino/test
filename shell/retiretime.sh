#!/bin/bash
#Program: calculate how many days before you retire by your input date
echo "This program will try to calculate how many days before your retire date."
read -p "Please input your retire date (YYYYMMDD ex>20010516): " date
#测试输入是否合理
date=$(echo $date | grep '[0-9]\{8,\}')
if [ -z $date ]; then
    echo 'Your input the wrong date format'
    exit 1
fi
#计算
t1=$(date --date=$date +%s)
t2=$(date +%s)
result=$((($t1-$t2)/24/60/60))
#输出结果
if [ $result -lt 0 ]; then
    echo 'You had been retire before:' $((-$result)) 'days ago'
else
    echo "You will retire after $result days"
fi
