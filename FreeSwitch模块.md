## 事件Event
除了使用Public API及接口回调方式执行内部逻辑和通信外，FreeSwitch在内部也使用消息和事件机制进行进程间和模块间通信。消息机制完全是内部的，事件机制即可在内部使用，也可在外部使用。<br/>
当FreeSwitch内部状态发生变化或收到一些新的消息时，会产生（Fire）一些事件。事件机制是一种“生产者-消费者”模型。事件的产生和处理（生产和消费）是异步的，是一种松耦合关系。这些事件可以在FreeSwitch的内部通过绑定（Bind）一定的回调函数进行捕获，即FreeSwitch的核心事件系统会依次回调这些回调函数，完成相应的功能。另外，在嵌入式脚本（如Lua）中也可以订阅相关的事件并进行处理。</br>
在FreeSwitch外部，也可以通过Event Socket等接口订阅相关的事件，通过这种方式可了解FreeSwitch内部发生了什么，如当前的呼叫状态等。fs_cli就是一个典型的外部程序，它通过Event Socket与FreeSwitch通信，可以对FreeSwtich进行控制和管理，也可以订阅相关的事件对FreeSwitch的运行情况进行监控，订阅事件最简单的方法是：
```bash
    fs_cli>/event plain ALL
```
在fs_cli中执行上述命令可以订阅所有的事件。FreeSwitch的事件主要有两大类：一类是主事件，可以根据事件的名字（Event-Name）来区分，如CHANNEL_ANSWER（应答）、CHANNEL_HANGUP（挂机）等；另一类是自定义事件，他们的Event-Name永远是CUSTOM，不同的事件类型可根据子类型（Event—Subclass）来区分

## 命令接口（FSAPI）
FSAPI简称API，它是一种对外的命令接口，它的原理非常简单-输入一个简单的字符串（以空格分隔）该字符串由
模块的内部函数处理，然后得到⼀个输出。输出可以是⼀个简单的字符
串、⼀⼤串⽂本、XML或JSON⽂本。通过使⽤FSAPI，⼀个模块可以通过命令字符串的⽅式调⽤另⼀个模块提供的功能，⽽不⽤连接其他模块的函数（或代码，实际上FreeSWITCH不⿎励也不⽀持模块间互相连接）。它实际上是⼀种⾼度抽象的输⼊/输出机制，不仅在模块内部，在FreeSWITCH外部也可能通过Event Socket（第3章所说的fs_cli就是⽤这种⽅式）或XML-RPC等进⾏调⽤。系统中⼤部分的API都是由mod_commands模块提供的，有的模块实现了⼀些与本模块相关的API。
## 语音识别及语音合成（ASR/TTS）
⽀持语⾳⾃动识别（ASR）及⽂
本/语⾳转换（TTS）。可以通过本地模块实现（如mod_flite），也可以通
过MRCP协议与其他语⾳产品对接（如mod_unimrcp）实现。

callie表示嗓音（即人的声音，不同的人，音调和音色不同）

## xml配置文件简介
### freeswitch.xml
```xml
<?xml version="1.0"?>
<document type="freeswitch/xml">
<!-- #comment
这是⼀个配置⽂件，本⾏是注释 -->
<X-PRE-PROCESS cmd="include" data="vars.xml"/>
<section name="configuration" description="Various Configuration">
<X-PRE-PROCESS cmd="include" data="autoload_configs/*.xml"/>
</section>
</document>
```
有点类似.h或者库文件，就是将其他的xml文件加载到这个文件中，从而生成一个大的XML配置文件

### vars.xml
vars.xml主要通过X-PRE-PROCESS指令定义了一些全局变量，如：
```xml
    <X-PRE-PROCESS cmd="set" data="domain=$${local_ip_v4}"/>
```
在使用X-PRE-PROCESS设置的变量都称为全局变量，它们在FreeSwitch运行期间永远是有效的。而后面可能还会遇到局部变量，通常在拨号计划中，在一个呼叫的生命周期内才有效。如果需要引用这些变量，则全局变量以$${var}表示，临时变量以${var}表示<br/>
可以使用global_getvar或这个API命令来查看这些变量的值
```bash
    global_getvar sound_prefix
    global_getvar local_ip_v4
```

### autoload_configs目录
autoload_configs目录下的各种配置文件会在系统启动时装入。一般来说都是模块级的配置文件（但是并不是所有的模块都是配置文件）。文件名一般以“模块名.conf.xml”的方式进行命名

### XML用户目录
用户目录的默认配置文件在conf/directory/下，系统自带的配置文件为default.xml，内容如下
```xml
     <domain name="$${domain}">
    <params>
        <param name="jsonrpc-allowed-methods" value="verto"/>
    </params>

    <variables>
      <variable name="record_stereo" value="true"/>
      <variable name="default_gateway" value="$${default_provider}"/>
      <variable name="default_areacode" value="$${default_areacode}"/>
      <variable name="transfer_fallback_extension" value="operator"/>
    </variables>

    <groups>
      <group name="default">
	<users>
	  <X-PRE-PROCESS cmd="include" data="default/*.xml"/>
	</users>
      </group>

      <group name="sales">
	<users>
	  <!--
	      type="pointer" is a pointer so you can have the
	      same user in multiple groups.  It basically means
	      to keep searching for the user in the directory.
	  -->
	  <user id="1000" type="pointer"/>
	  <user id="1001" type="pointer"/>
	  <user id="1002" type="pointer"/>
	  <user id="1003" type="pointer"/>
	  <user id="1004" type="pointer"/>
	</users>
      </group>

      <group name="billing">
	<users>
	  <user id="1005" type="pointer"/>
	  <user id="1006" type="pointer"/>
	  <user id="1007" type="pointer"/>
	  <user id="1008" type="pointer"/>
	  <user id="1009" type="pointer"/>
	</users>
      </group>

      <group name="support">
	<users>
	  <user id="1010" type="pointer"/>
	  <user id="1011" type="pointer"/>
	  <user id="1012" type="pointer"/>
	  <user id="1013" type="pointer"/>
	  <user id="1014" type="pointer"/>
	</users>
      </group>
    </groups>

  </domain>
```
$${domin}全局变量在vars.xml中设置，它默认的是主机的ip地址，可以修改为使用一个域名。在这里定义了一个dial-string，在使用user/name或sofia/internal/username@domain这样的呼叫字符串时，Freeswitch会根据username（以及domain）找到该dial-string，并最终扩展成用户实际的SIP地址。sofia_contact是一个API命令，它会根据用户的注册地址扩展成相应的呼叫字符串
