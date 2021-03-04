## 索引模板
```
# 创建索引模板
PUT /_template/模板名称
{
 "index_patterns":["正则，匹配该模板应用的索引"],
 "order":"数值，模板优先级",
 "settings":{
   "settinngs相关配置"
 },
 "mappings":{
   "mappings相关配置"
 }
}


# 查询索引模板
GET /_template/template_name
```


## 索引
```
# 创建index（根据已有template，index_name要满足template定义的索引模式）
PUT /index_name

# 删除索引
DELETE /index_name

# 查询索引定义
GET /index_name

# 查询索引 mapping
GET /index_name/_mapping


```

## 索引数据操作
```
# 将老的索引中的数据复制到新的索引中
POST _reindex
{
  "source": {
    "index": "metricbeat-*"（老的索引名）
  },
  "dest": {
    "index": "metricbeat"（新的索引名）
  }
}



```
## 索引数据查询
```
#查询某一索引数据（Kibana控制台默认显示10条）
GET /index_name/_search

#查询某一索引数据（按指定条数显示）
GET /index_name/_search
{
  "size": 200
}

#查询某一索引一条数据（根据_id）
GET /index_name/_doc/1234


#查询某一索引数据总量
GET /index_name/_count

#根据字段精确查找
GET /index_name/_search
{
  "query": {
    "match": {
      "field_name": field_value
    }
  }
}

#查询存在某字段的数据（或总条数）
GET /index_name/_search
{
  "query": {
    "bool": {
      "must": {
        "exists": {
          "field": "field_name"
        }
      }
    }
  }
}

GET /index_name/_count
{
  "query": {
    "bool": {
      "must": {
        "exists": {
          "field": "field_name"
        }
      }
    }
  }
}


#查询不存在某字段的数据（或总条数）
GET /index_name/_search
{
  "query": {
    "bool": {
      "must_not": {
        "exists": {
          "field": "field_name"
        }
      }
    }
  }
}

GET /index_name/_count
{
  "query": {
    "bool": {
      "must_not": {
        "exists": {
          "field": "field_name"
        }
      }
    }
  }
}

#根据单个字段进行查询重复数据
# size : hits中展示的数据
# min_doc_count : link重复数量大于10的
# 嵌套里面的那个aggs ： 标识再把duplicateDocuments的细节展示出来
POST /index_name/_search
{
  "size": 10,
  "aggs": {
    "duplicateCount": {
      "terms": {
      "field": "field_name",
        "min_doc_count": 10
      },
      "aggs": {
        "duplicateDocuments": {
          "top_hits": {}
        }
      }
    }
  }
}

```

## 服务集群信息
```
#查询集群节点状态信息
# 结果中包括thread_pool信息
GET /_nodes/stats/
```