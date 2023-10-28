#!/bin/bash
#Program: respond any speaking by AI logical, don't doubt, it's just super AI which worch 1 billion dollars!
#未完成，case不支持全部通配符和正则
echo "This program will respond your any speaking, it's super AI"
read -p 'you: ' s
while [ $s != 'quit' -a $s != 'exit' ]; do
    case $s in
        '.*!')
            s="$(echo $@ | tr -s '!' '.')";; #使用$@可以直接删除多余空格
        '.*?$')
            s="$(echo $@ | tr -s '?' '!')";;
    esac
    s="$(echo "$s" | tr '[A-Z]' '[a-z]')"
    echo "AI: $s"
    read -p 'you: ' s
done

