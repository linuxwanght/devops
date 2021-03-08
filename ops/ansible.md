
## ansible 配置文件
1. inventory
#该参数表示资源清单inventory文件的位置，资源清单就是一些Ansible需要连接管理的主机列表  
#inventory = /root/ansible/hosts

2. library
#Ansible的操作动作,无论是本地或远程，都使用一小段代码来执行，这小段代码称为模块，这个library参数就是指向存放Ansible模块的目录  
#library = /usr/share/ansible

3. forks
#设置默认情况下Ansible最多能有多少个进程同时工作,默认设置最多5个进程并行处理。具体需要设置多少个，可以根据控制主机的性能和被管理节点的数量来确定。  
#forks = 5

4. sudo_user
#这是设置默认执行命令的用户,也可以在playbook中重新设置这个参数
#sudo_user = root
#注意: 新版本已经做了修改,如ansible2.4.1下已经为:
#default_sudo_user = root

5. remote_port
#这是指定连接被关节点的管理端口，默认是22,除非设置了特殊的SSH端口,不然这个参数是不需要被修改的
#remote_port = 22

6. host_key_checking
#这是设置是否检查ssh主机的秘钥，可以设置为True或者False
#host_key_checking = False

7. timeout
#这是设置ssh连接的超时间隔，单位是秒
#timeout = 20

8. log_path
#ansible系统默认是不记录日志的,如果想把ansible系统的输出记录到指定地方，需要设置log_path来指定一个存储Ansible日志的文件

9. private_key_file
#在使用ssh公钥私钥登录系统时使用的秘钥路径
#private_key_file=/path/to/file.pem
ansible.cfg
```
[defaults]
inventory = /tmp/hosts
forks = 5
default_sudo_user = root
remote_port = 22
host_key_checking = Falsetimeout = 20
log_path = /var/log/ansible.log
#private_key_file=/tmp/file.pem
```
常用命令
```
ansible:    这个命令是日常工作中使用率非常高的命令之一，主要用于临时一次性操作；
ansible-doc:    是Ansible模块文档说明，针对每个模块都有详细的用法说明和应用案例介绍；
ansible-galaxy:    可以简单的理解为Github或PIP的功能，通过ansible-galaxy，我们可以下载安装优秀个Roles；
ansible-playbook:    是日常应用中使用频率最高的命令，其工作机制是，通过读取预先编写好的playbook文件实现批量管理；
ansible-pull:    Ansible的另一种工作模式，pull模式，ansible默认使用push模式；
ansible-vault:    主要用于配置文件加密；
ansible-console:    让用户可以在ansible-console虚拟出来的终端上像Shell一样使用Ansible内置的各种命令；
```

## 常用模块

|模块名|	作用|	用例|
|-|-|-|
|command|	默认模块|	ansible webserver -a "/sbin/reboot" -f 10
|shell	|执行shell命令|	ansible test -m shell -a "echo $HOSTNAME"
|filetransfer	|文件传输|	ansible test -m copy -a "src=/etc/hosts dest=/tmp/hosts"
|managingpackages	|管理软件包|	ansible test -m yum -a "name=nginx state=present"
|user and groups	|用户和组|	ansible test -m user -a "name=jeson password=123456"
|Deploying	|部署模块|	ansible test -m git -a "repo=https://github.com/iopsgroup/imoocc dest=/opt/iops version=HEAD"
|managingservices|	服务管理|	ansible test -m service -a "name=nginx state=started"
|BackgroundOperatiions	|后台运行|	ansible test -B 3600 -a "/usr/bin/running_operation --do-stuff"
|gatheringfacts	|搜集系统信息|	ansible test -m setup


## playbook
ansible-playbook执行常用命令参数:

