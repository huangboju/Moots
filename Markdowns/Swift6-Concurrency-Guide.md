# Swift 6 并发模型完全指南

> 从 async/await 到 Actor，全面掌握 Swift 现代并发编程

---

## 目录

1. [async / await — 异步函数基础](#1-async--await--异步函数基础)
2. [Task — 结构化与非结构化任务](#2-task--结构化与非结构化任务)
3. [TaskGroup — 并行任务组](#3-taskgroup--并行任务组)
4. [AsyncSequence / AsyncStream — 异步序列](#4-asyncsequence--asyncstream--异步序列)
5. [Sendable — 跨并发域的类型安全](#5-sendable--跨并发域的类型安全)
6. [Actor — 状态隔离](#6-actor--状态隔离)
7. [MainActor — 主线程隔离](#7-mainactor--主线程隔离)
8. [GlobalActor — 自定义全局 Actor](#8-globalactor--自定义全局-actor)
9. [isolation / isolated / nonisolated — 隔离控制](#9-isolation--isolated--nonisolated--隔离控制)
10. [Continuation — 桥接回调与 async](#10-continuation--桥接回调与-async)
11. [数据竞争安全与 Swift 6 严格模式](#11-数据竞争安全与-swift-6-严格模式)
12. [实战迁移指南](#12-实战迁移指南)

---

## 1. async / await — 异步函数基础

### 1.1 原理

`async` 标记一个函数可以**挂起（suspend）**，将线程让出给其他任务，而不是阻塞线程等待结果。`await` 标记调用点为**潜在挂起点（suspension point）**，编译器在此处将函数拆分为"挂起前"和"恢复后"两段。

与 GCD 的根本区别：

- GCD：靠回调嵌套，线程由系统调度，容易回调地狱
- async/await：线性代码风格，编译器管理挂起/恢复，协作式线程池

```
┌──────────────┐          ┌──────────────┐
│  线程 1       │          │  线程 2       │
│              │          │              │
│ ─── taskA ───│─ await ──│→ taskA 挂起   │
│              │          │  线程 2 空闲   │
│ ─── taskB ───│          │  可执行其他任务 │
│              │          │              │
│              │← 恢复 ───│─ taskA 继续 ──│
└──────────────┘          └──────────────┘
```

### 1.2 基本语法

```swift
// 声明异步函数
func fetchUser(id: String) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

// 调用异步函数——必须在 async 上下文中使用 await
func loadProfile() async {
    do {
        let user = try await fetchUser(id: "123")
        print(user.name)
    } catch {
        print("Failed: \(error)")
    }
}
```

### 1.3 async 属性

```swift
struct RemoteConfig {
    // 只读计算属性可以是 async
    var featureFlags: [String: Bool] {
        get async throws {
            try await fetchFlags()
        }
    }
}

let config = RemoteConfig()
let flags = try await config.featureFlags
```

### 1.4 async let — 并发绑定

当多个异步操作彼此独立时，用 `async let` 让它们**并发执行**：

```swift
func loadDashboard() async throws -> Dashboard {
    // 三个请求同时发起，互不等待
    async let profile = fetchProfile()
    async let posts = fetchPosts()
    async let notifications = fetchNotifications()

    // 在需要结果时才 await
    return try await Dashboard(
        profile: profile,
        posts: posts,
        notifications: notifications
    )
}
```

**对比顺序执行：**

```swift
// ❌ 顺序执行：总耗时 = t1 + t2 + t3
let profile = try await fetchProfile()
let posts = try await fetchPosts()
let notifications = try await fetchNotifications()

// ✅ async let 并发：总耗时 ≈ max(t1, t2, t3)
async let profile = fetchProfile()
async let posts = fetchPosts()
async let notifications = fetchNotifications()
let result = try await (profile, posts, notifications)
```

### 1.5 注意事项

| 注意项 | 说明 |
|---|---|
| `await` 不等于切线程 | 只标记可能挂起，恢复后可能在不同线程 |
| async 函数只能在 async 上下文调用 | 需要 `Task { }` 或在另一个 async 函数中 |
| `await` 前后状态可能变化 | 挂起期间其他代码可能修改共享状态 |
| `try await` 顺序固定 | 先 `try` 后 `await`，不能颠倒 |
| 不要在 async 中使用信号量/锁 | 会阻塞线程池，可能死锁 |

---

## 2. Task — 结构化与非结构化任务

### 2.1 原理

`Task` 是 Swift 并发中的执行单元，代表一段异步工作。Task 分为两类：

- **结构化任务（Structured）**：生命周期绑定到父作用域，自动取消传播（`async let`、`TaskGroup`）
- **非结构化任务（Unstructured）**：手动创建，独立生命周期（`Task { }`、`Task.detached { }`）

### 2.2 Task { } — 非结构化任务

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建非结构化任务，继承当前 actor 上下文
        Task {
            // 如果 ViewController 是 @MainActor，这里仍在主线程
            let data = try await fetchData()
            updateUI(with: data)
        }
    }
}
```

### 2.3 Task.detached — 分离任务

```swift
// 不继承任何上下文，完全独立
Task.detached {
    // 不在 MainActor 上，在后台线程池
    let result = await heavyComputation()
    
    // 需要显式切回主线程
    await MainActor.run {
        self.label.text = result
    }
}
```

### 2.4 Task vs Task.detached

| 特性 | `Task { }` | `Task.detached { }` |
|---|---|---|
| 继承 actor 上下文 | ✅ 是 | ❌ 否 |
| 继承优先级 | ✅ 是 | ❌ 否（可手动指定） |
| 继承 task-local 值 | ✅ 是 | ❌ 否 |
| 适用场景 | 在当前上下文发起异步工作 | 需要脱离当前上下文（如后台计算） |

### 2.5 任务取消

```swift
class SearchController {
    private var searchTask: Task<Void, Never>?

    func search(query: String) {
        // 取消之前的搜索
        searchTask?.cancel()

        searchTask = Task {
            // 延迟 300ms（防抖）
            try? await Task.sleep(for: .milliseconds(300))

            // 检查是否已取消
            guard !Task.isCancelled else { return }

            let results = try? await api.search(query)

            guard !Task.isCancelled else { return }
            
            updateResults(results ?? [])
        }
    }
}
```

### 2.6 Task.sleep — 异步等待

```swift
// 不阻塞线程的等待
try await Task.sleep(for: .seconds(2))

// 带容差的等待（允许系统合并唤醒，省电）
try await Task.sleep(for: .seconds(2), tolerance: .milliseconds(500))

// 旧版 API（纳秒）
try await Task.sleep(nanoseconds: 2_000_000_000)
```

### 2.7 任务优先级

```swift
Task(priority: .high) {
    await urgentWork()
}

Task(priority: .background) {
    await lowPriorityCleanup()
}

// 可用优先级（从高到低）：
// .high, .medium, .low, .utility, .background, .userInitiated
```

### 2.8 注意事项

| 注意项 | 说明 |
|---|---|
| Task 取消是协作式的 | 不会强制停止，需要代码主动检查 `Task.isCancelled` |
| Task 持有 self 的引用 | 注意循环引用，必要时用 `[weak self]` |
| Task.sleep 会响应取消 | 被取消时 sleep 抛出 `CancellationError` |
| 避免创建过多 Task | 线程池有限（默认 ≈ CPU 核心数），过多会排队 |

---

## 3. TaskGroup — 并行任务组

### 3.1 原理

`TaskGroup` 提供**结构化并发**——在作用域内动态创建多个子任务，所有子任务完成后作用域才结束。子任务的取消会自动传播。

### 3.2 基本用法

```swift
func fetchAllUsers(ids: [String]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask {
                try await fetchUser(id: id)
            }
        }

        var users: [User] = []
        for try await user in group {
            users.append(user)
        }
        return users
    }
}
```

### 3.3 限制并发数

```swift
func downloadImages(urls: [URL]) async throws -> [UIImage] {
    try await withThrowingTaskGroup(of: UIImage.self) { group in
        let maxConcurrent = 4
        var results: [UIImage] = []
        var index = 0

        // 先添加 maxConcurrent 个任务
        for _ in 0..<min(maxConcurrent, urls.count) {
            let url = urls[index]
            group.addTask { try await self.downloadImage(from: url) }
            index += 1
        }

        // 每完成一个，再添加下一个
        for try await image in group {
            results.append(image)
            if index < urls.count {
                let url = urls[index]
                group.addTask { try await self.downloadImage(from: url) }
                index += 1
            }
        }

        return results
    }
}
```

### 3.4 withTaskGroup vs withThrowingTaskGroup

```swift
// 不抛错版本
let results = await withTaskGroup(of: Int.self) { group in
    for i in 0..<10 {
        group.addTask { i * 2 }
    }
    var sum = 0
    for await value in group {
        sum += value
    }
    return sum
}

// 可抛错版本
let results = try await withThrowingTaskGroup(of: Data.self) { group in
    // 任何子任务抛错 → 其他子任务自动取消
    // ...
}
```

### 3.5 withDiscardingTaskGroup（Swift 5.9+）

当不需要收集子任务结果时使用，性能更好（不缓存结果）：

```swift
await withDiscardingTaskGroup { group in
    for client in clients {
        group.addTask {
            await client.sendNotification()
        }
    }
    // 所有通知发送完成后自动结束
}
```

### 3.6 注意事项

| 注意项 | 说明 |
|---|---|
| 子任务结果顺序不确定 | 先完成的先返回，不是添加顺序 |
| 一个子任务抛错 | ThrowingTaskGroup 会取消其他子任务 |
| group 不能逃逸 | 不能把 group 存到外部变量 |
| 子任务闭包是 `@Sendable` | 捕获的值必须是 Sendable |

---

## 4. AsyncSequence / AsyncStream — 异步序列

### 4.1 原理

`AsyncSequence` 是 `Sequence` 的异步版本——元素按时间逐个产生，消费者用 `for await` 逐个接收。适用于：事件流、WebSocket 消息、文件逐行读取、定时器等。

### 4.2 for await — 消费异步序列

```swift
// URLSession 的 bytes 是 AsyncSequence
let (bytes, _) = try await URLSession.shared.bytes(from: url)
for try await byte in bytes {
    process(byte)
}

// NotificationCenter 的异步序列
for await notification in NotificationCenter.default.notifications(named: .userDidLogin) {
    handleLogin(notification)
}
```

### 4.3 AsyncStream — 创建自定义异步序列

```swift
// 基于回调的 API → AsyncStream
func locationUpdates() -> AsyncStream<CLLocation> {
    AsyncStream { continuation in
        let delegate = LocationDelegate()
        delegate.onUpdate = { location in
            continuation.yield(location)
        }
        delegate.onComplete = {
            continuation.finish()
        }
        continuation.onTermination = { _ in
            delegate.stop()
        }
        delegate.start()
    }
}

// 消费
for await location in locationUpdates() {
    print("位置: \(location.coordinate)")
}
```

### 4.4 AsyncThrowingStream

```swift
func stockPrices(symbol: String) -> AsyncThrowingStream<Double, Error> {
    AsyncThrowingStream { continuation in
        let connection = WebSocket(url: stockURL(symbol))
        connection.onMessage = { message in
            if let price = Double(message) {
                continuation.yield(price)
            }
        }
        connection.onError = { error in
            continuation.finish(throwing: error)
        }
        connection.onClose = {
            continuation.finish()
        }
        connection.connect()

        continuation.onTermination = { _ in
            connection.disconnect()
        }
    }
}
```

### 4.5 AsyncSequence 变换操作符

```swift
// map
let names = users.map { $0.name }

// filter
let adults = users.filter { $0.age >= 18 }

// prefix — 只取前 N 个
for await event in eventStream.prefix(10) { ... }

// dropFirst
for await event in eventStream.dropFirst(5) { ... }

// compactMap
for await value in stream.compactMap({ Int($0) }) { ... }
```

### 4.6 注意事项

| 注意项 | 说明 |
|---|---|
| `for await` 会挂起 | 没有新元素时当前任务挂起等待 |
| AsyncStream 的 bufferingPolicy | 可设置 `.bufferingNewest(N)` 或 `.bufferingOldest(N)` 控制背压 |
| continuation 是线程安全的 | 可以从任意线程 yield |
| 终止清理 | 始终设置 `onTermination` 释放资源 |

---

## 5. Sendable — 跨并发域的类型安全

### 5.1 原理

`Sendable` 是一个**标记协议（marker protocol）**，没有任何方法要求。它告诉编译器：这个类型的值可以安全地在不同并发域之间传递，不会引发数据竞争。

并发域（concurrency domain）包括：不同的 actor、不同的 Task、`@Sendable` 闭包的捕获等。

### 5.2 自动 Sendable 推断

编译器会自动推断以下类型为 Sendable（无需手动声明）：

```swift
// ✅ 值类型 + 所有存储属性是 Sendable → 自动推断
struct Point {
    var x: Double
    var y: Double
}
// Point 自动满足 Sendable

// ✅ 枚举 + 所有关联值是 Sendable → 自动推断
enum Result {
    case success(String)
    case failure(Int)
}

// ✅ 已知的 Sendable 基础类型
// Int, String, Bool, Double, Float
// Optional<Sendable>
// Array<Sendable>, Set<Sendable>, Dictionary<Sendable, Sendable>
// Tuple（所有元素 Sendable）
```

> **注意：** 自动推断仅适用于同一模块内。如果类型是 `public`，需要显式标记 `Sendable`。

### 5.3 显式标记 Sendable

```swift
// 显式声明（跨模块必须）
public struct UserProfile: Sendable {
    public let name: String
    public let age: Int
}

// Actor 自动满足 Sendable（Actor 本身就是并发安全的）
actor DataStore { }  // 隐式 Sendable
```

### 5.4 class 与 Sendable

class 要满足 Sendable 有严格限制：

```swift
// ✅ final class + 所有存储属性是 let + 属性类型是 Sendable
final class APIEndpoint: Sendable {
    let baseURL: URL
    let path: String
    let method: String
}

// ❌ 以下情况编译报错：
// 1. 非 final class
class BaseModel: Sendable { let id: String = "" }  // ❌ 子类可能破坏安全性

// 2. 包含 var 属性
final class MutableModel: Sendable { var name: String = "" }  // ❌ var 有数据竞争风险

// 3. 包含非 Sendable 属性
final class Wrapper: Sendable { let delegate: AnyObject = NSObject() }  // ❌ AnyObject 不是 Sendable
```

### 5.5 @unchecked Sendable

当你确信类型是线程安全的，但编译器无法证明：

```swift
final class AtomicCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Int = 0

    var value: Int {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    func increment() {
        lock.lock()
        defer { lock.unlock() }
        _value += 1
    }
}
```

**典型使用场景：**

- 内部使用锁/原子操作保护的类
- 包装 C/Obj-C 线程安全类型
- 迁移过渡期的临时标记

**⚠️ 风险：** 编译器跳过检查，如果实现有 bug，不会有编译警告。

### 5.6 @Sendable 闭包

闭包跨并发域传递时必须满足 `@Sendable`：

```swift
// Task 的闭包隐式是 @Sendable
Task {
    // 这里捕获的所有值必须是 Sendable
}

// 显式标记
func performAsync(_ work: @Sendable () async -> Void) async {
    await work()
}

// @Sendable 闭包的限制：
// 1. 捕获的值必须是 Sendable
// 2. 不能捕获可变局部变量
var counter = 0
let closure: @Sendable () -> Void = {
    // print(counter)  // ❌ 不能捕获可变局部变量
}

// ✅ 正确做法：先拷贝
let currentCount = counter
let closure2: @Sendable () -> Void = {
    print(currentCount)  // ✅ 捕获的是不可变的拷贝
}
```

### 5.7 给第三方类型追加 Sendable

```swift
// 如果你确信第三方类型是线程安全的
extension ThirdPartyLogger: @unchecked Sendable { }

// ⚠️ 这是你的保证，不是编译器的保证
// 如果第三方库更新后变得不安全，编译器不会警告
```

### 5.8 注意事项

| 注意项 | 说明 |
|---|---|
| Sendable 零运行时开销 | 纯编译期检查 |
| public 类型必须显式声明 | 自动推断仅限模块内部 |
| Actor 自动是 Sendable | 因为 actor 本身保证隔离 |
| 泛型 Sendable | `Array<T>` 是 Sendable 当且仅当 `T: Sendable` |
| `@unchecked` 应有注释 | 说明为什么你认为它是安全的 |

---

## 6. Actor — 状态隔离

### 6.1 原理

Actor 是一种**引用类型**，内置串行执行器（serial executor），保证同一时刻只有一个任务能访问其内部可变状态。这从编译器层面消除了数据竞争。

```
┌─────────────────────────────────┐
│           Actor                 │
│  ┌───────────────────────────┐  │
│  │   串行执行器（Mailbox）     │  │
│  │   ┌─────┬─────┬─────┐    │  │
│  │   │ T1  │ T2  │ T3  │←───│──│── 外部调用排队等待
│  │   └─────┴─────┴─────┘    │  │
│  └───────────────────────────┘  │
│                                 │
│   var state: Int = 0            │  ← 受保护的可变状态
│   func mutate() { ... }        │  ← 只能通过执行器访问
└─────────────────────────────────┘
```

### 6.2 基本语法

```swift
actor ShoppingCart {
    private var items: [CartItem] = []

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    var itemCount: Int {
        items.count
    }

    func add(_ item: CartItem) {
        items.append(item)
    }

    func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
    }

    func clear() {
        items.removeAll()
    }
}
```

### 6.3 外部访问需要 await

```swift
let cart = ShoppingCart()

// 外部访问 actor 的属性和方法，都需要 await
Task {
    await cart.add(CartItem(name: "iPhone", price: 999, quantity: 1))
    let count = await cart.itemCount
    let total = await cart.totalPrice
    print("购物车 \(count) 件商品，总价 \(total)")
}
```

### 6.4 内部访问无需 await

```swift
actor ShoppingCart {
    private var items: [CartItem] = []

    func checkout() -> Order {
        // 内部访问，同一隔离域，无需 await
        let total = totalPrice
        let count = itemCount
        let order = Order(items: items, total: total)
        clear()
        return order
    }

    // 内部调用也无需 await
    private func applyDiscount() {
        let total = totalPrice  // ✅ 同步访问
        if total > 1000 {
            // apply discount
        }
    }
}
```

### 6.5 nonisolated — 退出隔离

```swift
actor UserSession {
    let userId: String          // let 属性——不可变
    let createdAt: Date
    var lastActiveAt: Date
    var token: String?

    // let 属性可以从外部同步访问
    // 但 computed property 默认是 isolated
    // 需要 nonisolated 标记才能同步调用
    nonisolated var sessionId: String {
        "\(userId)-\(createdAt.timeIntervalSince1970)"
    }

    // 遵循协议的同步要求
    // Hashable 的 hash(into:) 是同步方法
    // actor 方法默认是 async 的
    // 所以必须 nonisolated
}

extension UserSession: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }

    static nonisolated func == (lhs: UserSession, rhs: UserSession) -> Bool {
        lhs.userId == rhs.userId
    }
}
```

### 6.6 Actor 的可重入性（Reentrancy）

**这是 Actor 最大的陷阱。** Actor 方法在 `await` 挂起时，会释放执行器，允许其他任务进入：

```swift
actor ImageDownloader {
    private var cache: [URL: UIImage] = [:]

    func image(for url: URL) async throws -> UIImage {
        // 检查缓存
        if let cached = cache[url] {
            return cached
        }

        // ⚠️ 挂起点！此时 actor 释放执行器
        // 另一个任务可能也在下载同一张图
        let image = try await downloadImage(from: url)

        // ⚠️ 恢复后，状态可能已变化
        // 正确做法：再次检查
        if let cached = cache[url] {
            return cached  // 其他任务已下载完成，使用它的结果
        }

        cache[url] = image
        return image
    }
}
```

**更安全的模式——用 in-flight 字典避免重复请求：**

```swift
actor ImageDownloader {
    private var cache: [URL: UIImage] = [:]
    private var inProgress: [URL: Task<UIImage, Error>] = [:]

    func image(for url: URL) async throws -> UIImage {
        if let cached = cache[url] {
            return cached
        }

        // 如果已有进行中的下载，等待它
        if let existing = inProgress[url] {
            return try await existing.value
        }

        // 创建新任务并注册
        let task = Task {
            try await downloadImage(from: url)
        }
        inProgress[url] = task

        do {
            let image = try await task.value
            cache[url] = image
            inProgress[url] = nil
            return image
        } catch {
            inProgress[url] = nil
            throw error
        }
    }
}
```

### 6.7 跨 Actor 调用

```swift
actor DatabaseManager {
    func save(_ record: Record) { ... }
}

actor NetworkManager {
    let db: DatabaseManager

    init(db: DatabaseManager) {
        self.db = db
    }

    func fetchAndSave() async throws {
        let data = try await fetch()
        let record = parse(data)
        // 跨 actor 调用，需要 await
        await db.save(record)
    }
}
```

### 6.8 注意事项

| 注意项 | 说明 |
|---|---|
| Actor 是引用类型 | 类似 class，但不支持继承 |
| Actor 自动满足 Sendable | 可以安全地跨并发域传递 |
| 跨 actor 传参必须 Sendable | 参数和返回值都必须是 Sendable |
| 可重入是默认行为 | 每个 await 都可能导致其他任务插入 |
| 避免 actor 中做耗时同步操作 | 会阻塞其他等待的任务 |
| `let` 属性可以跨 actor 同步访问 | 因为不可变，无竞争 |

---

## 7. MainActor — 主线程隔离

### 7.1 原理

`@MainActor` 是一个**全局 Actor（Global Actor）**，其执行器绑定到主线程（Main Dispatch Queue）。所有标记 `@MainActor` 的代码保证在主线程执行。

本质定义：

```swift
@globalActor
final actor MainActor: GlobalActor {
    static let shared = MainActor()
    // 其执行器 = Main Dispatch Queue
}
```

### 7.2 标记整个类型

```swift
@MainActor
class SettingsViewController: UIViewController {
    var isDarkMode: Bool = false        // ✅ MainActor 隔离
    var fontSize: CGFloat = 16          // ✅ MainActor 隔离

    func toggleDarkMode() {             // ✅ MainActor 隔离
        isDarkMode.toggle()
        applyTheme()
    }

    func applyTheme() {                 // ✅ MainActor 隔离
        view.backgroundColor = isDarkMode ? .black : .white
    }

    // 后台计算，不需要在主线程
    nonisolated func computeLayoutHash() -> Int {
        // 不访问任何 UI 状态
        return someExpensiveHash()
    }
}
```

### 7.3 标记单个成员

```swift
class DataProcessor {
    private var results: [ProcessedItem] = []

    // 数据处理在后台
    func processData(_ raw: [RawItem]) async -> [ProcessedItem] {
        return raw.map { transform($0) }
    }

    // 只有 UI 更新标记 @MainActor
    @MainActor
    func updateUI(with items: [ProcessedItem]) {
        self.results = items
        tableView.reloadData()
    }

    @MainActor
    var displayTitle: String {
        "Results (\(results.count))"
    }
}
```

### 7.4 UIKit / SwiftUI 中的 MainActor

**Swift 6 中，UIKit 核心类已标记 @MainActor：**

```swift
// UIView, UIViewController, UIApplication 等都是 @MainActor
// 所以你的子类也自动在 MainActor

class MyViewController: UIViewController {
    // 这里所有代码都在 MainActor

    override func viewDidLoad() {
        super.viewDidLoad()
        // ✅ 已经在主线程

        Task {
            // ✅ Task 继承 MainActor 上下文
            let data = try await fetchData()
            label.text = data.title  // ✅ 仍在主线程
        }
    }
}
```

**SwiftUI 的 @Observable / ObservableObject 推荐标记 @MainActor：**

```swift
@MainActor
@Observable
class AppState {
    var currentUser: User?
    var isLoading = false

    func login(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            currentUser = try await AuthService.login(email: email, password: password)
        } catch {
            // handle error
        }
    }
}
```

### 7.5 MainActor.run — 临时切换到主线程

```swift
func processInBackground() async throws {
    let data = try await fetchLargeDataset()

    // 在后台线程处理
    let processed = transform(data)

    // 切到主线程更新 UI
    await MainActor.run {
        self.dataSource = processed
        self.tableView.reloadData()
    }

    // 这里已离开 MainActor.run，可能不在主线程
    await saveToCache(processed)
}
```

### 7.6 MainActor.assumeIsolated — 断言当前在主线程

```swift
// 当你 *确定* 代码在主线程运行，但编译器无法推断时
func handleNotification(_ notification: Notification) {
    // 由 NotificationCenter 在主线程调用，但编译器不知道
    MainActor.assumeIsolated {
        self.refreshUI()  // ✅ 编译通过
    }
    // ⚠️ 如果实际不在主线程，运行时会触发 fatalError！
}
```

### 7.7 @MainActor 与 async 方法的交互

```swift
@MainActor
class ViewModel {
    var items: [Item] = []

    func loadItems() async {
        // ✅ 开始在主线程
        self.items = []

        // ⚠️ await 挂起，出让主线程
        let fetchedItems = try? await api.fetchItems()

        // ✅ 恢复后回到主线程（@MainActor 保证）
        self.items = fetchedItems ?? []
    }
}
```

### 7.8 注意事项

| 注意项 | 说明 |
|---|---|
| 不要过度使用 | 把所有代码都标 @MainActor 会让主线程超负荷 |
| 大量计算不要放在 MainActor | 会阻塞 UI，用 `nonisolated` 或 `Task.detached` |
| `MainActor.run` vs `@MainActor` | 前者命令式、临时切换；后者声明式、编译器验证 |
| `assumeIsolated` 要谨慎 | 错误使用会运行时崩溃 |
| `Task { }` 在 MainActor 内继承上下文 | 创建的 Task 也在 MainActor |
| `Task.detached { }` 不继承 | 分离任务不在 MainActor |

---

## 8. GlobalActor — 自定义全局 Actor

### 8.1 原理

Global Actor 是一种全局共享的 actor 实例，可以用来隔离分散在不同类型中的代码到同一个串行执行器。`@MainActor` 就是一个 Global Actor。你也可以定义自己的。

### 8.2 自定义 Global Actor

```swift
@globalActor
actor DatabaseActor: GlobalActor {
    static let shared = DatabaseActor()
}

// 使用自定义 Global Actor
@DatabaseActor
class UserRepository {
    var users: [User] = []

    func save(_ user: User) {
        users.append(user)
        writeToDatabase(user)
    }
}

@DatabaseActor
class PostRepository {
    var posts: [Post] = []

    func save(_ post: Post) {
        posts.append(post)
        writeToDatabase(post)
    }
}

// UserRepository 和 PostRepository 共享同一个 DatabaseActor 执行器
// 它们之间的调用是同步的（同一隔离域）
// 从外部调用需要 await
```

### 8.3 适用场景

- 多个类型需要共享同一个串行队列保护（如数据库操作）
- 替代 `DispatchQueue` 的标签队列模式
- 需要跨多个类型统一隔离策略

### 8.4 注意事项

| 注意项 | 说明 |
|---|---|
| 不要滥用 | 大多数情况用普通 actor 实例就够 |
| 全局 actor 是单例 | `.shared` 是全局唯一实例 |
| 串行化范围大 | 所有标记该 actor 的代码共享一个串行队列 |

---

## 9. isolation / isolated / nonisolated — 隔离控制

### 9.1 nonisolated 关键字（详解）

已在 Actor 章节简述，这里展开更多场景：

```swift
actor AudioPlayer {
    let fileURL: URL
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    // ✅ 不访问可变状态，标记 nonisolated
    nonisolated var fileName: String {
        fileURL.lastPathComponent
    }

    // ✅ 协议遵循——Codable 的方法是同步的
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileURL, forKey: .fileURL)
        // ❌ 不能访问 isPlaying（可变状态）
    }
}
```

### 9.2 isolated 参数

可以把 actor 隔离传递给函数参数，让函数在该 actor 的隔离域内执行：

```swift
// 普通写法：外部调用 actor 方法需要 await
func updateAccount(_ account: BankAccount) async {
    await account.deposit(100)
}

// isolated 参数：函数体内直接在 actor 隔离域中
func updateAccount(_ account: isolated BankAccount) {
    account.deposit(100)  // ✅ 无需 await，因为已在 account 的隔离域
}

// 调用时仍需 await
await updateAccount(myAccount)
```

**在协议中使用：**

```swift
protocol Updatable: Actor {
    func performUpdate()
}

// 默认实现在 actor 隔离域中执行
extension Updatable {
    func performUpdate() {
        // 这里在具体 actor 的隔离域中
    }
}
```

### 9.3 #isolation — 隔离上下文传递（Swift 5.9+）

```swift
// 捕获当前的隔离上下文
func doWork(isolation: isolated (any Actor)? = #isolation) async {
    // 如果调用者在某个 actor 上，这个函数也在那个 actor 上执行
    // 如果调用者不在任何 actor 上，isolation 为 nil
}

// 在 MainActor 上调用 → doWork 在 MainActor 上执行
// 在某个 actor 上调用 → doWork 在那个 actor 上执行
```

### 9.4 nonisolated(unsafe) — 全局变量的逃生舱

```swift
// Swift 6 要求全局/静态变量必须是 Sendable 或隔离的
// 对于确实线程安全但编译器无法验证的情况：
nonisolated(unsafe) var appLaunchTime = Date()

// ⚠️ 你承诺这个变量不会有数据竞争
// 如果多个线程同时读写，运行时依然会崩溃
```

### 9.5 注意事项

| 注意项 | 说明 |
|---|---|
| `nonisolated` 方法不能访问 actor 的 var 属性 | 只能访问 `let`、`Sendable` 的 `let`、其他 `nonisolated` |
| `isolated` 参数使调用者需要 `await` | 但被调函数内部无需 await |
| `nonisolated(unsafe)` 是最后手段 | 优先用 `@MainActor` 或 actor 封装 |

---

## 10. Continuation — 桥接回调与 async

### 10.1 原理

许多旧 API 使用回调（completion handler）风格。`Continuation` 是桥接回调到 async/await 的标准工具。

### 10.2 withCheckedContinuation — 不抛错版

```swift
func currentLocation() async -> CLLocation {
    await withCheckedContinuation { continuation in
        locationManager.requestLocation { location in
            continuation.resume(returning: location)
        }
    }
}
```

### 10.3 withCheckedThrowingContinuation — 可抛错版

```swift
func fetchImage(url: URL) async throws -> UIImage {
    try await withCheckedThrowingContinuation { continuation in
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                continuation.resume(throwing: error)
                return
            }
            guard let data, let image = UIImage(data: data) else {
                continuation.resume(throwing: ImageError.invalidData)
                return
            }
            continuation.resume(returning: image)
        }.resume()
    }
}
```

### 10.4 withUnsafeContinuation / withUnsafeThrowingContinuation

与 checked 版本功能相同，但性能更好（去掉了运行时检查）：

```swift
// 性能敏感路径可用 unsafe 版本
func fastFetch() async -> Data {
    await withUnsafeContinuation { continuation in
        // ...
        continuation.resume(returning: data)
    }
}
```

### 10.5 续体使用规则（极其重要）

```swift
// ✅ 必须恰好 resume 一次
continuation.resume(returning: value)   // 正常返回
continuation.resume(throwing: error)    // 抛出错误
continuation.resume()                    // 返回 Void

