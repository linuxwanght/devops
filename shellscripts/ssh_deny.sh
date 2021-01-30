#!/bin/bash
#BLACK_IP=`cat /var/log/secure | grep Failed | awk '{print $(NF-3)}'|sort -n |uniq -c | awk '$1>2{print $2}'`
cat /var/log/secure | grep Failed | awk '{print $(NF-3)}'|sort -n |uniq -c | awk '$1>2{print $2}' > /root/black_ip.txt
while read LINE;do
  if [ -n $LINE ];then
    grep "${LINE}"  /etc/hosts.deny
    if [ $? -gt 0 ];then
      echo "sshd:${LINE}"  >> /etc/hosts.deny
    fi  
  fi    
done < /root/black_ip.txt
