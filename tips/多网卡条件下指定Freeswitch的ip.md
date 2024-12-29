## 设置方法
### 1.修改文件 internal.xml和external.xml
位置：/usr/local/freeswitch/conf/sip_profiles/internal.xml
修改内容：<br/>
```xml
<param name="rtp-ip" value="xxx.xxx.xxx.xxx/>
<param name="sip-ip" value="xxx.xxx.xxx.xxx/>
```
### 2.修改文件sofia.conf.xml
位置 autoload_configs/sofia.conf.xml
修改内容:<br/>
```xml
<param name="auto-restart" value="false">

```
该属性设置的目的是防止FS在检测ip地址发生改变后，自动重启sofia模块。
### 3.重启FreeSwitch后，开始测试