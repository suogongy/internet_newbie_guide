# 计算机网络基础

[返回章节目录](./index.md) | [返回首页](../README.md)

## 为什么要学习计算机网络？

想象一下互联网就像一个巨大的邮政系统：
- 数据包就像信件
- 路由器就像邮局
- IP地址就像收件地址
- 协议就像邮寄规则

了解计算机网络，就是理解这个"数字邮政系统"是如何工作的。当你发送一条微信，背后是数据包穿越千山万水到达对方手机的壮丽旅程。网络世界的复杂性堪比蚁穴，看似混乱，实则井然有序。

每个程序员都该懂网络，就像每个厨师都该懂食材。不懂网络的程序员，就像不懂海洋的船长，随时可能触礁沉船。

## 网络分层模型

OSI七层模型是网络界的"七层宝塔"，而TCP/IP四层模型则是其简化版。就像把复杂的世界简化成易懂的模型，帮助我们理解网络通信的各个环节。

### 1. 应用层
- 就像你写信的内容
- HTTP、FTP、SMTP、DNS等协议
- 直接服务于用户的协议
- 负责提供各种网络服务

HTTP是现代互联网的基石，它就像餐厅里的点菜流程：客户（浏览器）向服务员（服务器）点餐（请求资源），服务员记下来后去厨房（后台处理），然后端来菜品（返回资源）。

```
// HTTP请求的简化示例
GET /index.html HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html

// HTTP响应的简化示例
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234

<!DOCTYPE html>
<html>
<head>
    <title>Example Page</title>
</head>
<body>
    <h1>Hello, World!</h1>
</body>
</html>
```

### 2. 传输层
- 就像邮局的快递服务
- TCP：可靠传输，像挂号信，确保每个包都送达且按序排列
- UDP：快速传输，像平信，速度快但不保证送达
- 负责端到端的数据传输

TCP的三次握手就像相亲见面：
1. 男：你好，我是张三，我想跟你约会（SYN）
2. 女：你好张三，我是李四，我同意跟你约会（SYN+ACK）
3. 男：太好了李四，那我们开始吧（ACK）

而四次挥手就像朋友道别：
1. 甲：我说完了，准备走了（FIN）
2. 乙：好的，我知道了（ACK）
3. 乙：我也说完了，也准备走了（FIN）
4. 甲：好的，再见（ACK）

```
// TCP连接的伪代码表示
// 三次握手
client.send(SYN, seq=x)
server.receive(SYN, seq=x)
server.send(SYN+ACK, seq=y, ack=x+1)
client.receive(SYN+ACK, seq=y, ack=x+1)
client.send(ACK, seq=x+1, ack=y+1)
server.receive(ACK, seq=x+1, ack=y+1)
// 连接建立完成

// 四次挥手
client.send(FIN, seq=m)
server.receive(FIN, seq=m)
server.send(ACK, ack=m+1)
client.receive(ACK, ack=m+1)
server.send(FIN, seq=n)
client.receive(FIN, seq=n)
client.send(ACK, ack=n+1)
server.receive(ACK, ack=n+1)
// 连接关闭完成
```

### 3. 网络层
- 就像邮局的分拣系统
- IP协议：负责路由和寻址
- 决定数据包如何到达目的地
- 处理网络间的路由和流量控制

IP地址就像门牌号，路由器就像小区的门卫，需要知道每个包裹该送到哪栋楼。路由表就是门卫的送货指南，告诉他看到某个地址应该往哪个方向送。

```
// 简化的路由表示例
RoutingTable = {
    "192.168.1.0/24": { nextHop: "直接投递", interface: "eth0" },
    "10.0.0.0/8": { nextHop: "192.168.1.254", interface: "eth0" },
    "0.0.0.0/0": { nextHop: "192.168.1.1", interface: "eth0" }  // 默认路由
}

function route(packet) {
    let destination = packet.destinationIP;
    let bestMatch = findLongestPrefixMatch(destination, RoutingTable);
    
    if (bestMatch) {
        forwardPacket(packet, bestMatch.nextHop, bestMatch.interface);
    } else {
        dropPacket(packet);  // 没有匹配的路由，丢弃数据包
    }
}
```

### 4. 数据链路层
- 就像邮递员送信的过程
- 处理点对点的数据传输
- 差错检测和控制
- 负责相邻节点间的可靠传输

数据链路层把IP数据包包装成帧(Frame)，就像把信放进信封。以太网协议就像是社区规定的标准信封大小和格式，MAC地址就像是收件人的精确门牌号。