// ❌ 致命错误：resume 两次
continuation.resume(returning: a)
continuation.resume(returning: b)  // 💥 运行时崩溃（checked 版本）
                                   // 未定义行为（unsafe 版本）

// ❌ 致命错误：从不 resume
// → 调用者永远挂起，任务泄漏
```

### 10.6 注意事项

| 注意项 | 说明 |
|---|---|
| **必须 resume 且只 resume 一次** | 这是最重要的规则 |
| checked vs unsafe | checked 在错误使用时给明确崩溃信息，unsafe 性能更好 |
| continuation 是 Sendable 的 | 可以在任意线程 resume |
| 多路径 completion handler | 确保每条路径都有且只有一次 resume |
| 结合 delegate 模式 | 可能需要存储 continuation，注意生命周期 |

---

## 11. 数据竞争安全与 Swift 6 严格模式

### 11.1 Swift 6 的核心变化

Swift 6 将数据竞争安全检查从**警告提升为错误**。编译器会检查：

1. 跨并发域传递的类型是否 Sendable
2. 可变状态是否正确隔离
3. 全局/静态变量是否安全
4. 闭包捕获是否满足 @Sendable

### 11.2 启用严格并发检查

```swift
// Package.swift（Swift 6 模式）
.target(
    name: "MyTarget",
    swiftSettings: [
        .swiftLanguageMode(.v6)
    ]
)

