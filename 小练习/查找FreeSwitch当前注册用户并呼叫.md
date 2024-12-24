# 查找FreeSwitch当前用户注册用户并呼叫其中一个用户
## 查找当前注册的在线用户
```bash
sofia status profile internal reg
```

## 呼叫其中一个用户
```bash
originate user/1001 &echo
```
echo程序是一个很简单的程序（App），它只是将你说话的内容原样再放给你听