```
// 以太网帧的结构伪代码
class EthernetFrame {
    preamble: "10101010" x 7 + "10101011" x 1,  // 前导码，同步
    destMAC: "00:1A:2B:3C:4D:5E",  // 目标MAC地址
    sourceMAC: "5F:4E:3D:2C:1B:0A",  // 源MAC地址
    type: 0x0800,  // 类型 (0x0800表示IPv4)
    payload: [IP数据包],  // 数据部分
    FCS: [校验和]  // 帧校验序列
}
```

### 5. 物理层
- 就像邮政系统的马路和交通工具
- 定义物理传输介质和信号
- 电缆、光纤、无线电波等
- 负责比特流的传输

物理层关注的是如何在物理媒介上传输比特流，例如将"1"和"0"转换为电压、光信号或无线电波。它定义了网线的规格、接口的形状、无线信号的频率等物理特性。

想象一下，数据传输就像古代的烽火台，一个接一个地传递信息。不同的是，现代网络可以在一根光纤中同时传输数百万个信号，相当于数百万个并行的烽火台！

## 重要概念

### 1. IP地址
- 就像每个房子的门牌号
- IPv4：32位，如192.168.1.1，地址已接近枯竭
- IPv6：128位，如2001:0db8:85a3:0000:0000:8a2e:0370:7334，解决地址不足问题
- 公网IP：可直接从互联网访问，像有门牌号的独栋别墅
- 内网IP：局域网内使用，像小区内部的房间号，需要通过NAT转换才能与外界通信

IP地址分A、B、C、D、E五类，其中A、B、C是常用的：
- A类：1.0.0.0 - 126.255.255.255，首位为0，适合超大型网络
- B类：128.0.0.0 - 191.255.255.255，首两位为10，适合中型网络
- C类：192.0.0.0 - 223.255.255.255，首三位为110，适合小型网络

子网掩码就像是邮政编码，帮助区分网络部分和主机部分：
```
IP地址: 192.168.1.5    二进制：11000000.10101000.00000001.00000101
掩码:   255.255.255.0  二进制：11111111.11111111.11111111.00000000
网络ID: 192.168.1.0    (IP地址 & 掩码)
主机ID: 0.0.0.5        (IP地址 & ~掩码)
```

### 2. DNS系统
- 就像114查号台，将域名翻译成IP地址
- 域名解析服务
- 将www.example.com这样的域名转换为服务器IP地址

DNS查询过程就像层层上报的公司查人流程：
1. 先问本地DNS服务器（就近办事处）
2. 本地不知道就问根DNS服务器（总部）
3. 根DNS推荐去问com顶级域DNS服务器（部门）
4. com顶级域DNS推荐去问example.com的DNS服务器（科室）
5. 最后得到www.example.com的IP地址（找到具体的人）

```
// DNS解析的伪代码
function resolveDomain(domain) {
    // 先查询本地缓存
    let cachedIP = checkDNSCache(domain);
    if (cachedIP) return cachedIP;
    
    // 发送递归查询请求给本地DNS服务器
    return queryLocalDNSServer(domain);
}

function queryLocalDNSServer(domain) {
    // 如果本地DNS有缓存，直接返回
    let cachedIP = localDNS.checkCache(domain);
    if (cachedIP) return cachedIP;
    
    // 否则进行迭代查询
    let result = null;
    
    // 1. 首先查询根域名服务器
    let nameServer = getRootNameServers();
    
    // 2. 迭代查询
    while (nameServer && !result) {
        let response = queryNameServer(nameServer, domain);
        
        if (response.hasAnswer()) {
            result = response.getIP();
        } else {
            nameServer = response.getReferral();  // 获取下一级权威服务器
        }
    }
    
    // 3. 缓存结果
    if (result) localDNS.cache(domain, result);
    
    return result;
}
```

### 3. HTTP协议
- 网页访问的基础
- 请求-响应模型
- GET、POST、PUT、DELETE等方法
- 无状态协议，需要Cookie等机制维持会话

HTTP请求方法就像在图书馆的不同操作：
- GET：借书（获取资源）
- POST：还书（提交数据）
- PUT：修补书（更新资源）
- DELETE：销毁书（删除资源）

HTTP状态码就像快递的送达状态：
- 1xx：信息性状态码，"我收到你的请求了，正在处理"
- 2xx：成功状态码，"你的包裹送到了"
- 3xx：重定向状态码，"你的包裹被转送到其他地址了"
- 4xx：客户端错误，"你填错地址了，包裹送不了"
- 5xx：服务器错误，"快递公司内部出问题了，没法送"

