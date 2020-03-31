//
//  SecondController.swift
//  Thread_Swift3.0
//
//  Created by 伯驹 黄 on 2016/10/26.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

// https://www.allaboutswift.com/dev/2016/7/12/gcd-with-swfit3
// http://www.cnblogs.com/ludashi/p/5336169.html
// https://justinyan.me/post/2420
// https://bestswifter.com/deep-gcd/
// http://www.cocoachina.com/ios/20170829/20404.html

extension SecondController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension SecondController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.tintColor = UIColor.red
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tags[indexPath.section][indexPath.row].0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let tag = tags[indexPath.section][indexPath.row]
        print("🍀🍀🍀\(tag.0)🍀🍀🍀")
        print("**************************开始**************************")
        perform(tag.1)
    }
}

class SecondController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    let tags: [[(String, Selector)]] = [
        [
            ("同步执行串行队列", #selector(performSerialQueuesUseSynchronization)),
            ("同步执行并行队列", #selector(performConcurrentQueuesUseSynchronization))
        ],
        [
            ("异步执行串行队列", #selector(performSerialQueuesUseAsynchronization)),
            ("异步执行并行队列", #selector(performConcurrentQueuesUseAsynchronization))
        ],
        [
            ("延迟执行", #selector(deferPerform))
        ],
        [
            ("设置全局队列的优先级", #selector(globalQueuePriority)),
            ("设置自建队列优先级", #selector(setCustomeQueuePriority))
        ],
        [
            ("自动执行任务组", #selector(autoGlobalQueue)),
            ("手动执行任务组", #selector(performGroupUseEnterAndleave))
        ],
        [
            ("使用信号量添加同步锁", #selector(useSemaphoreLock))
        ],
        [
            ("使用Apply循环执行", #selector(useDispatchApply)),
            ("暂停和重启队列", #selector(queueSuspendAndResume)),
            ("使用任务隔离栅栏", #selector(useBarrierAsync))
        ],
        [
            ("dispatch源,ADD", #selector(useDispatchSourceAdd)),
            ("dispatch源,OR", #selector(useDispatchSourceOR)),
            ("dispatch源,定时器", #selector(useDispatchSourceTimer))
        ],
        [
            ("不同queue opration 依赖", #selector(diffQueue))
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swift5.0 GCD"
        
        view.addSubview(tableView)
    }
    
    @objc func performSerialQueuesUseSynchronization() {
        let queue = DispatchQueue(label: "syn.serial.queue")
        for i in 0..<3 {
            queue.sync() {
                currentThreadSleep(1)
                print("当前执行线程：\(Thread.current)")
                print("执行\(i.toEmoji)")
            }
            print("\(i.toEmoji)执行完毕")
        }
        print("所有队列使用同步方式执行完毕")
        ended()
    }
    
    @objc func performConcurrentQueuesUseSynchronization() {
        let queue = DispatchQueue(label: "syn.concurrent.queue", attributes: .concurrent)
        for i in 0..<3 {
            queue.sync() {
                currentThreadSleep(1)
                print("当前执行线程：\(Thread.current)")
                print("执行\(i.toEmoji)")
            }
            print("\(i.toEmoji)执行完毕")
        }
        print("所有队列使用同步方式执行完毕")
        ended()
    }
    
    @objc func performSerialQueuesUseAsynchronization() {
        //一个串行队列，用于同步执行
        
        let queue = DispatchQueue(label: "asyn.serial.queue")

        let group = DispatchGroup()
        
        let q = serialQueue("serialQueue")

        for i in 0..<3 {
            group.enter()
            queue.async(group: group) {
                self.currentThreadSleep(Double(arc4random()%3))
                let currentThread = Thread.current
                q.sync {              //同步锁
                    group.leave()
                    print("①Sleep的线程\(currentThread)")
                    print("②当前输出内容的线程\(Thread.current)")
                    print("③执行\(i.toEmoji):\(queue)\n")
                }
            }
            print("\(i.toEmoji)添加完毕\n")
        }
        print("使用异步方式添加队列")
        
        group.notify(queue: DispatchQueue.main) {
            self.ended()
        }
    }
    
    @objc func performConcurrentQueuesUseAsynchronization() {
        
        //一个串行队列，用于同步执行
        let queue = DispatchQueue(label: "asyn.concurrent.queue", attributes: .concurrent)
        let group = DispatchGroup()
        
        let q = serialQueue("serialQueue")
        for i in 0..<3 {
            group.enter()
            queue.async(group: group) {
                self.currentThreadSleep(Double(arc4random()%3))
                let currentThread = Thread.current
                q.sync {              //同步锁
                    group.leave()
                    print("①Sleep的线程\(currentThread)")
                    print("②当前输出内容的线程\(Thread.current)")
                    print("③执行\(i.toEmoji):\(queue)\n")
                }
            }
            print("\(i.toEmoji)添加完毕\n")
        }
        print("使用异步方式添加队列")
        
        group.notify(queue: DispatchQueue.main) {
            self.ended()
        }
    }

    @objc func diffQueue() {
        let queue1 = OperationQueue()
        queue1.name = "queue1"
        
        let queue2 = OperationQueue()
        queue2.name = "queue2"
        
        let opration1 = BlockOperation {
            sleep(2)
            print("我是1")
        }
        queue1.addOperation(opration1)
        
        let opration2 = BlockOperation {
            print("我是2")
        }
        opration2.addDependency(opration1)
        queue2.addOperation(opration2)
    }

    func currentThreadSleep(_ timer: TimeInterval) {
        print("😪😪😪延时😪😪😪")
        Thread.sleep(forTimeInterval: timer)
    }
    
    
    /// 创建串行队列
    func serialQueue(_ label: String) -> DispatchQueue {
        return DispatchQueue(label: label)
    }
    
    
    /// 创建并行队列
    func getConcurrentQueue(_ label: String) -> DispatchQueue {
        return DispatchQueue(label: label, attributes: .concurrent)
    }
    
    
    /// 延迟执行
    @objc func deferPerform(_ time: Int = 1) {
        
        let semaphore = DispatchSemaphore(value: 0)
        let queue = globalQueue()
        let delaySecond = DispatchTimeInterval.seconds(time)
        
        print(Date())
        let delayTime = DispatchTime.now() + delaySecond
        queue.asyncAfter(deadline: delayTime) {
            print("执行线程：\(Thread.current)\ndispatch_time: 延迟\(time)秒执行\n",Date())
            semaphore.signal()
        }
        
        //DispatchWallTime用于计算绝对时间,而DispatchWallTime是根据挂钟来计算的时间，即使设备睡眠了，他也不会睡眠。
        //        let nowInterval = Date().timeIntervalSince1970
        //        let nowStruct = timespec(tv_sec: Int(nowInterval), tv_nsec: 0)
        //        let delayWalltime = DispatchWallTime(timespec: nowStruct)
        let delayWalltime = DispatchWallTime.now() + delaySecond
        queue.asyncAfter(wallDeadline: delayWalltime) {
            print("执行线程：\(Thread.current)\ndispatch_walltime: 延迟\(time)秒执行\n", Date())
        }
        semaphore.wait()
        
        ended()
    }
    
    func ended() {
        print("**************************结束**************************\n")
    }
    
    
    // http://www.jianshu.com/p/7efbecee6af8
    /*
     * DISPATCH_QUEUE_PRIORITY_HIGH:         .userInitiated
     * DISPATCH_QUEUE_PRIORITY_DEFAULT:      .default
     * DISPATCH_QUEUE_PRIORITY_LOW:          .utility
     * DISPATCH_QUEUE_PRIORITY_BACKGROUND:   .background
     */
    
//    * QOS_CLASS_USER_INTERACTIVE：User Interactive（用户交互）类的任务关乎用户体验，这类任务是需要立刻被执行的。这类任务应该用在更新 UI，处理事件，执行一些需要低延迟的轻量的任务。这种类型的任务应该要压缩到尽可能少。
//    * QOS_CLASS_USER_INITIATED: User Initiated（用户发起）类是指由 UI 发起的可以异步执行的任务。当用户在等待任务返回的结果，然后才能执行下一步动作的时候可以使用这种类型。
//    * QOS_CLASS_UTILITY：Utility（工具）类是指耗时较长的任务，通常会展示给用户一个进度条。这种类型应该用在大量计算，I/O 操作，网络请求，实时数据推送之类的任务。这个类是带有节能设计的。
//    * QOS_CLASS_BACKGROUND：background（后台）类是指用户并不会直接感受到的任务。这个类应该用在数据预拉取，维护以及其他不需要用户交互，对时间不敏感的任务。
    
    func globalQueue(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue {
        return DispatchQueue.global(qos: qos)
    }
    
    
    /// 全局队列的优先级关系
    @objc func globalQueuePriority() {
        //高 > 默认 > 低 > 后台
        
        let queueHeight = globalQueue(qos: .userInitiated)
        let queueDefault = globalQueue()
        let queueLow = globalQueue(qos: .utility)
        let queueBackground = globalQueue(qos: .background)
        
        let group = DispatchGroup()
        //优先级不是绝对的，大体上会按这个优先级来执行。 一般都是使用默认（default）优先级
        queueLow.async(group: group) {
            
            print("Low：\(Thread.current)")
        }
        
        queueBackground.async(group: group) {
            print("Background：\(Thread.current)")
        }
        
        queueDefault.async(group: group) {
            print("Default：\(Thread.current)")
        }
        
        queueHeight.async(group: group) {
            print("High：\(Thread.current)")
        }
        
        group.wait()
        
        ended()
    }
    
    
    /// 给串行队列或者并行队列设置优先级
    @objc func setCustomeQueuePriority() {
        //优先级的执行顺序也不是绝对的
        
        //给serialQueueHigh设定DISPATCH_QUEUE_PRIORITY_HIGH优先级
        let serialQueueHigh = serialQueue("cn.zeluli.serial1")
        globalQueue(qos: .userInitiated).setTarget(queue: serialQueueHigh)
        
        let serialQueueLow = serialQueue("cn.zeluli.serial1")
        globalQueue(qos: .utility).setTarget(queue: serialQueueLow)
        
        
        
        serialQueueLow.async {
            print("低：\(Thread.current)")
        }
        
        serialQueueHigh.async {
            print("高：\(Thread.current)")
            self.ended()
        }
    }
    
    func performGroupQueue() {
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        let group = DispatchGroup()
        
        //将group与queue进行管理，并且自动执行
        for i in 1...3 {
            concurrentQueue.async(group: group) {
                self.currentThreadSleep(1)
                print("任务\(i)执行完毕\n")
            }
        }
        
        //队列组的都执行完毕后会进行通知
        group.notify(queue: DispatchQueue.main) {
            self.ended()
        }
        
        print("异步执行测试，不会阻塞当前线程")
    }
    
    @objc func autoGlobalQueue() {
        globalQueue().async {
            self.performGroupQueue()
        }
    }
    
    /// 使用enter与leave手动管理group与queue
    @objc func performGroupUseEnterAndleave() {
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        let group = DispatchGroup()
        
        //将group与queue进行手动关联和管理，并且自动执行
        for i in 1...3 {
            group.enter() //进入队列组
            concurrentQueue.async {
                self.currentThreadSleep(1)
                print("任务\(i.toEmoji)执行完毕\n")
                group.leave()                 //离开队列组
            }
        }
        
        _ = group.wait(timeout: .distantFuture) //阻塞当前线程，直到所有任务执行完毕
        print("任务组执行完毕")
        
        group.notify(queue: concurrentQueue) {
            self.ended()
        }
    }
    
    //信号量同步锁
    @objc func useSemaphoreLock() {
        
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        
        //创建信号量
        let semaphoreLock = DispatchSemaphore(value: 2)
        
        var testNumber = 0
        
        for index in 0 ... 9 {
            concurrentQueue.async {
                let wait = semaphoreLock.wait(timeout: .distantFuture) //上锁
                print("wait=\(wait)")
                testNumber += 1
                self.currentThreadSleep(1)
                print(Thread.current)
                print("第\(index.toEmoji)次执行: testNumber = \(testNumber)\n")
                
                semaphoreLock.signal()                      //开锁
                
            }
        }
    }
    
    @objc func useBarrierAsync() {
//        那你啥时候改用 barrier 方法，啥时候不该用呢？
//
//        * 自定义串行队列 Custom Serial Queue: 没有必要在串行队列中使用，barrier 对于串行队列来说毫无用处，因为本来串行队列就是一次只会执行一个任务的。
//        * 全局并发队列 Global Concurrent Queue: 要小心使用。在全局队列中使用 barrier 可能不是太好，因为系统也会使用这个队列，一般你不会希望自己的操作垄断了这个队列从而导致系统调用的延迟。
//        * 自定义并发队列 Custom Concurrent Queue: 对于需要原子操作和访问临界区的代码，barrier 方法是最佳使用场景。任何你需要线程安全的实例，barrier 都是一个不错的选择。
        
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        for i in 0...3 {
            concurrentQueue.async {
                self.currentThreadSleep(Double(i))
                print("第一批：\(i.toEmoji)\(Thread.current)")
            }
        }
        
        for i in 0...3 {
            concurrentQueue.async(flags: .barrier)  {
                self.currentThreadSleep(Double(i))
                print("第二批：\(i.toEmoji)\(Thread.current)")
            }
        }
        
        let workItem = DispatchWorkItem(flags: .barrier) {
            print("\n第二批执行完毕后才会执行第三批\n\(Thread.current)\n")
        }
        
        concurrentQueue.async(execute: workItem)
        
        for i in 0...3 {
            concurrentQueue.async  {
                self.currentThreadSleep(Double(i))
                print("第三批：\(i.toEmoji)\(Thread.current)")
            }
        }
        
        print("😁😁😁不会阻塞主线程😁😁😁")
    }
    
    
    /// 循环执行
    @objc func useDispatchApply() {
        
        print("循环多次执行并行队列")
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.concurrentPerform(iterations: 3) { index in
                self.currentThreadSleep(Double(index))
                print("第\(index)次执行，\n\(Thread.current)\n")
            }
            DispatchQueue.main.async {
                self.ended()
            }
        }
    }
    
    //暂停和重启队列
    @objc func queueSuspendAndResume() {
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        concurrentQueue.suspend()   //将队列进行挂起
        concurrentQueue.async {
            print("任务执行, \(Thread.current)")
        }
        
        currentThreadSleep(2)
        concurrentQueue.resume()    //将挂起的队列进行唤醒
        ended()
    }
    
    
    /// 以加法运算的方式合并数据
    // http://www.tanhao.me/pieces/360.html/
    @objc func useDispatchSourceAdd() {
        var sum = 0     //手动计数的sum, 来模拟记录merge的数据
        
        let queue = globalQueue()
        //创建source
        let dispatchSource = DispatchSource.makeUserDataAddSource(queue: queue)
        
        dispatchSource.setEventHandler() {
            print("source中所有的数相加的和等于\(dispatchSource.data)")
            print("sum = \(sum)\n")
            sum = 0
            self.currentThreadSleep(0.3)
        }
        
        // DispatchQueue启动时默认状态是挂起的,创建完毕之后得主动恢复，否则事件不会被传送
        dispatchSource.resume()
        
        for i in 1...10 {
            sum += i
            print("i=\(i)")
            dispatchSource.add(data: UInt(i))
            currentThreadSleep(0.1)
        }
        ended()
    }
    
    
    /// 以或运算的方式合并数据
    @objc func useDispatchSourceOR() {
        
        var or = 0     //手动计数的sum, 来记录merge的数据
        
        let queue = globalQueue()
        
        //创建source
        let dispatchSource = DispatchSource.makeUserDataOrSource(queue: queue)
        
        dispatchSource.setEventHandler {
            print("source中所有的数相加的和等于\(dispatchSource.data)")
            print("or = \(or)\n")
            or = 0
            self.currentThreadSleep(0.3)
        }
        
        dispatchSource.resume()
        
        for i in 1...10 {
            or |= i
            print("i=\(i)")
            dispatchSource.or(data: UInt(i))
            currentThreadSleep(0.1)
        }
        
        print("\nsum = \(or)")
    }
    
    
    /// 使用DispatchSource创建定时器
    @objc func useDispatchSourceTimer() {
        let queue = globalQueue()
        
        let source = DispatchSource.makeTimerSource(queue: queue)
        
        // deadline 结束时间
        // interval 时间间隔
        // leeway  时间精度
        //            source.schedule(deadline: .now(), leeway: .nanoseconds(0))
        source.schedule(deadline: .now(), repeating: 1, leeway: .nanoseconds(0))
        //            source.scheduleRepeating(deadline: .now(), interval: 1, leeway: .nanoseconds(0))
        var timeout = 10    //倒计时时间
        
        //设置要处理的事件, 在我们上面创建的queue队列中进行执行
        
        source.setEventHandler {
            print(Thread.current)
            if timeout <= 0 {
                source.cancel()
            } else {
                print("\(timeout)s", Date())
                timeout -= 1
            }
        }
        //倒计时结束的事件
        source.setCancelHandler {
            print("倒计时结束")
        }
        source.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

extension Int {
    var toEmoji: String {
        let dict = [
            0: "0️⃣",
            1: "1️⃣",
            2: "2️⃣",
            3: "3️⃣",
            4: "4️⃣",
            5: "5️⃣",
            6: "6️⃣",
            7: "7️⃣",
            8: "8️⃣",
            9: "9️⃣",
        ]
        return dict[self] ?? self.description
    }
}