执行方式：ansible-playbook playbook.yml [options]
```
 -u REMOTE_USER, --user=REMOTE_USER  
# ssh 连接的用户名
 -k, --ask-pass    
# ssh登录认证密码
 -s, --sudo           
# sudo 到root用户，相当于Linux系统下的sudo命令
 -U SUDO_USER, --sudo-user=SUDO_USER    
# sudo 到对应的用户
 -K, --ask-sudo-pass     
# 用户的密码（—sudo时使用）
 -T TIMEOUT, --timeout=TIMEOUT 
# ssh 连接超时，默认 10 秒
 -C, --check      
# 指定该参数后，执行 playbook 文件不会真正去执行，而是模拟执行一遍，然后输出本次执行会对远程主机造成的修改

 -e EXTRA_VARS, --extra-vars=EXTRA_VARS    
# 设置额外的变量如：key=value 形式 或者 YAML or JSON，以空格分隔变量，或用多个-e

 -f FORKS, --forks=FORKS    
# 进程并发处理，默认 5
 -i INVENTORY, --inventory-file=INVENTORY   
# 指定 hosts 文件路径，默认 default=/etc/ansible/hosts
 -l SUBSET, --limit=SUBSET    
# 指定一个 pattern，对- hosts:匹配到的主机再过滤一次
 --list-hosts  
# 只打印有哪些主机会执行这个 playbook 文件，不是实际执行该 playbook
 --list-tasks   
# 列出该 playbook 中会被执行的 task

 --private-key=PRIVATE_KEY_FILE   
# 私钥路径
 --step    
# 同一时间只执行一个 task，每个 task 执行前都会提示确认一遍
 --syntax-check  
# 只检测 playbook 文件语法是否有问题，不会执行该 playbook 
 -t TAGS, --tags=TAGS   
# 当 play 和 task 的 tag 为该参数指定的值时才执行，多个 tag 以逗号分隔
 --skip-tags=SKIP_TAGS   
# 当 play 和 task 的 tag 不匹配该参数指定的值时，才执行
 -v, --verbose   
# 输出更详细的执行过程信息，-vvv可得到所有执行过程信息。
```

### playbook yml的组成
```
> hosts部分：
# 使用hosts指示使用哪个主机或主机组来运行下面的tasks，
# 每个playbook都必须指定hosts，hosts也可以使用通配符格式。
# 主机或主机组在inventory清单中指定，可以使用系统默认的/etc/ansible/hosts，
# 也可以自己编辑，在运行的时候加上-i选项，指定清单的位置即可。
# 在运行清单文件的时候，--list-hosts选项会显示那些主机将会参与执行task的过程中。

> remote_user：指定远端主机中的哪个用户来登录远端系统，
# 在远端系统执行task的用户，可以任意指定，也可以使用sudo，
# 但是用户必须要有执行相应task的权限。

> tasks：指定远端主机将要执行的一系列动作。tasks的核心为ansible的模块，
# 前面已经提到模块的用法。tasks包含name和要执行的模块，name是可选的，
# 只是为了便于用户阅读，不过还是建议加上去，模块是必须的，同时也要给予模块相应的参数。
```

执行
```
ansible-playbook -i /tmp/hosts --list-hosts ./f1.yaml
ansible-playbook ./f1.yaml

# 执行结果返回
# 红色: 表示有task执行失败或者提醒的信息
# 黄色: 表示执行了且改变了远程主机状态
# 绿色: 表示执行成功
```


### yaml语法和数据结构

#### yaml语法
YAML格式是类似于JSON的文件格式，以便于人理解和阅读,同时便于书写,首先学习了解一下YAML的格式，对我们后面书写playbook很有帮助.
以下为playbook常用到的YAML格式
```
# 大小写敏感
# 使用缩紧表示层级关系(只能空格不能使用tab)
# yaml文件以"---"作为文档的开始
# 在同一行中,#之后的内容表示注释,类似于shell,python和ruby.
# YAML中的列表元素以"-"开头，然后紧跟着一个空格，后面为元素内容,就像这样
- apple
- orange
等价于JSON的这种格式
[
 "apple",
 "orange"
]

# 同一个列表中的元素应该保持相同的缩进，否则会被当做错误处理.
# play中hosts,variables,roles,tasks等对象的表示方法都是键值中间以":"分割表示,":"后面还要增加一个空格.
```

#### 变量定义方式
变量名可以为字母,数字以及下划线

playbook里的变量
```
 1. playbook的yaml文件中定义变量赋值
 2. --exxtra-vars执行参数赋给变量
 3. 在文件中定义变量
 4. 注册变量

# register关键字可以存储指定命令的输出结果到一个自定义的变量中.

---
- hosts: database
  remote_user: root
  vars:
    touch_file: youmen_file
  tasks:
    - name: get date
      command: date
      register: date_output
    - name: touch
      shell: "touch /tmp/{{touch_file}}"
    - name: echo  date_output
      shell: "echo {{date_output.stdout}}>/tmp/{{touch_file}}" 
```

#### yaml数据结构
yaml支持的数据结构
- 字典
- 列表
- 数字，布尔，字符串

```
# 字典
{name:json}

# 列表
- apple
- mango
- orange
```

### 条件判断
#### 简介

在有的时候play的结果依赖于变量、fact或者是前一个任务的执行结果，或者有的时候，我们会基于上一个task执行返回的结果而决定如何执行后续的task。这个时候就需要用到条件判断。

条件语句在Ansible中的使用场景：

