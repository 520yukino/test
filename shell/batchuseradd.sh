#!/bin/bash
#Program: create amount of login accounts for you.
#1. check userlist file exist? you should create the file manually and separate account names.
#2. use openssl to create users password.
#3. User must change own password when he login first.
#batchuseradd.sh [-d] [File]
#if no -d option, script will add users, otherwise delete users.
#you can specify the userlist File.

#变量
usergroup='' #可将创建的用户添加到其它的用户组，每个组用','号隔开
pwopt='openssl' #openssl是自动生成字符串作为密码，password则是用户名作为密码
addhome='no' #是否为用户创建home，yes/no
opt='add' #add创建用户，delete删除
#检查参数
if [ $# == 2 ]; then
    if [ $2 == '-d' ]; then
        opt='delete'
    elif [ -f $2 ]; then
        username=$(cat $2)
    elif [ ! -f $2 ]; then
        echo "batchuseradd.sh: '$2' is not file"
        exit 1
    else
        echo "batchuseradd.sh: error argus!"
        exit 1
    fi
elif [ $# == 3 ]; then
    if [ $2 == '-d' ]; then
        opt='delete'
        if [ -f $3 ]; then
            username=$(cat $3)
        else
            echo "batchuseradd.sh: '$3' is not file"
            exit 1
        fi
    else
        echo "batchuseradd.sh: error argus!"
        exit 1
    fi
else
    echo "batchuseradd.sh: error argus!"
    exit 1
fi
#循环创建用户
[ -z $usergroup ] && groupadd -r $usergroup #创建组
for user in $username; do
    if [ $opt == 'add' ]; then
        [ -n "$usergroup" ] && ug=" -G $usergroup " || ug='' #设置组
        useradd $ug $user
        [ $pwopt == 'openssl' ] && upw=$(openssl rand -base64 6) || upw=$user #设置密码
        echo $upw | chpasswd
        chage -d 0 $user #强制用户登录时修改密码
        [ $home == 'yes' ] && cp -r /etc/skel/ /home/$user #创建家目录
        echo "username=${user}, password=${upw}" >> /root/batchuseradd.sh_userpassword.txt #用户名和密码存放文件
    elif [ $opt == 'delete' ]; then
        echo "deleting $user"
        userdel $user
    fi
done
        
