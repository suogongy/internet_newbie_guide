# 数据结构与算法基础

[返回章节目录](./index.md) | [返回首页](../README.md)

## 为什么要学习数据结构和算法？

想象你是一个图书管理员：
- 如果书随便乱放，找一本书可能要翻箱倒柜
- 如果按照分类整齐摆放，很快就能找到想要的书

数据结构和算法就是帮助我们高效组织和处理数据的方法。它们就像是厨师的刀工和烹饪技巧，看似简单，但差别可能就是路边摊和米其林三星的区别。

在编程领域，数据结构和算法的重要性就像是武侠小说中的内功心法。可能短期内看不出效果，但当你需要处理百万级数据时，一个O(n²)和O(n log n)的算法，可能就是系统崩溃和流畅运行的区别。

## 常见的数据结构

### 1. 数组
- 就像一排整齐的储物柜，每个格子都有明确的编号
- 适合存储固定大小的同类数据
- 优点：访问快速（O(1)时间复杂度）
- 缺点：插入删除需要移动元素，大小固定不灵活

Java中的数组示例：
```java
// 创建并初始化一个整型数组
int[] numbers = new int[5];
numbers[0] = 10;
numbers[1] = 20;

// 数组的遍历
for (int i = 0; i < numbers.length; i++) {
    System.out.println("第" + i + "个元素是：" + numbers[i]);
}

// 使用增强for循环
for (int num : numbers) {
    System.out.println(num);
}
```

数组就像是一把双刃剑，查找元素快得惊人，但要在中间插入新元素，就像在排队的人群中硬塞一个人，后面所有人都得往后挪一步，累死个人。

### 2. 链表
- 像一条珠子串成的项链，每个珠子都知道下一个珠子在哪
- 适合频繁插入删除的场景
- 优点：插入删除方便（只需调整指针）
- 缺点：随机访问较慢（需要从头开始查找）

链表有单向链表、双向链表和循环链表。就像认识朋友，有的人只记得下家，有的人上下家都记得，还有的团队首尾相连形成闭环。

Java实现简单链表：
```java
class Node {
    int data;
    Node next;
    
    public Node(int data) {
        this.data = data;
        this.next = null;
    }
}

class LinkedList {
    Node head;
    
    // 在链表末尾添加新节点
    public void append(int data) {
        Node newNode = new Node(data);
        
        // 如果链表为空，将新节点设为头节点
        if (head == null) {
            head = newNode;
            return;
        }
        
        // 否则，遍历到最后一个节点
        Node last = head;
        while (last.next != null) {
            last = last.next;
        }
        
        // 将新节点添加到末尾
        last.next = newNode;
    }
    
    // 打印链表
    public void printList() {
        Node current = head;
        while (current != null) {
            System.out.print(current.data + " -> ");
            current = current.next;
        }
        System.out.println("null");
    }
}
```

链表的精髓在于灵活性。就像北京的胡同，看似杂乱无章，但想拆一个小平房建新的，完全不影响隔壁老王家的结构。

### 3. 栈
- 像一摞盘子，只能从顶部拿取和放置
- 后进先出(LIFO)的特点
- 应用：函数调用栈、表达式求值、浏览器的前进/后退功能

栈的操作简单明了：压栈(push)和弹栈(pop)。就像吃薯片，总是吃最上面的一片，除非你是那种从底下抽的奇葩（不，那不是栈）。

Java实现栈：
```java
import java.util.EmptyStackException;

class Stack {
    private int maxSize;
    private int[] stackArray;
    private int top;
    
    public Stack(int size) {
        maxSize = size;
        stackArray = new int[maxSize];
        top = -1; // 初始化栈顶指针
    }
    
    // 入栈
    public void push(int value) {
        if (top == maxSize - 1) {
            System.out.println("栈已满!");
            return;
        }
        stackArray[++top] = value;
    }
    
    // 出栈
    public int pop() {
        if (top == -1) {
            throw new EmptyStackException();
        }
        return stackArray[top--];
    }
    
    // 查看栈顶元素
    public int peek() {
        if (top == -1) {
            throw new EmptyStackException();
        }
        return stackArray[top];
    }
    
    // 判断栈是否为空
    public boolean isEmpty() {
        return (top == -1);
    }
}
```

### 4. 队列
- 像排队买票，先来先服务
- 先进先出(FIFO)的特点
- 应用：任务调度、消息队列、打印任务

队列是日常生活中最公平的数据结构，不管你是谁，都得乖乖排队。除了普通队列，还有双端队列（两头都能进出）和优先队列（VIP插队）。