在目标主机上定义了一个硬限制，比如目标主机的最小内存必须达到多少，才能执行该task
捕获一个命令的输出，根据命令输出结果的不同以触发不同的task
根据不同目标主机的facts，以定义不同的task
根据目标机的cpu的大小，以调优相关应用性能
用于判断某个服务的配置文件是否发生变更，以确定是否需要重启服务

#### when关键字

1. when基本使用


在ansible中，使用条件判断的关键字就是when。

如在安装包的时候，需要指定主机的操作系统类型，或者是当操作系统的硬盘满了之后，需要清空文件等,可以使用when语句来做判断 。when关键字后面跟着的是python的表达式,在表达式中你能够使用任何的变量或者fact,当表达式的结果返回的是false,便会跳过本次的任务

下面是一个基本的用法示例：
```
---
- name: Install vim
  hosts: all
  tasks:
    - name:Install VIM via yum
      yum: 
        name: vim-enhanced 
        state: installed
      when: ansible_os_family =="RedHat"
      
    - name:Install VIM via apt
      apt: 
        name: vim 
        state: installed
      when: ansible_os_family =="Debian"
      
    - name: Unexpected OS family
      debug: msg="OS Family {{ ansible_os_family }} is not supported" fail=yes
      when: not ansible_os_family =="RedHat" or ansible_os_family =="Debian"
```

2. 比较运算符
在上面的示例当中，我们使用了"=="的比较运算符，在ansible中，还支持如下比较运算符：

- ==：比较两个对象是否相等，相等则返回真。可用于比较字符串和数字
- !=：比较两个对象是否不等，不等则为真。
- >：比较两个对象的大小，左边的值大于右边的值，则为真
- <：比较两个对象的大小，左边的值小于右边的值，则为真
- >=：比较两个对象的大小，左边的值大于等于右边的值，则为真
- <=：比较两个对象的大小，左边的值小于等于右边的值，则为真
下面是一些简单的示例：
```
when: ansible_machine == "x86_64" 

when: max_memory <= 512
```

3. 逻辑运算符

在Ansible中，除了比较运算符，还支持逻辑运算符：

- and：逻辑与，当左边和右边两个表达式同时为真，则返回真
- or：逻辑或，当左右和右边两个表达式任意一个为真，则返回真
- not：逻辑否，对表达式取反
- ()：当一组表达式组合在一起，形成一个更大的表达式，组合内的所有表达式都是逻辑与的关系
示例：
```
# 逻辑或
when: ansible_distribution == "RedHat" or ansible_distribution == "Fedora"

# 逻辑与
when: ansible_distribution_version == "7.5" and ansible_kernel == "3.10.0-327.el7.x86_64"

when:
  - ansible_distribution_version == "7.5"
  - ansible_kernel == "3.10.0-327.el7.x86_64"
  
# 组合

when: => 
  ( ansible_distribution == "RedHat" and ansible_distribution_major_version == "7" )
  or
  ( ansible_distribution == "Fedora" and ansible_distribution_major_version == "28")
```  
一个完整的例子：
```
# 判断register注册变量的返回结果
- name: restart httpd if postfix is running
  hosts: test
  tasks:
    - name: get postfix server status
      command: /usr/bin/systemctl is-active postfix
      ignore_errors: yes
      register: result
      
    - name: restart apache httpd based on postfix status
      service:
        name: httpd
        state: restarted
      when: result.rc == 0
```



#### 条件判断与tests

在shell当中，我们可使用test命令来进行一些常用的判断操作，如下：
```
# 判断/test文件是否存在
test -e /test

# 判断/testdir是否存在且为一个目录
test -d /testdir
```
事实上，在ansible中也有类似的用法，只不过ansible没有使用linux的test命令，而是jinja2模板的tests。

下面是一个简单示例：
```
# 通过条件语句判断testpath的路径是否存在
- hosts: test
  vars:
    testpath: /testdir
  tasks:
    - debug:
        msg: "file exist"
      when: testpath is exists
```      
上面的示例中，我们使用了is exists用于路径存在时返回真，也可以使用is not exists用于路径不存在时返回真。也可以在整个条件表达式的前面使用not以取反：
```
- hosts: test
  vars:
    testpath: /testdir1
  tasks:
    - debug:
        msg: "file not exist"
      when: not testpath is exists
```      
在ansible中，除了能够使用exists这种tests之外，还有一些别的tests。接下来我们详细说一说。

##### 判断变量

- defined：判断变量是否已定义，已定义则返回真
- undefined：判断变量是否未定义，未定义则返回真
- none：判断变量的值是否为空，如果变量已定义且值为空，则返回真
示例：
```
- hosts: test
  gather_facts: no
  vars:
    testvar: "test"
    testvar1:
  tasks:
    - debug:
        msg: "testvar is defined"
      when: testvar is defined
    - debug:
        msg: "testvar2 is undefined"
      when: testvar2 is undefined
    - debug:
        msg: "testvar1 is none"
      when: testvar1 is none
```