// 渐进式启用（在 Swift 5 模式下）
.target(
    name: "MyTarget",
    swiftSettings: [
        .enableUpcomingFeature("StrictConcurrency")
    ]
)
```

**Xcode Build Settings：**

- `SWIFT_STRICT_CONCURRENCY`：`minimal` → `targeted` → `complete`

### 11.3 渐进式迁移策略

```
阶段 1：minimal
  → 只检查显式标记的代码
  → 影响最小，适合初期了解

阶段 2：targeted（推荐起步）
  → 检查已采用 async/await、actor 等并发特性的代码
  → 大多数新代码自动检查

阶段 3：complete
  → 全面检查所有代码
  → Swift 6 的默认级别
  → 最终目标
```

### 11.4 常见编译错误速查表

#### 错误 1：`Non-sendable type 'X' passed across actor boundary`

```swift
// ❌ 
class Config { var debug = false }
actor Server {
    func configure(_ config: Config) { }  // ❌ Config 不是 Sendable
}

// ✅ 方案 A：改 struct
struct Config: Sendable { let debug: Bool }

// ✅ 方案 B：改 final class + 不可变
final class Config: Sendable { let debug: Bool; init(debug: Bool) { self.debug = debug } }

// ✅ 方案 C：@unchecked Sendable（如果内部有锁保护）
```

#### 错误 2：`Capture of non-sendable type in @Sendable closure`

```swift
// ❌
class MyVC: UIViewController {
    var data: [Item] = []
    func load() {
        Task {
            data = try await fetch()  // ❌ self 不是 Sendable
        }
    }
}

