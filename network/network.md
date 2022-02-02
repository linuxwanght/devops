<!--
 * @Author: your name
 * @Date: 2022-02-01 15:30:03
 * @LastEditTime: 2022-02-02 17:24:08
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /devops/network/network.md
-->


应用层：
    浏览器开发者工具（F12 或者 command+option+i）
传输层：   
    路径可达测试：
        telnet www.baidu.com 443
        nc -w 2 -zv www.baidu.com 443
    查看当前网络连接情况
        netstat  
        ss -s
    查看当前连接的速率
        iftop
    查看丢包和乱序等的统计
        netstat -s   
        watch --diff netstat -s    

网络层
    查看网络路径状况
        traceroute www.baidu.com       #就是 traceroute 默认是用 UDP 作为探测协议的，但是很多网络设备并不会对 UDP 作出回应。所以我们改成 ICMP 协议做探测后，网络设备就有回应了。其实，Windows 上的 tracert，就是默认用 ICMP，这一点跟 Linux 正好是反过来的,但是，traceroute 也有一个明显的不足：它不能对这个路径做连续多次的探测

        mtr www.baidu.com -r -c 10     #它可以说是 traceroute 的超集，除了 traceroute 的功能，还能实现丰富的探测报告。尤其是它对每一跳的丢包率的百分比，是用来定位路径中节点问题的重要指标。所以，当你在遇到“连接状况时好时坏的问题”的时候，单纯用一次性的 traceroute 恐怕难以看清楚，那就可以用 mtr，来获取更加全面和动态的链路状态信息了 

    查看路由
        route -n
        netstat -r
        ip route

数据链路层和物理层
   这一层离应用层已经很远了，一般来说是专职的网络团队在负责。如果这一层有问题，就会直接体现在网络层表现上面，比如 IP 会有丢包和延迟等现象，然后会引发传输层异常（如丢包、乱序、重传等）。所以，一个稳定的数据链路层乃至物理层，是网络可靠性的基石。                




三层交换机是有路由功能的交换机。一般来说交换机是工作在二层的，所以这里强调“三层”交换机，就是突出了它带有三层（路由）功能。