##### 判断执行结果

- sucess或succeeded：通过任务执行结果返回的信息判断任务的执行状态，任务执行成功则返回true
- failure或failed：任务执行失败则返回true
- change或changed：任务执行状态为changed则返回true
- skip或skipped：任务被跳过则返回true
示例：
```
- hosts: test
  gather_facts: no
  vars:
    doshell: true
  tasks:
    - shell: 'cat /testdir/aaa'
      when: doshell
      register: result
      ignore_errors: true
    - debug:
        msg: "success"
      when: result is success
      
    - debug:
        msg: "failed"
      when: result is failure
      
    - debug:
        msg: "changed"
      when: result is change
      
    - debug:
        msg: "skip"
      when: result is skip
```


##### 判断路径

- file：判断指定路径是否为一个文件，是则为真
- directory：判断指定路径是否为一个目录，是则为真
- link：判断指定路径是否为一个软链接，是则为真
- mount：判断指定路径是否为一个挂载点，是则为真
- exists：判断指定路径是否存在，存在则为真


    特别注意：关于路径的所有判断均是判断主控端上的路径，而非被控端上的路径

示例：
```
- hosts: test
  gather_facts: no
  vars:
    testpath1: "/testdir/test"
    testpath2: "/testdir"
  tasks:
    - debug:
        msg: "file"
      when: testpath1 is file
    - debug:
        msg: "directory"
      when: testpath2 is directory
```

##### 判断字符串
- lower：判断字符串中的所有字母是否都是小写，是则为真
- upper：判断字符串中的所有字母是否都是大写，是则为真
```
- hosts: test
  gather_facts: no
  vars: 
    str1: "abc"
    str2: "ABC"
  tasks:
    - debug:
        msg: "str1 is all lowercase"
      when: str1 is lower
    - debug:
        msg: "str2 is all uppercase"
      when: str2 is upper
```

##### 判断整除
- even：判断数值是否为偶数，是则为真
- odd：判断数值是否为奇数，是则为真
- divisibleby(num)：判断是否可以整除指定的数值，是则为真
示例：
```
- hosts: test
  gather_facts: no
  vars: 
    num1: 6
    num2: 8 
    num3: 15
  tasks:
    - debug: 
        msg: "num1 is an even number"
      when: num1 is even
    - debug:
        msg: "num2 is an odd number"
      when: num2 is odd
    - debug:
        msg: "num3 can be divided exactly by"
      when: num3 is divisibleby(3)
```


##### 其他tests
1. version

可用于对比两个版本号的大小，或者与指定的版本号进行对比，使用语法为version("版本号","比较操作符")
```
- hosts: test
  vars:
    ver1: 1.2
    ver2: 1.3
  tasks:
    - debug:
        msg: "ver1 is greater than ver2"
      when: ver1 is version(ver2,">")
    - debug:
        msg: "system version {{ ansible_distribution_version }} greater than 7.3"
      when: ansible_distribution_version is version("7.3","gt")
```      
version中使用的比较运算符说明：

- 大于： >, gt
- 大于等于： >=, ge
- 小于： <, lt
- 小于等于： <=, le
- 等于： =, ==, eq
- 不等于： !=, <>, ne

2. subset
判断一个list是不是另一个list的子集

3. superset
判断一个list是不是另一个list的父集"
```
- hosts: test
  gather_facts: no
  vars:
    a:
      - 2
      - 5
    b: [1,2,3,4,5]
  tasks:
    - debug:
        msg: "A is a subset of B"
      when: a is subset(b)
    - debug:
        msg: "B is the parent set of A"
      when: b is superset(a)
```

4. in
判断一个字符串是否存在于另一个字符串中，也可用于判断某个特定的值是否存在于列表中
```
- hosts: test
  vars:
    supported_distros:
      - RedHat
      - CentOS
  tasks:
    - debug:
        msg: "{{ ansible_distribution }} in supported_distros"
      when: ansible_distribution in supported_distros
```
5. string
判断对象是否为一个字符串，是则为真

6. number
判断对象是否为一个数字，是则为真
```
- hosts: test
  gather_facts: no
  vars:
    var1: 1
    var2: "1"
    var3: a
  tasks:
    - debug:
        msg: "var1 is a number"
      when: var1 is number
    - debug:
        msg: "var2 is a string"
      when: var2 is string
    - debug:
        msg: "var3 is a string"
      when: var3 is string
```