// ✅ 方案 A：标记 @MainActor（UIViewController 在 Swift 6 已自动标记）
// 确认 MyVC 继承 UIViewController 即可

// ✅ 方案 B：提取 Sendable 数据再传递
func load() {
    let url = self.endpoint  // 先取出 Sendable 值
    Task {
        let items = try await fetch(url: url)
        await MainActor.run {
            self.data = items
        }
    }
}
```

#### 错误 3：`Main actor-isolated property accessed from nonisolated context`

```swift
// ❌
@MainActor class VM { var title = "" }
func show(vm: VM) {
    print(vm.title)  // ❌ 非隔离上下文访问 MainActor 属性
}

// ✅ 方案 A：标记调用者为 @MainActor
@MainActor func show(vm: VM) { print(vm.title) }

// ✅ 方案 B：使用 await
func show(vm: VM) async { print(await vm.title) }
```

#### 错误 4：`Static/global variable is not concurrency-safe`

```swift
// ❌
var globalLogger = Logger()
static var shared = MyManager()

// ✅ 方案 A：@MainActor 隔离
@MainActor var globalLogger = Logger()

// ✅ 方案 B：actor 封装
actor LoggerActor {
    static let shared = LoggerActor()
    private let logger = Logger()
    func log(_ message: String) { logger.log(message) }
}

