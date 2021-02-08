## jdk
### download file
wget https://xxx.xxx.com/software/jdk/jdk-8u251-linux-x64.tar.gz
md5sum: becc86d9870fe5f48ca30c520c4b7ab8

### use



## filebeat
### download file
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.10.1-x86_64.rpm
sha512：e45e6680a145628fd98009317e48a5c275b660be7aef28499976cc0d7f66bf6a81ea335e01f57aa57487ee3df96bd496e86056dddfcc6bfcc5e018efd5aa94a4
### use
```
# install filebeat
ansible-playbook filebeat.yml -t install

# update filebeat config
ansible-playbook filebeat.yml -t updateconfig

# stop/start/restart fliebeat
ansible-playbook filebeat.yml -t stop/start/restart
```

## zookeeper
### download file
wget http://archive.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
md5: e4cf1b1593ca870bf1c7a75188f09678  zookeeper-3.4.10.tar.gz

### use
ansible-playbook -i hosts/frankfurt  zookeeper.yml  -t install
ansible-playbook -i hosts/frankfurt  zookeeper.yml  -t start/stop/updateconfig/status

注：部署前需要修改defaults目录下main.yml文件，server.1-3。目标服务器安装位置

## node_exporter
### download file
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
sha256: 3369b76cd2b0ba678b6d618deab320e565c3d93ccb5c2a0d5db51a53857768ae

### use
```
# install node_exporter
ansible-playbook node-exporter.yml -t install/stop/start/restart
```

## kafka
### download file
wget https://apache.website-solution.net/kafka/2.7.0/kafka_2.12-2.7.0.tgz sha512: adad48e6d9c9bf6577fc97db10bfe9ef3755da7b3060ed633edb89eb99722dc81b111bab2c91e7875e0a866a1020c8c31904b088d2a9f9950796eda8ed789ccd

### use
```
# install kafka
ansible-playbook kafa.yml -t install/start/stop
```





## 每个角色的定义，以特定的层级目录结构进行组织。 
- files：存放由copy或script等模块调用的文件； 
- templates：存放template模块查找所需要的模板文件的目录，如mysql配置文件模板； 
- tasks：任务存放的目录； 
- handlers：存放相关触发执行的目录； 
- vars：变量存放的目录； 
- meta：用于存放此角色元数据； 
- default：默认变量存放的目录，文件中定义了此角色使用的默认变量；