#### 条件判断与block
1. block
我们在前面使用when做条件判断时，如果条件成立则执行对应的任务。但这就面临一个问题，当我们要使用同一个条件判断执行多个任务的时候，就意味着我们要在某一个任务下面都写一下when语句，而且判断条件完全一样。这种方式不仅麻烦而且显得low。Ansible提供了一种更好的方式来解决这个问题，即block。

在ansible中，使用block将多个任务进行组合，当作一个整体。我们可以对这一个整体做条件判断，当条件成立时，则执行块中的所有任务：
```
- hosts: test
  tasks:
    - debug:
        msg: "task1 not in block"
    - block:
        - debug:
            msg: "task2 in block1"
        - debug:
            msg: "task3 in block1"
      when: 2 > 1
```      
下面是一个稍微有用点儿的例子：
```
- hosts: test
  tasks:
    - name: set /etc/resolv.conf
      template: 
        src: resolv.conf.j2 
        dest: /etc/resolv.conf 
        owner: root 
        group: root 
        mode: 0644
    - block:
        - name: ensure /etc/resolvconf/resolv.conf.d/base file for ubuntu 16.04
          template: 
            src: resolv.conf.j2
            dest: /etc/resolvconf/resolv.conf.d/base
       
        - name: config dns for ubuntu 16.04
          template: 
            src: resolv.conf.j2
            dest: /etc/resolv.conf
      when: ansible_distribution == "Ubuntu" and ansible_distribution_major_version == "16" 
```
使用block注意事项：

    1. 可以为block定义name（ansible 2.3增加的特性）
    2. 可以直接对block使用when，但不能直接对block使用loop


2. rescue

block除了能和when一起使用之外，还能作错误处理。这个时候就需要用到rescue关键字：
```
- hosts: test
  tasks:
    - block:
        - shell: 'ls /testdir'
      rescue:
        - debug:
            msg: '/testdir is not exists'
```

在上面的例子中，当block中的任务执行失败时，则运行rescue中的任务。如果block中的任务正常执行，则rescue的任务就不会被执行。如果block中有多个任务，则任何一个任务执行失败，都会执行rescue。block中可以定义多个任务，同样rescue当中也可以定义多个任务。

3. always

当block执行失败时，rescue中的任务才会被执行；而无论block执行成功还是失败，always中的任务都会被执行：
```
- hosts: test
  tasks:
    - block:
        - shell: 'ls /testdir'
      rescue:
        - debug:
            msg: '/testdir is not exists'
      always:
        - debug:
            msg: 'This task always executes'
```


#### 条件判断与错误处理
在上面讲block的使用方法的时候，我们说block除了可以将多个任务组合到一起，还有错误处理的功能。接下来我们继续说一说错误处理。


1. fail模块

在shell中，可能会有这样的需求：当脚本执行至某个阶段时，需要对某个条件进行判断，如果条件成立，则立即终止脚本的运行。在shell中，可以直接调用"exit"即可执行退出。事实上，在playbook中也有类似的模块可以做这件事。即fail模块。

fail模块用于终止当前playbook的执行，通常与条件语句组合使用，当满足条件时，终止当前play的运行。

选项只有一个：

- msg：终止前打印出信息

示例：
```
# 使用fail模块中断playbook输出
- hosts: test
  tasks:
    - shell: echo "Just a test--error" 
      register: result
    - fail:
        msg: "Conditions established,Interrupt running playbook"
      when: "'error' in result.stdout"
    - debug:
        msg: "Inever execute,Because the playbook has stopped"
```

2. failed_when

事实上，当fail和when组合使用的时候，还有一个更简单的写法，即failed_when，当满足某个条件时，ansible主动触发失败。
```
# 如果在command_result存在错误输出，且错误输出中，包含了`FAILED`字串，即返回失败状态：
- name: this command prints FAILED when it fails
  command: /usr/bin/example-command -x -y -z
  register: command_result
  failed_when: "'FAILED' in command_result.stderr"
```  
也可以直接通过fail模块和when条件语句，写成如下：
```
- name: this command prints FAILED when it fails
  command: /usr/bin/example-command -x -y -z
  register: command_result
  ignore_errors: True

- name: fail the play if the previous command did not succeed
  fail: msg="the command failed"
  when: " command_result.stderr and 'FAILED' in command_result.stderr"

```  
    ansible一旦执行返回失败，后续操作就会中止，所以failed_when通常可以用于满足某种条件时主动中止playbook运行的一种方式。

    ansible默认处理错误的机制是遇到错误就停止执行。但有些时候，有些错误是计划之中的。我们希望忽略这些错误，以让playbook继续往下执行。这个时候就可以使用ignore_errors忽略错误，从而让playbook继续往下执行。

3. changed_when

