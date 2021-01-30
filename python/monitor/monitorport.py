# Prometheus monitor server port.
# -*- coding:utf-8 -*-
import socket
import os
import yaml
import prometheus_client
from prometheus_client import Gauge
from prometheus_client.core import CollectorRegistry
from flask import Response, Flask

app = Flask(__name__)

def Getconfigdic():
    """
    将 yaml 配置文件中数据格式化为字典
    """
    proPath = os.path.dirname(os.path.realpath(__file__))
    yamlPath = os.path.join(proPath, "host_port_conf.yaml")
    f = open(yamlPath, "r", encoding="utf-8")
    sdata = yaml.full_load(f)
    f.close()
    return sdata

def Exploreport(nodename,ip,port):
    """
    检查端口是否存在
    """
    try:
        tel = socket.socket()
        tel.connect((ip, int(port)))
        socket.setdefaulttimeout(0.5)
        result_dic = {"nodename": nodename, "host": ip, "port": str(port), "status": 1}
        return result_dic
    except:
        result_dic = {"nodename": nodename, "host": ip, "port": str(port), "status": 0}
        return result_dic

def Checkport():
    """
    Getconfigdic()函数拿到的数据格式
    sdic = {'zookeeper': {'host': ['192.168.7.51', '192.168.7.52', '192.168.7.53'], 'port': [2181, 22]},
            'harbor': {'host': ['192.168.7.41', '192.168.7.42', '192.168.7.43'], 'port': [9200, 9301]}}
    """
    sdic = Getconfigdic()
    result_list = []
    for nodename in sdic.keys():
        iplist = sdic.get(nodename).get("host")
        portlist = sdic.get(nodename).get("port")
        for ip in iplist:
            for port in portlist:
                result_dic = Exploreport(nodename, ip, port)
                result_list.append(result_dic)
    return result_list

@app.route("/metrics")
def ApiResponse():
    """
    Checkport() 取出来的数据是这样的
    checkport = [{"nodename":"zookeeper","host": "192.16.1.22", "port": "2181", "status": 0},
                  {"nodename":"zookeeper","host": "192.168.1.23", "port": "2181", "status": 1}]
    """
    checkport = Checkport()
    # 定义metrics仓库，存放多条数据
    REGISTRY = CollectorRegistry(auto_describe=False)
    muxStatus = Gauge("server_port_up", "Api response stats is:", ["nodename","host", "port"], registry=REGISTRY)
    for datas in checkport:
        nodename = "".join(datas.get("nodename"))
        host = "".join(datas.get("host"))
        port = "".join(datas.get("port"))
        status = datas.get("status")
        muxStatus.labels(nodename,host, port).set(status)
    return Response(prometheus_client.generate_latest(REGISTRY),
                    mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)

