## openssl 验证证书和密钥匹配
openssl pkey -in privateKey.key -pubout -outform pem | sha256sum 
openssl x509 -in certificate.crt -pubkey -noout -outform pem | sha256sum 
openssl req -in CSR.csr -pubkey -noout -outform pem | sha256sum

## openssl 测试
1.openssl s_server -msg -verify -tls1_2 -state -cert cert.cer -key ..\privkey -accept 18444
使用上面的命令开启一个ssl测试服务器

2.openssl s_client -msg -verify -tls1_2  -state -showcerts -cert cert.cer -key ..\privkey -connect localhost:18444

使用这个命令连接ssl测试服务器，如果连接成功会打印出证书和私钥的信息，然后输入任何字符都会在服务器端echo出来。

## aws  ACM 
证书正文输入（server.crt）
证书私钥输入（server.key）
证书证书链输入（server.ca-bundle）


### tcp 状态统计
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'



### eureka curl手动下线
curl -XDELETE http://10.79.18.73:8701/eureka/apps/USER-MANAGER-SERVICE/user-manager-service:10.79.17.109:8099
sleep 8
curl http://10.79.18.73:8701|grep "10.79.17.109" || sh stop.sh
sh start.sh

curl -XDELETE http://10.79.18.73:8701/eureka/apps/MESSAGE-PUSH-SERVICE/message-push-service:10.79.18.210:9000
sleep 5
curl http://10.79.18.73:8701|grep "10.79.18.210" || sh stop.sh
sh start.sh

curl -XDELETE http://10.79.18.73:8701/eureka/apps/MESSAGE-PUSH-SERVICE/message-push-service:10.79.18.212:9000
sleep 5
curl http://10.79.18.73:8701|grep "10.79.18.212" || sh stop.sh
sh start.sh


### prometheus
* on(instance) group_left(nodename) (node_uname_info)

server_port_up * on(instance) group_left(nodename) (server_port_up) != 1

(node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes * on(instance) group_left(nodename) (node_uname_info) < 20 and ON (instance, device, mountpoint) node_filesystem_readonly == 0


### redis 批量删除key
redis-cli -h 127.0.0.1 -n 10 keys "name:*" | xargs redis-cli -h 127.0.0.1 -n 10 del



### es 删除实例
curl -XPUT '10.79.31.128:9200/_cluster/settings' -d '{"transient": {"cluster.routing.allocation.exclude._ip": "10.55.6.11"}}' 


### es 只读属性删除
curl -XPUT -H "Content-Type: application/json" http://127.0.0.1:9200/retail_message_center/_settings -d '{"index.blocks.read_only_allow_delete": null}'

curl http://localhost:9200/retail_message_center/_settings

curl -XPUT -H "Content-Type: application/json" http://10.79.31.12:9200/retail_message_center/_settings -d '{"index.blocks.read_only_allow_delete": null}'

curl http://10.79.31.12:9200/retail_message_center/_settings

### aws ec2硬盘扩容
sudo growpart /dev/nvme1n1 1
sudo xfs_growfs -d /opt/application

## ec2安装ansible
sudo amazon-linux-extras install ansible2

## curl 
1.传header参数
curl --header 'Token:40d7c342c110414888cc2a0e1284c636' "127.0.0.1/api/user/baseInfo"
或者
curl -H 'Token:40d7c342c110414888cc2a0e1284c636' "127.0.0.1/api/user/baseInfo"

2.通过Get方法请求:
curl "127.0.0.1/api/mobile/getPvHtml"

3.通过post方法请求
curl -d 'name=yyy&mobile=17782376789&detail_address=ddd' "127.0.0.1/api/mobile/memberRecommend"

4.header和post混用

curl --header 'token:d46aeada5d74196a0efa7b2a2bfa9fa' --header 'uid:13045' "api.ginlongmonitoring.com/v1/device/inverter/data?device_id=100459476&start_date=2017-07-31+14%3A54%3A50&end_date=2017-07-31+16%3A54%3A50&perpage=1&timezone_id=PRC”
 
curl -H "Content-Type:application/json" -X POST -d '{"header":{},"request":{"c":"position","m":"rpc/listRecommendPosition","p":{"uid":1226, "shop_id":4}}}' http://common-ats-blue.rpc/atsng/rpc