当我们控制一些远程主机执行某些任务时，当任务在远程主机上成功执行，状态发生更改时，会返回changed状态响应，状态未发生更改时，会返回OK状态响应，当任务被跳过时，会返回skipped状态响应。我们可以通过changed_when来手动更改changed响应状态。示例如下：
```
- shell: /usr/bin/billybass --mode="take me to the river"
register: bass_result
changed_when: "bass_result.rc != 2"    #只有该条task执行以后，bass_result.rc的值不为2时，才会返回changed状态

# this will never report 'changed' status
- shell: wall 'beep'
  changed_when: False    #当changed_when为false时，该条task在执行以后，永远不会返回changed状态
```

#### 在循环语句中使用条件语句

### 循环
|循环类型|	关键字|
|-|-|	
|标准循环	|with_items	
|嵌套循环	|with_nested	
|遍历字典	|with_dict	
|并行遍历列表|	with_together	
|遍历列表和索引|	with_indexed_items	
|遍历文件列表的内容|	with_file	
|遍历目录文件	|with_fileglog	
|重试循环	|until	
|查找第一个匹配文件|	with_first_found	
|随机选择	|with_random_choice	
|在序列中循环|	with_sequence


条件循环语句复用
- 标准循环
```
---
- hosts: nginx
  tasks:
  - name: add serveral users
    user: name={{ item.name }} state=present groups={{ item.groups }}
    with_items:
      - { name: 'testuser1',groups: 'wheel' }
      - { name: 'testuser2',groups: 'root'  }
```


- 遍历字典

```
---
- hosts: nginx
  remote_user: root
  tasks:
    - name: add serveral users
      user: name={{ item.key }} state=present groups={{ item.value }}
      with_dict:
        { 'testuser3':'wheel','testuser4':'root' }
```

- 遍历目录中的内容

```
---
- hosts: nginx
  remote_user: root
  tasks:
   - file: dest=/tmp/aa state=directory
   - copy: src={{ item }} dest=/tmp/bb owner=root mode=600
     with_fileglob:
       - aa/*n
```

### 条件语句结合循环语句使用场景
```
---
- hosts: nginx
  remote_user: root
  tasks:
    - debug: msg="{{ item.key }} is the winner"
      with_dict: {'jeson':{'english':60,'chinese':30},'tom':{'english':20,'chinese':30}}
      when: item.value.english >= 10

```

## 异常
### 异常处理
- 1. 忽略异常
  
    默认会检查命令和模块的返回状态,遇到错误就中断playbook的执行
    加入参数: ignore_errors: yes
    Example
    
```
- hosts: nginx
  remote_user: root
  tasks:
    - name: ignore false
      command: /bin/false
      ignore_errors: yes
    - name: touch a file
      file: path=/tmp/test22 state=touch mode=0700 owner=root group=root
```    

### 标签处理
```
---
- hosts: nginx
  remote_user: root
  tasks:
    - name: get process
      shell: touch /tmp/change_test2
      changed_when: false
```

标签使用
```
-t : 执行指定的tag标签任务
--skip-tags: 执行 --skip-tags之外的标签任务
```

### 自定义change状态
```
---
- hosts: nginx
  remote_user: root
  tasks:
    - name: get process
      shell: ps -ef |wc -l
      register: process_count
      failed_when: process_count > 3
    - name: touch a file
      file: path=/tmp/test1 state=touch mode=0700 owner=root group=root
```

## roles

inlcude的用法
```
include_tasks/include: 动态的包含tasks任务列表执行
```

剧本结构和设计思路
```
production        # 正式环境的inventory文件
staging           #测试环境用得inventory文件
group_vars/  	  # 机器组的变量文件
      group1        
      group2
host_vars/   	 #执行机器成员的变量
      hostname1     
      hostname2
================================================
site.yml               # 主要的playbook剧本
webservers.yml         # webserver类型服务所用的剧本
dbservers.yml          # 数据库类型的服务所用的剧本

roles/
      webservers/        #webservers这个角色相关任务和自定义变量
           tasks/
               main.yml
           handlers/
               main.yml
           vars/            
                main.yml
        dbservers/         #dbservers这个角色相关任务和定义变量
            ...
      common/       	  # 公共的
           tasks/        
                main.yml    
           handlers/    
                main.yml    # handlers file.
           vars/            # 角色所用到的变量
                main.yml    # 
===============================================
      templates/    #
            ntp.conf.j2 # 模版文件
      files/        #   用于上传存放文件的目录
            bar.txt     
            foo.sh     
      meta/         # 角色的依赖
            main.yml   
```


### playbook 高级用法
#### 本地执行
如果希望在控制主机本地运行一个特定的任务，可以使用local_action语句。

