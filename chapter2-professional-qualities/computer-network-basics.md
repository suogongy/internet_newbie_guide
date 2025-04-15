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

**注意**: 这是传统的IP地址分类方法。现代网络广泛使用无类别域间路由（CIDR），允许更灵活地分配IP地址和定义网络大小，例如 `192.168.1.0/24` 表示前24位是网络部分。

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
    let currentNameServer = getRootNameServers(); // 从根服务器开始
    
    // 迭代查询过程：不断向下级权威服务器查询
    while (currentNameServer && !result) {
        let response = queryNameServer(currentNameServer, domain);
        
        if (response.hasAnswer()) { // 权威服务器直接返回了IP地址
            result = response.getIP();
        } else if (response.hasReferral()) { // 权威服务器返回了下一级应查询的服务器地址
            currentNameServer = response.getReferral(); 
        } else { // 查询失败或无记录
            currentNameServer = null; 
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

// 4. 客户端生成一个随机的对称密钥（或其种子，称为预主密钥 pre-master secret），并用服务器证书中的公钥加密
let preMasterSecret = generateRandomSecret();
let encryptedSecret = certificate.publicKey.encrypt(preMasterSecret);
client.send(encryptedSecret);

// 5. 服务器用自己的私钥解密得到预主密钥
let decryptedSecret = server.privateKey.decrypt(encryptedSecret);

// 6. 双方根据协商好的算法，使用预主密钥和之前交换的随机数生成相同的会话密钥（对称密钥）
let sessionKey = generateSessionKey(clientRandom, serverRandom, decryptedSecret);

// 7. 后续通信使用这个会话密钥进行对称加密
client.encrypt = server.encrypt = function(message) {
    return encryptWithSymmetricKey(message, sessionKey);
};

client.decrypt = server.decrypt = function(ciphertext) {
    return decryptWithSymmetricKey(ciphertext, sessionKey);
};

// 8. 安全通信建立完成
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

## 常见面试题

**1. 简述TCP/IP（或OSI）模型各层及其主要功能。**

*   **TCP/IP四层模型：**
    *   **应用层：** 提供用户接口，处理特定应用程序的协议（如HTTP、FTP、DNS）。
    *   **传输层：** 提供端到端的数据传输服务，管理连接（TCP）或无连接（UDP）通信，负责数据分段、流量控制、错误控制。
    *   **网络层（互联网层）：** 处理数据包的路由和转发，定义IP地址，在不同网络间寻址（IP协议）。
    *   **网络接口层（链路层）：** 处理物理网络接口的细节，如MAC地址寻址、帧的封装、物理传输（以太网、Wi-Fi）。
*   **OSI七层模型：** 应用层、表示层、会话层、传输层、网络层、数据链路层、物理层。（面试时能说出TCP/IP四层并映射到OSI即可）

**2. TCP三次握手和四次挥手的过程？为什么握手是三次，挥手是四次？**

*   **三次握手（建立连接）：**
    1.  客户端发送SYN包（同步序列编号）到服务器，请求建立连接。
    2.  服务器收到SYN包，回复SYN+ACK包（确认号ack=客户端seq+1，同时自己也发送SYN）。
    3.  客户端收到服务器的SYN+ACK包，发送ACK包（确认号ack=服务器seq+1），连接建立。
*   **为什么三次：** 为了防止已失效的连接请求报文突然又传到服务器，引起错误。三次握手能确保双方都具有发送和接收数据的能力。
*   **四次挥手（断开连接）：**
    1.  主动方（如客户端）发送FIN包（完成），表示数据发送完毕。
    2.  被动方（服务器）收到FIN，回复ACK，表示知道了。此时被动方可能还有数据要发送，连接处于半关闭状态。
    3.  被动方数据发送完毕后，发送FIN包。
    4.  主动方收到FIN，回复ACK，等待一段时间（2MSL）后关闭连接。被动方收到ACK后立即关闭。
*   **为什么四次：** 因为TCP是全双工的，服务器收到客户端的FIN只表示客户端不再发送数据，但服务器可能还有数据要发。服务器需要先ACK确认收到，等自己数据发完后再发送FIN。

**3. TCP和UDP的区别？分别适用于哪些场景？**

*   **区别：**
    *   **连接性：** TCP是面向连接的；UDP是无连接的。
    *   **可靠性：** TCP提供可靠传输（确认、重传、排序）；UDP尽最大努力交付，不保证可靠。
    *   **效率：** UDP开销小，速度快；TCP开销大，速度相对慢。
    *   **流量控制/拥塞控制：** TCP有；UDP没有。
    *   **头部大小：** TCP头部（至少20字节）比UDP头部（8字节）大。
*   **场景：**
    *   **TCP：** 需要可靠传输的应用，如文件传输（FTP）、邮件（SMTP）、网页浏览（HTTP/HTTPS）。
    *   **UDP：** 对实时性要求高、允许少量丢包的应用，如视频/音频流（直播、VoIP）、DNS查询、游戏。

**4. 解释一下DNS解析过程。**

*   用户在浏览器输入域名 `www.example.com`。
*   **1. 浏览器缓存：** 浏览器检查自身缓存。
*   **2. 操作系统缓存：** 检查本地`hosts`文件和操作系统DNS缓存。
*   **3. 本地DNS服务器（LDNS）：** 向配置的本地DNS服务器（通常由ISP提供）发送递归查询请求。
*   **4. LDNS查询过程（迭代）：**
    *   LDNS检查自身缓存。
    *   若无缓存，LDNS向根DNS服务器查询。
    *   根服务器返回顶级域（.com）DNS服务器地址。
    *   LDNS向.com DNS服务器查询。
    *   .com服务器返回`example.com`的权威DNS服务器地址。
    *   LDNS向`example.com`的权威DNS服务器查询`www.example.com`的IP地址。
    *   权威DNS服务器返回IP地址。
*   **5. LDNS返回结果：** LDNS将IP地址返回给操作系统，并缓存结果。
*   **6. 浏览器获取IP：** 操作系统将IP地址返回给浏览器，浏览器发起HTTP请求。

**5. 从输入URL到页面加载完成，发生了什么？**

这是一个宏观问题，考察综合知识，可以简化回答关键步骤：
1.  **DNS解析：** 浏览器通过DNS查询将URL中的域名解析为IP地址。
2.  **TCP连接：** 浏览器与服务器通过TCP三次握手建立连接。
3.  **HTTP请求：** 浏览器向服务器发送HTTP请求报文（GET/POST等）。
4.  **服务器处理：** 服务器处理请求，可能涉及后端逻辑、数据库查询等。
5.  **HTTP响应：** 服务器将HTTP响应报文（包含状态码、响应头、HTML内容等）发送给浏览器。
6.  **浏览器渲染：**
    *   浏览器解析HTML，构建DOM树。
    *   解析CSS，构建CSSOM树。
    *   结合DOM和CSSOM，构建渲染树（Render Tree）。
    *   布局（Layout/Reflow）：计算每个节点的位置和大小。
    *   绘制（Paint）：将节点绘制到屏幕上。
    *   遇到JS会阻塞解析，执行JS脚本。JS可能会修改DOM/CSSOM，导致重排或重绘。
    *   加载图片、脚本、样式表等外部资源，重复上述过程。
7.  **TCP断开：** 请求完成后，可能通过TCP四次挥手断开连接（HTTP/1.1 Keep-Alive或HTTP/2多路复用会保持连接）。

**6. HTTP常见的状态码有哪些？分别代表什么意思？**

*   **2xx (成功):**
    *   `200 OK`: 请求成功。
*   **3xx (重定向):**
    *   `301 Moved Permanently`: 永久重定向，资源已永久移动到新URL。
    *   `302 Found`: 临时重定向。
    *   `304 Not Modified`: 资源未修改，可使用缓存版本。
*   **4xx (客户端错误):**
    *   `400 Bad Request`: 请求语法错误。
    *   `401 Unauthorized`: 未授权，需要身份验证。
    *   `403 Forbidden`: 服务器拒绝执行请求。
    *   `404 Not Found`: 请求的资源不存在。
*   **5xx (服务器错误):**
    *   `500 Internal Server Error`: 服务器内部错误。
    *   `502 Bad Gateway`: 网关或代理服务器从上游服务器收到无效响应。
    *   `503 Service Unavailable`: 服务器暂时无法处理请求（过载或维护）。

**7. HTTPS是如何保证安全的？简述SSL/TLS握手过程。**

*   **保证安全机制：**
    *   **数据加密：** 使用对称加密算法加密传输内容，防止窃听。
    *   **身份认证：** 使用基于证书的非对称加密算法验证服务器身份，防止中间人攻击。
    *   **数据完整性：** 使用消息认证码（MAC）确保数据在传输过程中未被篡改。
*   **简述SSL/TLS握手过程（简化版）：**
    1.  **客户端Hello：** 客户端发送支持的加密套件、TLS版本、随机数 `ClientRandom`。
    2.  **服务器Hello：** 服务器选择一个加密套件、TLS版本，发送随机数 `ServerRandom` 和服务器的数字证书。
    3.  **客户端验证与密钥交换：**
        *   客户端验证服务器证书的有效性（信任链、有效期、域名匹配等）。
        *   生成一个预主密钥 `PreMasterSecret`。
        *   用服务器证书中的公钥加密 `PreMasterSecret`，发送给服务器。
        *   （可选）客户端发送证书（如果服务器要求客户端认证）。
        *   客户端使用 `ClientRandom`, `ServerRandom`, `PreMasterSecret` 生成会话密钥（对称密钥）。
        *   发送 `ChangeCipherSpec` 消息，表示后续将使用加密通信。
        *   发送 `Finished` 消息（用会话密钥加密的握手摘要）。
    4.  **服务器密钥交换与完成：**
        *   服务器用私钥解密得到 `PreMasterSecret`。
        *   服务器使用 `ClientRandom`, `ServerRandom`, `PreMasterSecret` 生成与客户端相同的会话密钥。
        *   发送 `ChangeCipherSpec` 消息。
        *   发送 `Finished` 消息（用会话密钥加密的握手摘要）。
    5.  **安全通信：** 握手完成，双方使用协商好的会话密钥进行加密通信。

**8. IP地址和MAC地址的区别？**

*   **IP地址（网络层）：** 逻辑地址，用于在互联网中唯一标识一台主机或网络接口，并进行路由。它会随着设备所连接网络的变化而变化。类似收件地址。
*   **MAC地址（数据链路层）：** 物理地址，烧录在网卡（NIC）上的全球唯一标识符，用于在局域网（LAN）内部标识设备。通常是固定的。类似身份证号。
*   数据包在互联网传输时，目标IP地址不变，但每经过一个路由器，目标MAC地址会变为下一跳路由器的MAC地址。

**9. 什么是CDN？它的作用是什么？**

*   **CDN (Content Delivery Network)：** 内容分发网络。
*   **作用：** 通过在全球各地部署边缘服务器，将源站的内容（如网页、图片、视频）缓存到离用户最近的服务器上。用户请求时，会从最近的边缘服务器获取内容，从而：
    *   **加速访问：** 减少传输延迟，提高加载速度。
    *   **减轻源站压力：** 大部分请求由边缘服务器处理。
    *   **提高可用性：** 分散流量，单个节点故障不影响全局。

**10. 什么是XSS攻击？如何防御？**

*   **XSS (Cross-Site Scripting)：** 跨站脚本攻击。攻击者将恶意脚本注入到网页中，当其他用户访问该网页时，恶意脚本会在用户的浏览器中执行，从而窃取用户信息（如Cookie）、劫持会话、执行恶意操作等。
*   **防御：**
    *   **输入验证：** 对用户输入进行严格过滤和验证。
    *   **输出编码/转义：** 在将用户输入的内容输出到HTML页面时，对特殊字符（如 `<`, `>`, `"`, `'`, `&`）进行HTML实体编码。
    *   **设置HttpOnly Cookie：** 防止脚本通过 `document.cookie` 读取敏感Cookie。
    *   **内容安全策略 (CSP)：** 定义浏览器可以加载哪些来源的资源，限制脚本执行。

**11. 什么是SQL注入？如何防御？**

*   **SQL注入：** 攻击者在用户输入（如表单字段、URL参数）中插入恶意的SQL代码片段，如果应用程序直接将这些输入拼接到SQL查询语句中执行，就可能导致数据库信息泄露、数据被篡改、甚至服务器被控制。
*   **防御：**
    *   **参数化查询（预编译语句）：** 最有效的防御方法。将用户输入作为参数传递给SQL执行，而不是直接拼接到查询语句中，数据库驱动会处理特殊字符，使其不被解释为SQL代码。
    *   **输入验证和过滤：** 对用户输入进行类型、格式、长度检查，过滤危险字符。
    *   **最小权限原则：** 数据库连接账户只授予必需的最小权限。
    *   **ORM框架：** 很多ORM框架内置了对SQL注入的防护。
   
> 记住：在互联网时代，理解网络原理对于程序员来说就像鱼需要理解水一样重要。网络知识是连接各种技术的桥梁，掌握它会让你在技术森林中游刃有余，就像拥有了一张详细的地图。