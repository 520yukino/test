#!/bin/bash
#Program: loop the ping command to check the network's PC state
net="192.168.1"
for s in $(seq 1 100); do #$(seq 1 100)表示从1到100，这里也可以用{1..100}来代替
    ping -c 1 -w 1 ${net}.$s &> /dev/null && result=0 || result=1
    if [ $result == 0 ]; then
        echo "Server ${net}.$s is UP."
    else
        echo "Server ${net}.$s is DOWN."
    fi
done