假设我们需要配置的远程主机刚刚启动，如果我们直接运行playbook，可能会因为sshd服务尚未开始监听而导致失败，我们可以在控制主机上使用如下示例来等待被控端sshd端口监听：
```
- name: wait for ssh server to be running
  wait_for
      port: 22 
      host: "{{ inventory_hostname }}" 
      search_regex: OpenSSH
  connection: local
```





#### 任务委托
在有些时候，我们希望运行与选定的主机或主机组相关联的task，但是这个task又不需要在选定的主机或主机组上执行，而需要在另一台服务器上执行。

这种特性适用于以下场景：

在告警系统中启用基于主机的告警
向负载均衡器中添加或移除一台主机
在dns上添加或修改针对某个主机的解析
在存储节点上创建一个存储以用于主机挂载
使用一个外部程序来检测主机上的服务是否正常
可以使用delegate_to语句来在另一台主机上运行task：
```
- name: enable alerts for web servers
  hosts: webservers
  tasks:
    - name: enable alerts
      nagios: action=enable_alerts service=web host="{{ inventory_hostname }}"
      delegate_to: nagios.example.com
```      
    如果delegate_to: 127.0.0.1的时候，等价于local_action
#### 任务暂停
有些情况下，一些任务的运行需要等待一些状态的恢复，比如某一台主机或者应用刚刚重启，我们需要需要等待它上面的某个端口开启，此时就需要将正在运行的任务暂停，直到其状态满足要求。

Ansible提供了wait_for模块以实现任务暂停的需求

wait_for模块常用参数：

- connect_timeout：在下一个任务执行之前等待连接的超时时间
- delay：等待一个端口或者文件或者连接到指定的状态时，默认超时时间为300秒，在这等待的300s的时间里，wait_for模块会一直轮询指定的对象是否到达指定的状态，delay即为多长时间轮询一次状态。
- host：wait_for模块等待的主机的地址，默认为127.0.0.1
- port：wait_for模块待待的主机的端口
- path：文件路径，只有当这个文件存在时，下一任务才开始执行，即等待该文件创建完成
- state：等待的状态，即等待的文件或端口或者连接状态达到指定的状态时，下一个任务开始执行。当等的对象为端口时，状态有started，stoped，即端口已经监听或者端口已经关闭；当等待的对象为文件时，状态有present或者started，absent，即文件已创建或者删除；当等待的对象为一个连接时，状态有drained，即连接已建立。默认为started
- timeout：wait_for的等待的超时时间,默认为300秒
示例：
```
#等待8080端口已正常监听，才开始下一个任务，直到超时
- wait_for: 
    port: 8080 
    state: started  
    
#等待8000端口正常监听，每隔10s检查一次，直至等待超时
- wait_for: 
    port: 8000 
    delay: 10 
    
#等待8000端口直至有连接建立
- wait_for: 
    host: 0.0.0.0 
    port: 8000 
    delay: 10 
    state: drained
    
#等待8000端口有连接建立，如果连接来自10.2.1.2或者10.2.1.3，则忽略。
- wait_for: 
    host: 0.0.0.0 
    port: 8000 
    state: drained 
    exclude_hosts: 10.2.1.2,10.2.1.3 
    
#等待/tmp/foo文件已创建    
- wait_for: 
    path: /tmp/foo 

#等待/tmp/foo文件已创建，而且该文件中需要包含completed字符串    
- wait_for: 
    path: /tmp/foo 
    search_regex: completed 

#等待/var/lock/file.lock被删除    
- wait_for: 
    path: /var/lock/file.lock 
    state: absent 
    
#等待指定的进程被销毁
- wait_for: 
    path: /proc/3466/status 
    state: absent 
    
#等待openssh启动，10s检查一次
- wait_for: 
    port: 22 
    host: "{{ ansible_ssh_host | default(inventory_hostname) }}" search_regex: OpenSSH 
    delay: 10 
```


#### 滚动更新
默认情况下，ansible会并行的在所有选定的主机或主机组上执行每一个task，但有的时候，我们会希望能够逐台运行。最典型的例子就是对负载均衡器后面的应用服务器进行更新时。通常来讲，我们会将应用服务器逐台从负载均衡器上摘除，更新，然后再添加回去。我们可以在play中使用serial语句来告诉ansible限制并行执行play的主机数量。

