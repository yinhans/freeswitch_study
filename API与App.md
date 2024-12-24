# API与APP
FreeSwitch的命令不仅可以在控制台上使用，也可以在各种嵌入式脚本、EventSocket（fs_cli就是使用了ESL库）或HTTP RPC上使用，所有命令都遵循一个抽象的接口，因而这些命令又称为API Commands。<br/>
## echo
echo 则是一个常用的应用程序（Application，App），它的作用是控制一个Channel的一端，一个Channel有两端，一端使用户（比如Hans），另一端就是echo。电话接通后相当于Hans在和echo通话。它们实际上组成了FreeSwitch的一条腿（leg），这种通话称为“单腿通话”（one-legged connection）。
## park
另一个常用的App是park，使用格式如下
```bash
originate user/hans &park
```
初始化一个呼叫时，在hans接电话后对端必须有一个人在跟其讲话，而如果此时FreeSwitch找不到一个合适的人跟hans进行通话，那么它可以将该电话挂起，park便是实现了这个功能，它相当于一个Channel特殊的一端
park的用户体验并不好，因为hans不知道要等多长时间才有人接电话，由于它听不到任何声音，这时就会奇怪到底有没有接通。相对而言，另一个程序hold则比较友好，因为hold程序会一直等待，直到有用户接听，或者超时。并且hold能够在等待的同时保持音乐（Music on Hold，MOH）
```bash
    originate user/hans &hold
    # 播放特定的文件
    originate user/hans &playback(/root/welcome.wav)
    # 直接录音
    originate user/hans &record(/tmp/voice_of_hans.wav)
```
以上的例子实际上只是建立了一个Channel，相当于将FreeSwitch作为一个软电话和hans进行通话。它是个一条腿（只有a-leg）的通话，在大多数情况下，FreeSwitch都是作为一个B2BUA来桥接两个UA进行通话的。在hans接听电话后，bridge程序可以再启动一个UA来呼叫bob
```bash
    originate user/hans &bridge(user/bob)
```
此时，hans和bob终于可以通话了，也可以通过另一种方式建立他们之间的通话，具体步骤如下
```bash
    originate user/hans &park
    originate user/bob &park
    show channels
    uuid_bridge <hans_uuid> <bob_uuid>
```
简单来说，⼀个App是⼀个程序（Application），它作为⼀个Channel
⼀端与另⼀端的UA进⾏通信，相当于它⼯作在Channel内部；⽽⼀个API则
是独⽴于⼀个Channel之外的，它只能通过找到Channel的UUID来控制⼀个
Channel（如果需要的话），相当于⼀个第三者。这就是API与App最本质
的区别。

## API命令帮助
使用help可以列出所有命令的帮助信息
