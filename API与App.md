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
