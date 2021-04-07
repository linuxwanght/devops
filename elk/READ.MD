### 根据id正则匹配删除数据
根据id正则匹配删除数据
curl -XPOST "http://10.79.32.96:9200/retail_message_center/_delete_by_query" -H 'Content-Type: application/json' -d'{    "query": {        "regexp": {            "id": "2021011[0-9].+"         }    }}'


根据id正则匹配查询数据：
curl -XGET "http://10.79.32.96:9200/retail_message_center/_search/?size=1" -H 'Content-Type: application/json' -d'{    "query": {        "regexp": {            "id": "20210130[0-9].+"         }    }}' && date

查询单个索引长度：
curl -XGET "http://10.79.32.96:9200/retail_message_center/_search/?size=1"

curl 10.79.32.96:9200/_cat/thread_pool



### 修改es副本数量
PUT 7a_cool/_settings
{
  "index": {
        "number_of_replicas": "0"
        }
}


{   "index": {  "number_of_replicas": "0" }}

curl -XPUT "http://10.79.32.96:9200/retail_message_center/_settings" -H 'Content-Type: application/json' -d'{   "index": {  "number_of_replicas": "0" }}'

### 查看分片状态
curl 10.79.32.96:9200/_cat/shards/retail_message_center

### 查看es集群状态
curl -XGET 'http://10.79.32.96:9200/_cat/nodes?pretty'

curl -XGET 'http://10.79.32.96:9200/_cat/health?pretty'


curl -XGET http://10.79.32.96:9200/_cat/indices


# 设置所有索引副本为0
curl -XPUT "http://10.79.34.207:9200/*/_settings" -H 'Content-Type: application/json' -d'{  "index": {        "number_of_replicas": "0"        }}'



可以通过命令 _cluster/health 查看集群的健康状态，如下：
Green 主分片与副本分片都正常
Yellow 主分片正常，副本分片不正常
Red 有主分片不正常，可能某个分片容量超过了磁盘大小等