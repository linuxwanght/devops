# 本脚本适用centos6/7
#初始化系统脚本
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

#获取操作系统主版本号（6/7）
VERSION=`grep -o "[[:digit:]]" /etc/redhat-release |head -n1`


#配置阿里云yum源
yum install wget -y
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
if [ $VERSION == '7' ];then
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
elif [ $VERSION == '6' ];then
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo  
elif [ $VERSION == '5' ];then
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo     
fi
yum clean all
yum makecache

#安装必要工具
yum install -y yum-utils vim bind-utils ntpdate sysstat wget man mtr lsof iotop net-tools openssl-devel openssl-perl screen iostat subversion nscd lrzsz  unzip  telnet glances

 

 
#"安装系统工具"
yum install -y gcc gcc-c++ make cmake autoconf bzip2 bzip2-devel curl openssl  rsync gd zip perl httpd-tools    psmisc  epel*  python-pip python-devel  


#安装docker-ce
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce docker-ce-cli containerd.io
#配置docker镜像加速器
#"registry-mirrors": ["https://mirror.aliyuncs.com"]



#设置校时和时区
if [ "`cat /etc/crontab | grep ntpdate`" = "" ]; then
	#echo "0 23 * * * root /usr/sbin/ntpdate cn.pool.ntp.org >> /var/log/ntpdate.log" >> /etc/crontab
	echo "0 23 * * * root /usr/sbin/ntpdate ntp1.aliyun.com >> /var/log/ntpdate.log" >> /etc/crontab
fi
if [ "`ls -l /etc/localtime   | grep "Shanghai"`" = "" ]; then
	rm -f /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
fi	
ntpdate ntp1.aliyun.com;hwclock -w


#关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

#sshd优化
sed -i "s/\#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config
sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
sed -i 's@\#PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config
sed -i 's@\#MaxAuthTries 6@MaxAuthTries 6@' /etc/ssh/sshd_config
echo 'Protocol 2'   >> /etc/ssh/sshd_config
sed -i 's@\#ClientAliveInterval 0@ClientAliveInterval 300@' /etc/ssh/sshd_config
sed -i 's@\#ClientAliveCountMax 3@ClientAliveCountMax 3@' /etc/ssh/sshd_config
sed -i 's@\#LogLevel INFO@LogLevel INFO@' /etc/ssh/sshd_config
#禁止空密码登陆
sed -i 's@\#PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config
#禁止root远程登陆
#sed -i "/#PermitRootLogin/s@.*@PermitRootLogin no@" /etc/ssh/sshd_config
#chmod +w /etc/sudoers
#sed -i "/^root/api       ALL=(ALL)      NOPASSWD: ALL" /etc/sudoers
#chmod -w /etc/sudoers



#更改ulimit参数
if [ "`cat /etc/security/limits.conf | grep 'soft nproc 65535'`" = "" ]; then
cat  >> /etc/security/limits.conf << EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
echo "ulimit -SHn 65535" >> /etc/profile
echo "ulimit -SHn 65535" >> /etc/rc.local
fi

#ssh登陆验证失败3次禁止此IP
#get ssh_deny.sh
#echo '*/5 * * * * root sh /root/ssh_deny.sh'  >> /etc/crontab

#15分钟未动，服务器超时自动断开与客户端的链接
echo "TMOUT=900" >> /etc/profile

#清空/etc/issue，去除系统及内核版本登陆前的屏幕显示
/bin/cp /etc/issue /etc/issue.bak
>/etc/issue
[ `cat /etc/issue|wc -l` -eq 0 ] && action "/etc/issue set" /bin/true || action "/etc/issue set" /bin/false

#更改字符集为en_US.UTF-8
if [ -f /etc/sysconfig/i18n ];then
	/bin/cp /etc/sysconfig/i18n /etc/sysconfig/i18n.bak
	echo 'LANG="en_US.UTF-8"' >/etc/sysconfig/i18n
	source /etc/sysconfig/i18n
else
	/bin/cp /etc/locale.conf /etc/locale.conf.bak
	echo 'LANG="en_US.UTF-8"' >/etc/locale.conf
	source /etc/locale.conf
fi	

#添加常用命令别名
echo "alias pscpu='ps axo user,pid,ppid,%mem,%cpu,command  --sort -%cpu'" >> /root/.bashrc
echo "alias psmem='ps axo user,pid,ppid,%mem,%cpu,command  --sort -%mem'" >> /root/.bashrc
echo "alias vimnet='vim /etc/sysconfig/network-scripts/ifcfg-ens192'"     >> /root/.bashrc
echo "alias tcpstatus='netstat -n| awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}''"  >> /root/.bashrc


#内核参数优化
[ -f /etc/sysctl.conf.bak ] && /bin/cp /etc/sysctl.conf.bak /etc/sysctl.conf.bak.$(date +%F-%H%M%S) ||/bin/cp /etc/sysctl.conf /etc/sysctl.conf.bak
cat >> /etc/sysctl.conf <<EOF
fs.file-max = 999999
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 10240 87380 12582912
net.ipv4.tcp_wmem = 10240 87380 12582912
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 40960
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 60
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_keepalive_intvl = 3
net.ipv4.tcp_keepalive_probes = 2
net.ipv4.tcp_fin_timeout = 2
net.ipv4.route.gc_timeout = 100
#以下参数是对iptables防火墙的优化，防火墙不开会提示，可以忽略不理。
#net.ipv4.ip_conntrack_max = 25000000
#net.ipv4.netfilter.ip_conntrack_max=25000000
#net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=180
#net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait=120
#net.ipv4.netfilter.ip_conntrack_tcp_timeout_close_wait=60
#net.ipv4.netfilter.ip_conntrack_tcp_timeout_fin_wait=120
#net.netfilter.nf_conntrack_max = 25000000
#net.netfilter.nf_conntrack_tcp_timeout_established = 180
#net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
#net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
#net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120'
EOF
sysctl -p >/dev/null 2>&1


#锁定关键系统文件  解锁chattr -ai /etc/passwd
chattr +ai /etc/passwd
chattr +ai /etc/shadow
chattr +ai /etc/group
chattr +ai /etc/gshadow
chattr +ai /etc/inittab




if [ "$VERSION" == "6" ]; then
    service sshd restart
    service iptables stop
    chkconfig iptables off
    if [ "`cat /etc/sysctl.conf | grep net.ipv4.tcp_max_tw_buckets`" = "" ]; then
        echo "$SYSCONF" >> /etc/sysctl.conf    
    fi
    /sbin/sysctl -p
else
    systemctl restart sshd
    systemclt disable postfix.service
    systemctl stop postfix.service
    systemctl stop firewalld
    systemctl disable firewalld
    yum install iptables-services -y
    if [ ! -f '/etc/sysctl.d/addsys.conf' ];then
        echo "$SYSCONF" >> /etc/sysctl.d/addsys.conf 
    fi 
    /sbin/sysctl -p
fi 