Java实现队列：
```java
class Queue {
    private int maxSize;
    private int[] queueArray;
    private int front; // 队头
    private int rear;  // 队尾
    private int nItems; // 当前队列中的元素数量
    
    public Queue(int size) {
        maxSize = size;
        queueArray = new int[maxSize];
        front = 0;
        rear = -1;
        nItems = 0;
    }
    
    // 入队
    public void enqueue(int value) {
        if (nItems == maxSize) {
            System.out.println("队列已满!");
            return;
        }
        
        // 循环队列的实现，当rear到达数组末尾时回到开头
        if (rear == maxSize - 1) {
            rear = -1;
        }
        
        queueArray[++rear] = value;
        nItems++;
    }
    
    // 出队
    public int dequeue() {
        if (nItems == 0) {
            throw new RuntimeException("队列为空!");
        }
        
        int temp = queueArray[front++];
        
        // 循环队列逻辑
        if (front == maxSize) {
            front = 0;
        }
        
        nItems--;
        return temp;
    }
    
    // 查看队首元素
    public int peekFront() {
        if (nItems == 0) {
            throw new RuntimeException("队列为空!");
        }
        return queueArray[front];
    }
    
    // 判断队列是否为空
    public boolean isEmpty() {
        return (nItems == 0);
    }
}
```

### 5. 树
- 像家族谱或公司的组织架构，有层次关系
- 每个节点可以有多个子节点，但只有一个父节点（根节点除外）
- 应用：文件系统、数据库索引、表示层次结构

树的种类繁多，二叉树、二叉搜索树、平衡树（AVL树）、红黑树、B树、B+树等等，就像植物界的多样性一样令人惊叹。

二叉搜索树的Java实现：
```java
class TreeNode {
    int data;
    TreeNode left;
    TreeNode right;
    
    public TreeNode(int data) {
        this.data = data;
        left = null;
        right = null;
    }
}

class BinarySearchTree {
    TreeNode root;
    
    public BinarySearchTree() {
        root = null;
    }
    
    // 插入节点
    public void insert(int data) {
        root = insertRecursive(root, data);
    }
    
    private TreeNode insertRecursive(TreeNode root, int data) {
        // 如果树为空，创建新节点
        if (root == null) {
            root = new TreeNode(data);
            return root;
        }
        
        // 否则，沿树递归向下
        if (data < root.data) {
            root.left = insertRecursive(root.left, data);
        } else if (data > root.data) {
            root.right = insertRecursive(root.right, data);
        }
        
        return root;
    }
    
    // 中序遍历（获得排序后的结果）
    public void inorder() {
        inorderRecursive(root);
    }
    
    private void inorderRecursive(TreeNode root) {
        if (root != null) {
            inorderRecursive(root.left);
            System.out.print(root.data + " ");
            inorderRecursive(root.right);
        }
    }
    
    // 查找节点
    public boolean search(int data) {
        return searchRecursive(root, data);
    }
    
    private boolean searchRecursive(TreeNode root, int data) {
        // 基本情况：树为空或找到数据
        if (root == null) {
            return false;
        }
        if (root.data == data) {
            return true;
        }
        
        // 根据值的大小决定向左还是向右查找
        if (data < root.data) {
            return searchRecursive(root.left, data);
        }
        return searchRecursive(root.right, data);
    }
}
```

二叉搜索树是程序员的好朋友，它将数据有序组织，让查找变得高效。不过它也怕"偏食"，如果数据已经有序，它就会变成一条线，退化成链表。这时候就需要平衡树来拯救世界了。

### 6. 图
- 像城市地铁网络或社交网络关系
- 由节点（顶点）和边组成
- 可以是有向的或无向的
- 应用：社交网络分析、路径规划、网络流量分析

图是最复杂也是最强大的数据结构，它可以表示任何关系。从你的朋友圈到全球航线网络，都可以用图来表示。

