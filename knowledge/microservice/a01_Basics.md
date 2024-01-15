### Microservices a01 Basics
---

#### 1. 微服务的优势与劣势

#### 2. 什么是 Protobuf， 优点是什么
- Protobuf 使用 http/2 协议，有较高的的编码效率和传输效率

#### 2. Consul 的功能与应用
- service discovery, A 服务向 Consul 注册自己的名字以及服务地址, B 服务向 Consul 请求所需服务名字(A)，获取服务 A 地址;
- healthly checker;
- load balance;
- configuration center;