HTTP/2和HTTP/3相比HTTP/1.1的改进就像从单车道升级到高速公路，多路复用让多个请求可以并行处理，显著提高了效率。

```
// HTTP请求和响应的伪代码示例
// 1. 创建一个HTTP请求
let request = {
    method: "GET",
    url: "/api/users",
    headers: {
        "User-Agent": "MyApp/1.0",
        "Accept": "application/json",
        "Cookie": "session=abc123"
    },
    body: null  // GET请求通常没有body
};

// 2. 发送请求并获取响应
let response = sendHTTPRequest(request);

// 3. 处理响应
if (response.statusCode >= 200 && response.statusCode < 300) {
    // 成功处理
    let data = JSON.parse(response.body);
    processData(data);
} else if (response.statusCode >= 300 && response.statusCode < 400) {
    // 处理重定向
    let newLocation = response.headers["Location"];
    redirectTo(newLocation);
} else {
    // 处理错误
    handleError(response.statusCode, response.body);
}
```

### 4. 网络安全
- 加密：就像密信，确保数据只有收件人能读懂
- 防火墙：就像安检，过滤不安全的数据包
- HTTPS：安全的HTTP，使用SSL/TLS加密
- 攻击防范：XSS、CSRF、SQL注入等常见攻击的防护

对称加密就像一把钥匙开一把锁，速度快但钥匙传递有风险；非对称加密就像信箱，任何人都能投信（公钥加密），但只有箱子主人能用钥匙取信（私钥解密）。

HTTPS就是在HTTP外面加了一层SSL/TLS的保护壳，就像给信件套上了防窥信封，即使被截获也无法直接读取内容。

```
// HTTPS建立安全连接的简化流程
// 1. 客户端发起请求
client.connect(server);

// 2. 服务器返回证书
let certificate = server.getCertificate();

// 3. 客户端验证证书
if (!certificateAuthority.verify(certificate)) {
    throw new Error("证书不可信!");
}

// 4. 客户端生成对称密钥，并用服务器公钥加密
let symmetricKey = generateRandomKey();
let encryptedKey = certificate.publicKey.encrypt(symmetricKey);
client.send(encryptedKey);

// 5. 服务器用私钥解密得到对称密钥
let decryptedKey = server.privateKey.decrypt(encryptedKey);

// 6. 双方使用对称密钥加密后续通信
client.encrypt = server.encrypt = function(message) {
    return encryptWithSymmetricKey(message, decryptedKey);
};

client.decrypt = server.decrypt = function(ciphertext) {
    return decryptWithSymmetricKey(ciphertext, decryptedKey);
};

// 7. 安全通信建立完成
let secureMessage = client.encrypt("Hello, secure world!");
client.send(secureMessage);
```

## 常见问题

### 1. 网络延迟
- 传输距离：光速虽快，跨洲际传输仍需时间
- 网络拥堵：就像高峰期的道路堵车
- 服务器处理时间：服务器需要时间处理请求
- 解决方案：CDN加速、负载均衡、服务器优化

从北京到纽约的网络请求，即使光速传输也需要至少70毫秒，这是物理限制。再加上路由器转发、队列排队、服务器处理，一个请求的往返时间(RTT)可能达到200-400毫秒。

```
// 测量网络延迟的伪代码
function pingTest(host, count = 4) {
    let results = [];
    
    for (let i = 0; i < count; i++) {
        let startTime = getCurrentTime();
        
        try {
            // 发送ICMP Echo请求
            sendICMPEchoRequest(host);
            
            // 等待ICMP Echo响应
            receiveICMPEchoReply(host, timeout = 2000);
            
            let endTime = getCurrentTime();
            let rtt = endTime - startTime;
            results.push(rtt);
            
            console.log(`Reply from ${host}: time=${rtt}ms`);
        } catch (error) {
            console.log(`Request timed out.`);
        }
        
        // 等待一段时间再发送下一个请求
        sleep(1000);
    }
    
    // 计算平均RTT
    let avgRTT = results.length > 0 ? 
                 results.reduce((sum, rtt) => sum + rtt, 0) / results.length : 
                 null;
    
    return {
        host: host,
        sent: count,
        received: results.length,
        lost: count - results.length,
        minRTT: Math.min(...results, Infinity),
        maxRTT: Math.max(...results, -Infinity),
        avgRTT: avgRTT
    };
}
```

### 2. 带宽限制
- 就像马路的宽度，决定了同时通过的车辆数量
- 影响数据传输速度
- 上行和下行速率通常不对称
- 带宽瓶颈可能在任何环节：本地网络、ISP、服务器、骨干网