Java实现邻接表表示的图：
```java
import java.util.*;

class Graph {
    private int vertices;  // 顶点数
    private LinkedList<Integer>[] adjacencyList;  // 邻接表
    
    @SuppressWarnings("unchecked")
    public Graph(int vertices) {
        this.vertices = vertices;
        adjacencyList = new LinkedList[vertices];
        
        // 初始化邻接表
        for (int i = 0; i < vertices; i++) {
            adjacencyList[i] = new LinkedList<>();
        }
    }
    
    // 添加边
    public void addEdge(int source, int destination) {
        // 添加一条从source到destination的边
        adjacencyList[source].add(destination);
        
        // 如果是无向图，还需要添加一条从destination到source的边
        // adjacencyList[destination].add(source);
    }
    
    // 广度优先搜索
    public void bfs(int startVertex) {
        // 标记已访问的顶点
        boolean[] visited = new boolean[vertices];
        
        // 创建队列
        LinkedList<Integer> queue = new LinkedList<>();
        
        // 标记当前节点为已访问并入队
        visited[startVertex] = true;
        System.out.print("广度优先遍历（从顶点" + startVertex + "开始）: ");
        System.out.print(startVertex + " ");
        queue.add(startVertex);
        
        while (!queue.isEmpty()) {
            // 出队一个顶点并打印
            int currentVertex = queue.poll();
            
            // 获取该顶点的所有邻接点
            Iterator<Integer> iterator = adjacencyList[currentVertex].listIterator();
            while (iterator.hasNext()) {
                int neighbor = iterator.next();
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    System.out.print(neighbor + " ");
                    queue.add(neighbor);
                }
            }
        }
        System.out.println();
    }
    
    // 深度优先搜索
    public void dfs(int startVertex) {
        // 标记已访问的顶点
        boolean[] visited = new boolean[vertices];
        System.out.print("深度优先遍历（从顶点" + startVertex + "开始）: ");
        
        // 调用递归辅助方法
        dfsUtil(startVertex, visited);
        System.out.println();
    }
    
    private void dfsUtil(int vertex, boolean[] visited) {
        // 标记当前节点为已访问并打印
        visited[vertex] = true;
        System.out.print(vertex + " ");
        
        // 递归访问所有未访问的邻接点
        Iterator<Integer> iterator = adjacencyList[vertex].listIterator();
        while (iterator.hasNext()) {
            int neighbor = iterator.next();
            if (!visited[neighbor]) {
                dfsUtil(neighbor, visited);
            }
        }
    }
}
```

图算法的复杂度和优雅程度让人叹为观止。想象一下，通过图算法，微信可以告诉你和陌生人之间的"六度人脉"，谷歌地图可以在茫茫城市中找到最短路径。这就是图算法的魔力。

## 基础算法

### 1. 排序算法
- 冒泡排序：像气泡往上冒，简单但效率低下（O(n²)）
- 快速排序：分而治之的典范，平均效率高（O(n log n)）
- 归并排序：先分后合，稳定且效率高，但空间消耗大

冒泡排序就像是新手游泳，看起来笨拙但容易理解；而快速排序则像职业游泳选手，优雅且高效。

Java实现几种排序算法：
```java
class SortingAlgorithms {
    // 冒泡排序
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    // 交换 arr[j] 和 arr[j+1]
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
    
    // 快速排序
    public static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            // 获取分区点
            int pi = partition(arr, low, high);
            
            // 递归对分区点左右两部分进行排序
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }
    
    private static int partition(int[] arr, int low, int high) {
        // 选择最右边的元素作为基准
        int pivot = arr[high];
        int i = low - 1; // 小于基准元素的区域指针
        
        for (int j = low; j < high; j++) {
            // 如果当前元素小于基准
            if (arr[j] < pivot) {
                i++;
                
                // 交换 arr[i] 和 arr[j]
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        
        // 将基准元素放到正确位置
        int temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        
        return i + 1;
    }
    
    // 归并排序
    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            // 找到中间点
            int mid = left + (right - left) / 2;
            
            // 对左右两部分分别进行排序
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            
            // 合并已排序的部分
            merge(arr, left, mid, right);
        }
    }
    
    private static void merge(int[] arr, int left, int mid, int right) {
        // 计算左右两部分的大小
        int n1 = mid - left + 1;
        int n2 = right - mid;
        
        // 创建临时数组
        int[] L = new int[n1];
        int[] R = new int[n2];
        
        // 复制数据到临时数组
        for (int i = 0; i < n1; i++) {
            L[i] = arr[left + i];
        }
        for (int j = 0; j < n2; j++) {
            R[j] = arr[mid + 1 + j];
        }
        
        // 合并临时数组
        int i = 0, j = 0;
        int k = left;
        
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                arr[k] = L[i];
                i++;
            } else {
                arr[k] = R[j];
                j++;
            }
            k++;
        }
        
        // 复制L中剩余元素
        while (i < n1) {
            arr[k] = L[i];
            i++;
            k++;
        }
        
        // 复制R中剩余元素
        while (j < n2) {
            arr[k] = R[j];
            j++;
            k++;
        }
    }
}
```

选择合适的排序算法就像选择交通工具，冒泡排序是步行，插入排序是自行车，快速排序是高铁。数据量小时差别不大，数据量大了就天壤之别。