下面是一个在amazon EC2的负载均衡器中移除主机，更新软件包，再添加回负载均衡的配置示例：
```
- name: upgrade pkgs on servers behind load balancer
  hosts: myhosts
  serial: 1
  tasks:
    - name: get the ec2 instance id and elastic load balancer id
      ec2_facts:

    - name: take the host out of the elastic load balancer id
      local_action: ec2_elb
      args:
        instance_id: "{{ ansible_ec2_instance_id }}"
        state: absent

    - name: upgrade pkgs
      apt: 
          update_cache: yes 
          upgrade: yes

    - name: put the host back n the elastic load balancer
      local_action: ec2_elb
      args:
        instance_id: "{{ ansible_ec2_instance_id }}"
        state: present
        ec2_elbs: "{{ items }}"
      with_items: ec2_elbs
```

在上述示例中，serial的值为1，即表示在某一个时间段内，play只在一台主机上执行。如果为2，则同时有2台主机运行play。

一般来讲，当task失败时，ansible会停止执行失败的那台主机上的任务，但是继续对其他 主机执行。在负载均衡的场景中，我们会更希望ansible在所有主机执行失败之前就让play停止，否则很可能会面临所有主机都从负载均衡器上摘除并且都执行失败导致服务不可用的场景。这个时候，我们可以使用serial语句配合max_fail_percentage语句使用。max_fail_percentage表示当最大失败主机的比例达到多少时，ansible就让整个play失败。示例如下：
```
- name: upgrade pkgs on fservers behind load balancer
  hosts: myhosts
  serial: 1
  max_fail_percentage: 25
  tasks:
    ......
```    
假如负载均衡后面有4台主机，并且有一台主机执行失败，这时ansible还会继续运行，要让Play停止运行，则必须超过25%，所以如果想一台失败就停止执行，我们可以将max_fail_percentage的值设为24。如果我们希望只要有执行失败，就放弃执行，我们可以将max_fail_percentage的值设为0。

#### 只执行一次

某些时候，我们希望某个task只执行一次，即使它被绑定到了多个主机上。例如在一个负载均衡器后面有多台应用服务器，我们希望执行一个数据库迁移，只需要在一个应用服务器上执行操作即可。

可以使用run_once语句来处理：
```
- name: run the database migrateions
  command: /opt/run_migrateions
  run_once: true
```  
还可以与local_action配合使用，如下：
```
- name: run the task locally, only once
  command: /opt/my-custom-command
  connection: local
  run_once: true
```  
还可以与delegate_to配合使用，让这个只执行一次的任务在指定的机器上运行：
```
- name: run the task locally, only once
  command: /opt/my-custom-command
  run_once: true
  delegate_to: app.a1-61-105.dev.unp
```  
#### 设置环境变量

我们在命令行下执行某些命令的时候，这些命令可能会需要依赖环境变量。比如在安装某些包的时候，可能需要通过代理才能完成完装。或者某个脚本可能需要调用某个环境变量才能完成运行。

ansible 支持通过environment关键字来定义一些环境变量。

在如下场景中可能需要用到环境变量：

- 运行shell的时候，需要设置path变量
- 需要加载一些库，这些库不在系统的标准库路径当中
下面是一个简单示例：
```
---
- name: upload a remote file to aws s3
  hosts: test
  tasks:
    - name: install pip
      yum:
        name: python-pip
        state: installed
    
    - name: install the aws tools
      pip:
        name: awscli
        state: present
    
    - name upload file to s3
      shell aws s3 put-object --bucket=my-test-bucket --key={{ ansible_hostname }}/fstab --body=/etc/fstab --region=eu-west-1
      environment:
        AWS_ACCESS_KEY_ID: xxxxxx
        AWS_SECRET_ACCESS_KEY: xxxxxx
```        
事实上，environment也可以存储在变量当中：
```
- hosts: all
  remote_user: root
  vars:
    proxy_env:
      http_proxy: http://proxy.example.com:8080
      https_proxy: http://proxy.bos.example.com:8080
  tasks:
    - apt: name=cobbler state=installed
      environment: proxy_env
```      
#### 交互式提示
在少数情况下，ansible任务运行的过程中需要用户输入一些数据，这些数据要么比较秘密不方便，或者数据是动态的，不同的用户有不同的需求，比如输入用户自己的账户和密码或者输入不同的版本号会触发不同的后续操作等。ansible的vars_prompt关键字就是用来处理上述这种与用户交互的情况的。
```
 - hosts: all
   remote_user: root
   vars_prompt:
      - name: share_user
        prompt: "what is your network username?"
        private: yes
 
      - name: share_pass
        prompt: "what is your network password"
        private: yes
        
    tasks:
      - debug:
          var: share_user
      - debug:
          var: share_pass
```          
vars_prompt常用选项说明：

- private: 默认为yes，表示用户输入的值在命令行不可见
- default：定义默认值，当用户未输入时则使用默认值
- confirm：如果设置为yes，则会要求用户输入两次，适合输入密码的情况