// ✅ 方案 C：let + Sendable 类型
let globalConfig = AppConfig()  // AppConfig: Sendable

// ✅ 方案 D：nonisolated(unsafe)（最后手段）
nonisolated(unsafe) static var shared = MyManager()
```

#### 错误 5：`Actor-isolated property can not be mutated from a Sendable closure`

```swift
// ❌
@MainActor class VC: UIViewController {
    var count = 0
    func increment() {
        Task.detached {
            self.count += 1  // ❌ detached 不继承 MainActor
        }
    }
}

// ✅ 改用 Task（继承上下文）
func increment() {
    Task {
        self.count += 1  // ✅ Task 继承 MainActor
    }
}

// ✅ 或在 detached 中显式切换
func increment() {
    Task.detached {
        await MainActor.run {
            self.count += 1
        }
    }
}
```

---

## 12. 实战迁移指南

### 12.1 迁移决策树

```
你的类型需要跨并发域使用吗？
│
├─ 否 → 暂时不处理（minimal/targeted 模式下不会报错）
│
└─ 是 → 它有可变状态吗？
    │
    ├─ 否 → 标记 Sendable
    │   ├─ struct/enum → 通常自动推断
    │   └─ class → final + 全 let 属性 + 显式 Sendable
    │
    └─ 是 → 选择隔离策略：
        │
        ├─ 纯 UI 状态 → @MainActor
        │
        ├─ 共享业务状态 → 改为 actor
        │
        ├─ 值语义合适 → 改为 struct（推荐）
        │
        └─ 无法修改（三方库等） → @unchecked Sendable + 确认线程安全
