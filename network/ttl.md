<!--
 * @Author: your name
 * @Date: 2022-02-01 20:54:56
 * @LastEditTime: 2022-02-01 20:54:56
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /devops/network/ttl.md
-->
## ttl
ttl：生存时间
在IPv4中, TTL是IP协议的一个8个二进制位的值【0-255】. 这个值可以被认为是数据包在internet系统中可以跳跃的次数上限. TTL是由数据包的发送者设置的, 在前往目的地的过程中, 每经过一台主机或设备, 这个值就要减少一点. 如果在数据包到达目的地前, TTL值被减到了0，那么这个包将作为一个ICMP错误的数据包被丢弃。

TTL的设置一般情况下与主机的操作系统相关，当然也可以手动去修改。
linux 64
unix 255


拓展-劫持
使用wireshark抓包分析网络流量，可以根据TTL的值来确定是否被劫持。

DNS、HTTP劫持后，一般通过检测TTL的变化或HTML元素检查来判定，判定方法可以从以下几个地方考虑：

查看客户端抓包，服务器的TTL是否有较大波动，如果有较大的波动，很有可能百劫持。
查看TTL的大小，根据网民的实际网络环境，初步判断网民到服务节点的路由个数【虽然比较难】，如果TTL的减量明显很少，只有1-5的减量，那很有可能是被劫持后的流量。
