#!/bin/bash
#Program: check the following list by filename which user input
#   1) exist? 2) file/dir? 3) file permissions

#让用户输入文件名并检查输入
echo "Please input a filename, I will check and print it's type and permissions."
read -p "Input filename: " fn
test -z $fn && echo 'No filename input!' && exit 1
test ! -e $fn && echo "'$fn' don't exist!" && exit 2
#判断文件类型和属性
test -f $fn && ft='regular file'
test -d $fn && ft='directory'
test -r $fn && fp1=' readable'
test -w $fn && fp2=' writable'
test -x $fn && fp3=' executable'
#输出信息
echo "'$fn' is a $ft"
test -z $fp1 && test -z $fp2 && test -z $fp3 && echo 'No permission for you' && exit 0
echo "And the permissions for you are:${fp1}${fp2}${fp3}"