```

### 12.2 常见模式改造

**Singleton → Actor：**

```swift
// 旧代码
class CacheManager {
    static let shared = CacheManager()
    private var cache: [String: Data] = [:]
    private let queue = DispatchQueue(label: "cache")

    func get(_ key: String) -> Data? {
        queue.sync { cache[key] }
    }
    func set(_ key: String, data: Data) {
        queue.async { self.cache[key] = data }
    }
}

// 新代码
actor CacheManager {
    static let shared = CacheManager()
    private var cache: [String: Data] = [:]

    func get(_ key: String) -> Data? {
        cache[key]
    }
    func set(_ key: String, data: Data) {
        cache[key] = data
    }
}
// 调用：let data = await CacheManager.shared.get("key")
```

**Delegate 回调 → AsyncStream：**

```swift
// 旧代码
protocol ScannerDelegate: AnyObject {
    func scanner(_ scanner: Scanner, didFind code: String)
    func scannerDidFinish(_ scanner: Scanner)
}

// 新代码
class Scanner {
    func scan() -> AsyncStream<String> {
        AsyncStream { continuation in
            self.onFound = { code in
                continuation.yield(code)
            }
            self.onFinish = {
                continuation.finish()
            }
            startScanning()
        }
    }
}

// 使用
for await code in scanner.scan() {
    print("Found: \(code)")
}
```

**Completion Handler → async/await：**

```swift
// 旧代码
func fetchUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error { completion(.failure(error)); return }
        // ...
        completion(.success(user))
    }.resume()
}