### 2. 查找算法
- 二分查找：像猜数字游戏，每次排除一半可能（O(log n)）
- 深度优先搜索：像走迷宫，一条路走到底再回溯
- 广度优先搜索：像水波扩散，先探索近的再探索远的

Java实现二分查找：
```java
class SearchAlgorithms {
    // 二分查找（要求数组已排序）
    public static int binarySearch(int[] arr, int target) {
        int left = 0;
        int right = arr.length - 1;
        
        while (left <= right) {
            int mid = left + (right - left) / 2;
            
            // 检查中间元素
            if (arr[mid] == target) {
                return mid;  // 找到目标，返回索引
            }
            
            // 如果目标在左半部分
            if (arr[mid] > target) {
                right = mid - 1;
            }
            // 如果目标在右半部分
            else {
                left = mid + 1;
            }
        }
        
        return -1;  // 未找到目标
    }
    
    // 二分查找的递归实现
    public static int binarySearchRecursive(int[] arr, int target, int left, int right) {
        if (left > right) {
            return -1;  // 基本情况：未找到目标
        }
        
        int mid = left + (right - left) / 2;
        
        // 检查中间元素
        if (arr[mid] == target) {
            return mid;  // 找到目标，返回索引
        }
        
        // 如果目标在左半部分
        if (arr[mid] > target) {
            return binarySearchRecursive(arr, target, left, mid - 1);
        }
        
        // 如果目标在右半部分
        return binarySearchRecursive(arr, target, mid + 1, right);
    }
}
```

二分查找的强大之处在于，即使在十亿级的数据中，也只需要约30次比较就能找到目标。这就是为什么在有序数据中，不用二分查找简直是暴殄天物。

## 算法效率

### 1. 时间复杂度
- O(1)：最快，常数时间，无论数据量大小，时间恒定（如数组访问）
- O(log n)：很快，对数时间，数据量翻倍，时间只增加一点点（如二分查找）
- O(n)：随数据量线性增长，数据量翻倍，时间也翻倍（如简单遍历）
- O(n log n)：比线性稍慢，但还算高效（如快速排序、归并排序）
- O(n²)：数据量大时要小心，数据量翻倍，时间增加四倍（如冒泡排序）
- O(2^n)：指数级增长，除非数据量极小，否则几乎无法接受（如递归解斐波那契）

时间复杂度的意义在于帮我们预估算法在大数据量下的表现。就像买车不能只看车头长得好不好看，还得看油耗性能一样。

### 2. 空间复杂度
- 算法占用的额外空间
- 时间和空间通常要权衡
- O(1)：常数空间（如原地排序算法）
- O(n)：线性空间（如需要额外数组的算法）
- O(n²)：平方空间（如某些动态规划算法）

空间复杂度就像是算法的"内存消耗指标"。有些算法可以"节衣缩食"，空间复杂度低；有些则"大手大脚"，吃内存不眨眼。在内存受限的环境下，空间复杂度甚至比时间复杂度更关键。

## 实际应用

1. 社交应用的好友推荐：利用图算法计算用户之间的关系距离
2. 电商网站的商品搜索：倒排索引和各种搜索算法共同作用
3. 地图软件的路径规划：Dijkstra算法或A*算法找最短路径
4. 游戏的人工智能：极小极大算法和Alpha-Beta剪枝算法
5. 推荐系统：协同过滤算法利用相似性分析推荐产品
6. 视频压缩：动态规划算法优化编码效率
7. 股票交易：各种时间序列算法和数据结构支持高频交易

想想看，当你用微信"看一看"，后台的算法正在分析你的阅读习惯和好友圈数据，以智能推荐文章；当你点外卖，路径规划算法正在计算最佳送餐路线。数据结构和算法，已经悄悄融入我们生活的方方面面。

## 学习建议

1. 从简单的数据结构开始，如数组、链表，打好基础
2. 多动手实现和练习，光看不练假把式
3. 结合实际问题思考，找到每种数据结构和算法的最佳应用场景
4. 注重算法效率分析，培养"算法思维"
5. 参与算法竞赛提高能力，如LeetCode、牛客网等平台
6. 阅读经典书籍，《算法导论》《数据结构与算法分析》等
7. 理解而非死记硬背，好的理解胜过死记硬背一万次

> 记住：好的程序员不仅要会用数据结构和算法，更要知道在什么场景下用什么结构和算法最合适。正如一位老程序员曾说："知道何时不使用某种算法，比知道何时使用它更重要。"

学习数据结构和算法就像练武功，一开始可能枯燥乏味，但当你有一天能够轻松应对复杂问题时，那种成就感是无与伦比的。不要急于求成，厚积薄发，终有一日你会感谢今天努力学习的自己。