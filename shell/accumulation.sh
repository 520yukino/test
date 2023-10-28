#!/bin/bash
#Program: use loop to calculate "1+2+3...+N", N is user provided num which is $1
i=0
sum=0
if [ -z $1 ]; then
    echo "error: no argument, you should give a number to calculate!"
    exit 1
fi
while [ $i != $1 ]; do
    ((i++))
    sum=$(($sum+$i))
done
echo "1 to $1 is equel to $sum"

