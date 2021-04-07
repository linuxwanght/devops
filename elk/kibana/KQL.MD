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


### visuliza

图形说明
 
1、Area ：用区块图来可视化多个不同序列的总体贡献。
 
2、Data ：用数据表来显示聚合的原始数据。其他可视化可以通过点击底部的方式显示数据表。
 
3、Line ：用折线图来比较不同序列。
 
4、Markdown ： 用 Markdown 显示自定义格式的信息或和你仪表盘有关的用法说明。
 
5、Metric ：用指标可视化在你仪表盘上显示单个数字。
 
6、Pie ：用饼图来显示每个来源对总体的贡献。
 
7、Tile map ：用瓦片地图将聚合结果和经纬度联系起来。
 
8、Timeseries ：计算和展示多个时间序列数据。
 
9、Vertical bar ：用垂直条形图作为一个通用图形。

聚合器
1、Count count 聚合返回选中索引模式中元素的原始计数。
2、Average 这个聚合返回一个数值字段的 average 。从下拉菜单选择一个字段。
3、Sum sum 聚合返回一个数值字段的总和。从下拉菜单选择一个字段。
4、Min min 聚合返回一个数值字段的最小值。从下拉菜单选择一个字段。
5、Max max 聚合返回一个数值字段的最大值。从下拉菜单选择一个字段。
6、Unique Count cardinality 聚合返回一个字段的去重数据值。从下拉菜单选择一个字段。
7、Standard Deviation extended stats 聚合返回一个数值字段数据的标准差。从下拉菜单选择一个字段。
8、Percentile percentile 聚合返回一个数值字段中值的百分比分布。从下拉菜单选择一个字段，然后在 Percentiles 框内指定范围。点击 X 移除一个百分比框，点击 +Add 添加一个百分比框。
9、Percentile Rank percentile ranks 聚合返回一个数值字段中你指定值的百分位排名。从下拉菜单选择一个字段，然后在 Values 框内指定一到多个百分位排名值。点击 X 移除一个百分比框，点击 +Add 添加一个数值框

1、Date Histogram date histogram 基于数值字段创建，由时间组织起来。你可以指定时间片的间隔，单位包括秒，分，小时，天，星期，月，年。
2、Histogram 标准 histogram 基于数值字段创建。为这个字段指定一个整数间隔。勾选 Show empty buckets 让直方图中包含空的间隔。
3、Range 通过 range 聚合。你可以为一个数值字段指定一系列区间。点击 Add Range 添加一对区间端点。点击红色 (x) 符号移除一个区间。
4、Date Range date range 聚合计算你指定的时间区间内的值。你可以使用 date math 表达式指定区间。点击 Add Range 添加新的区间端点。点击红色 (/) 符号移除区间。
5、IPv4 Range IPv4 range 聚合用来指定 IPv4 地址的区间。点击 Add Range 添加新的区间端点。点击红色 (/) 符号移除区间。
6、Terms terms 聚合允许你指定展示一个字段的首尾几个元素，排序方式可以是计数或者其他自定义的metric。
7、Filters 你可以为数据指定一组 filters。你可以用 querystring(全文搜索简易检所语法)，也可以用 JSON 格式来指定过滤器，就像在 Discover 页的搜索栏里一样。点击 Add Filter 添加下一个过滤器。
8、Significant Terms 展示实验性的 significant terms 聚合的结果。
9、也许你需要对某一个数据进行计算，你可以使用json表达式：{ "script" : "doc['grade'].value * 1.2" } grade代表字段，后面后面是算数表达式
