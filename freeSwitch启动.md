# FreeSwitch启动
## 启动参数
FreeSwtich在启动时默认会启用uPnP（或NAT-PMP）协议试图查找你的路由器是否支持并在你的路由器上“打洞”，如果你的路由器不支持该协议，这一步可能耗时较长，因而会影响启动速度。所以，如果只是在内网测试建议关掉此选项
```bash
# freeswitch
-nonat
# 参数结合使用
# freeswitch
-nc -nonat
```

## 默认快捷键
为了调试⽅便，FreeSWITCH还在conf/autoload_configs/switch.conf.xml
中定义了⼀些控制台快捷键。可以通过F1~F12这⼏个按键来使⽤它们（不
过，在某些操作系统上，有些快捷键可能与操作系统相冲突，这时你就只
能直接输⼊这些命令或重新定义它们了），也可以修改配置⽂件加⼊⽐较
常⽤的命令（修改完毕后记着运⾏reloadxml命令使之⽣效），默认的配置
如下：
```xml
<cli-keybindings>
<key name="1" value="help"/>
<key name="2" value="status"/>
<key name="3" value="show channels"/>
<key name="4" value="show calls"/>
<key name="5" value="sofia status"/>
<key name="6" value="reloadxml"/>
<key name="7" value="console loglevel 0"/>
<key name="8" value="console loglevel 7"/>
<key name="9" value="sofia status profile internal"/>
<key name="10" value="sofia profile internal siptrace on"/>
<key name="11" value="sofia profile internal siptrace off"/>
<key name="12" value="version"/>
</cli-keybindings>
```

### fs_cli
FreeSWITCH是⼀个典型的Client/Server结构，不管FreeSWITCH运⾏
在前台还是后台，你都可以使⽤客户端软件fs_cli连接FreeSWITCH。
fs_cli是⼀个类似Telnet的客户端（也类似于Asterisk中的“asterisk-r”命
令），它使⽤FreeSWITCH的ESL（Event Socket Library）协议与
FreeSWITCH通信。当然，使⽤该协议需要加载模块mod_event_socket，该
模块是默认加载的。
### 使用fs_cli连接到其他机器的FreeSwitch
通过在用户主目录下编辑配置文件.fs_cli_conf 可以定义要连接的多个机器
```bash
[server1]
host => 192.168.1.10
port => 8021
password => secret_password
debug => 7
[server2]
host => 192.168.1.11
port => 8021
password => someother_password
debug => 0
```
注意，如果要连接到其他机器，要确保⽬标机器的FreeSWITCH的
Event Socket是监听在真实⽹卡的IP地址上，⽽不是127.0.0.1，这可以通过
将conf/autoload_configs/event_socekt.conf.xml中的IP地址改成为服务器IP
或“0.0.0.0”实现，当然，这可能带来潜在的安全性问题。如果你的服务器
运⾏在公⽹上，则需要考虑你是否确实需要这样做，或者⾄少考虑设置⼀
下ACL或防⽕墙规则只允许特定的IP地址访问。当然，记得改完后在控制
台上要执⾏“reload mod_event_socket”。另外，在UNIX中，以点开头的⽂
件是隐藏⽂件，普通的“ls”命令是不能列出它的，可以使⽤“ls-a”列出这些
⽂件。