// 新代码
func fetchUser(id: String) async throws -> User {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}
```

### 12.3 全部并发关键字速查

| 关键字 / 标注 | 用途 |
|---|---|
| `async` | 声明异步函数/属性 |
| `await` | 标记潜在挂起点 |
| `async let` | 并发绑定，多个异步操作同时启动 |
| `Task { }` | 创建非结构化任务（继承上下文） |
| `Task.detached { }` | 创建分离任务（不继承上下文） |
| `TaskGroup` | 结构化并发任务组 |
| `AsyncSequence` | 异步序列协议 |
| `AsyncStream` | 创建自定义异步序列 |
| `for await` | 遍历异步序列 |
| `actor` | 声明 actor 类型（状态隔离） |
| `@MainActor` | 隔离到主线程 |
| `@globalActor` | 自定义全局 actor |
| `Sendable` | 标记类型可安全跨并发域传递 |
| `@Sendable` | 标记闭包可安全跨并发域传递 |
| `@unchecked Sendable` | 跳过编译器 Sendable 检查 |
| `nonisolated` | 退出 actor 隔离域 |
| `nonisolated(unsafe)` | 不安全地退出隔离（全局变量） |
| `isolated` | 参数继承 actor 隔离 |
| `#isolation` | 捕获当前隔离上下文 |
| `withCheckedContinuation` | 桥接回调到 async（checked） |
| `withCheckedThrowingContinuation` | 桥接可抛错回调到 async（checked） |
| `withUnsafeContinuation` | 桥接回调到 async（unsafe） |
| `withUnsafeThrowingContinuation` | 桥接可抛错回调到 async（unsafe） |
| `MainActor.run { }` | 临时在主线程执行代码块 |
| `MainActor.assumeIsolated { }` | 断言当前在主线程（运行时检查） |
| `Task.isCancelled` | 检查任务是否已取消 |
| `Task.checkCancellation()` | 如已取消则抛出 CancellationError |
| `Task.sleep(for:)` | 异步等待（不阻塞线程） |
| `withTaskGroup` | 创建不抛错任务组 |
| `withThrowingTaskGroup` | 创建可抛错任务组 |
| `withDiscardingTaskGroup` | 创建丢弃结果的任务组 |

### 12.4 最佳实践总结

1. **优先值类型**：struct/enum 天然 Sendable，迁移成本最低
2. **UI 层用 @MainActor**：ViewController、ViewModel 标记 @MainActor
3. **共享可变状态用 actor**：替代 DispatchQueue + 手动同步
4. **回调迁移用 Continuation**：逐步将 completion handler 改为 async
5. **`@unchecked Sendable` 加注释**：说明为什么安全
6. **`nonisolated(unsafe)` 是最后手段**：优先尝试其他方案
7. **每个 await 后检查前置条件**：actor 可重入
8. **渐进式迁移**：`minimal` → `targeted` → `complete`
9. **利用 `async let` 并发**：独立任务不要顺序 await
10. **Continuation 必须恰好 resume 一次**：多路径时仔细检查

---

> 本文基于 Swift 6.0 / Xcode 16，适用于 iOS 17+、macOS 14+ 项目。
> 随着 Swift 演进，部分 API 可能有更新，请参考 [Swift Evolution](https://github.com/swiftlang/swift-evolution) 获取最新提案。