家用宽带一般下行快上行慢，就像只有一条车道的出口和五条车道的入口。这就是为什么下载快而上传慢。数据中心则通常有对称的带宽，上传下载一样快。

```
// 带宽测试的伪代码
function bandwidthTest() {
    // 下载测试
    let startTime = getCurrentTime();
    let downloadedBytes = downloadTestFile(url = "https://speedtest.net/testfile", size = "100MB");
    let endTime = getCurrentTime();
    
    let downloadTime = (endTime - startTime) / 1000;  // 秒
    let downloadSpeed = (downloadedBytes * 8) / downloadTime / 1000000;  // Mbps
    
    // 上传测试
    startTime = getCurrentTime();
    let uploadedBytes = uploadTestFile(url = "https://speedtest.net/upload", size = "100MB");
    endTime = getCurrentTime();
    
    let uploadTime = (endTime - startTime) / 1000;  // 秒
    let uploadSpeed = (uploadedBytes * 8) / uploadTime / 1000000;  // Mbps
    
    return {
        download: {
            speed: downloadSpeed,
            unit: "Mbps"
        },
        upload: {
            speed: uploadSpeed,
            unit: "Mbps"
        }
    };
}
```

### 3. 网络攻击
- DDoS：分布式拒绝服务攻击，像无数人同时打电话导致线路瘫痪
- 中间人攻击：像邮递员偷看或修改你的信件
- XSS：跨站脚本攻击，像在明信片上写了会自动复制的病毒字
- SQL注入：像在表格中填写能修改档案的特殊文字
- 钓鱼攻击：伪装成可信来源诱骗用户

防御措施包括使用HTTPS、加强认证、输入验证、定期更新软件、设置防火墙和IDS/IPS系统等。

```
// SQL注入攻击与防御示例
// 易受攻击的代码
function unsafeLogin(username, password) {
    let query = `SELECT * FROM users WHERE username='${username}' AND password='${password}'`;
    return database.execute(query);
}

// 攻击示例：输入 username = admin' --
// 生成的SQL: SELECT * FROM users WHERE username='admin' --' AND password='whatever'
// -- 是SQL注释，后面的条件被忽略，所以无需密码就能登录

// 安全的代码（使用参数化查询）
function safeLogin(username, password) {
    let query = `SELECT * FROM users WHERE username=? AND password=?`;
    return database.execute(query, [username, password]);
}
```

## 实践建议

1. 学会使用抓包工具（Wireshark、Fiddler、Charles）
   - 观察真实的网络流量，理解协议细节
   - 排查网络问题，找出性能瓶颈
   - 学会分析HTTP请求和响应

2. 理解常见协议（HTTP、WebSocket、MQTT）
   - HTTP是Web的基础，必须掌握
   - WebSocket适合实时通信，如聊天、游戏
   - MQTT适合物联网场景，低带宽高效率

3. 掌握基本的网络调试
   - ping测试连通性
   - traceroute/tracert查看路由路径
   - nslookup/dig查询DNS
   - curl/wget测试HTTP请求

4. 了解网络安全基础
   - HTTPS和TLS/SSL加密
   - 常见攻击及防御
   - 安全头部和CORS设置

5. 学习常见网络架构
   - CDN内容分发网络
   - 负载均衡
   - 微服务架构中的网络通信

6. 实验网络编程
   - 实现一个简单的HTTP服务器
   - 编写Socket通信程序
   - 尝试WebRTC点对点通信

## 应用场景

1. Web开发
   - 理解HTTP请求和响应流程
   - 优化网络性能，减少延迟
   - 处理RESTful API和WebSocket

2. API设计
   - 合理设计URL和资源路径
   - 选择适当的HTTP方法
   - 处理认证和授权
   - 设计错误处理机制

3. 网络安全
   - 防御XSS和CSRF攻击
   - 实现安全的用户认证
   - 数据传输加密

4. 分布式系统
   - 服务间通信协议设计
   - 处理网络故障和超时
   - 实现服务发现和负载均衡

5. 云计算
   - 理解虚拟网络和容器网络
   - 配置和优化云服务网络
   - 设计高可用性网络架构

6. 移动应用开发
   - 处理不稳定的移动网络
   - 实现高效的数据同步
   - 减少电量消耗

记住：在互联网时代，理解网络原理对于程序员来说就像鱼需要理解水一样重要。网络知识是连接各种技术的桥梁，掌握它会让你在技术森林中游刃有余，就像拥有了一张详细的地图。