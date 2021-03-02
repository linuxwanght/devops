### NGINX LOG FROMAT
    log_format json   '{"@timestamp":"$time_iso8601",'
                      '"host":"$hostname",'
                      '"server_ip":"$server_addr",'
                      '"client_ip":"$remote_addr",'
                      '"xff":"$http_x_forwarded_for",'
                      '"domain":"$host",'
                      '"url":"$uri",'
                      '"referer":"$http_referer",'
                      '"upstreamtime":"$upstream_response_time",'
                      '"responsetime":"$request_time",'
                      '"request_method":"$request_method",'
                      '"status":"$status",'
                      '"size":"$body_bytes_sent",'
                      '"request_length":"$request_length",'
                      '"protocol":"$server_protocol",'
                      '"upstreamhost":"$upstream_addr",'
                      '"file_dir":"$request_filename",'
                      '"http_user_agent":"$http_user_agent"},';

### LOGSTASH 
input {
  # logstash input
    beats {
        port => 5044
    }
}

filter {
  geoip {
    #multiLang => "zh-CN"
    target => "geoip"
    source => "client_ip"
    database => "/usr/share/logstash/GeoLite2-City.mmdb"
    add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
    add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}" ]
    # 去掉显示 geoip 显示的多余信息
    remove_field => ["[geoip][latitude]", "[geoip][longitude]", "[geoip][country_code]", "[geoip][country_code2]", "[geoip][country_code3]", "[geoip][timezone]", "[geoip][continent_code]", "[geoip][region_code]"]
  }
  mutate {
    convert => [ "size", "integer" ]
    convert => [ "status", "integer" ]
    convert => [ "responsetime", "float" ]
    convert => [ "upstreamtime", "float" ]
    convert => [ "[geoip][coordinates]", "float" ]
    # 过滤 filebeat 没用的字段,这里过滤的字段要考虑好输出到es的，否则过滤了就没法做判断
    remove_field => [ "ecs","agent","host","cloud","@version","input","logs_type" ]
  }
  # 根据http_user_agent来自动处理区分用户客户端系统与版本
  useragent {
    source => "http_user_agent"
    target => "ua"
    # 过滤useragent没用的字段
    remove_field => [ "[ua][minor]","[ua][major]","[ua][build]","[ua][patch]","[ua][os_minor]","[ua][os_major]" ]
  }
}
output {
  elasticsearch {
    hosts => ["http://10.79.34.207:9200","http://10.79.35.211:9200","http://10.79.36.43:9200"]
    index => "logstash-nginx-%{+YYYY.MM.dd}"
  }
}
