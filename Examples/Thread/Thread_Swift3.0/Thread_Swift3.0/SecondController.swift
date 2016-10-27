//
//  SecondController.swift
//  Thread_Swift3.0
//
//  Created by 伯驹 黄 on 2016/10/26.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Eureka
import UIKit

class SecondController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tags = [
            [
                "同步执行串行队列",
                "同步执行并行队列",
                "异步执行串行队列",
                "异步执行并行队列",
                "延迟执行",
                "设置全局队列的优先级",
                "设置自建队列优先级",
                "自动执行任务组",
                "手动执行任务组",
                "使用信号量添加同步锁"
            ],
            [
                "使用Apply循环执行",
                "暂停和重启队列",
                "使用任务隔离栅栏",
                "dispatch源,ADD",
                "dispatch源,OR",
                "dispatch源,定时器"
            ]
        ]
        
        for (i, strs) in tags.enumerated() {
            form.append(Section("组\(i)"))
            for tag in strs {
                form[i].append(createRow(using: tag))
            }
        }
    }
    
    func createRow(using tag: String?) -> ButtonRow {
        return ButtonRow(tag) {
            $0.title = $0.tag
            $0.onCellSelection { [weak self] (cell, row) in
                guard let strongSelf = self else { return }
                strongSelf.action(tag: row.tag!)
            }
        }
    }
    
    func action(tag: String) {
        print(tag)
        print("********************************************************")
        switch tag {
        case "同步执行串行队列":
            performQueuesUseSynchronization(getSerialQueue("syn.serial.queue"))
        case "同步执行并行队列":   performQueuesUseSynchronization(getConcurrentQueue("syn.concurrent.queue"))
        case "异步执行串行队列":
            performQueuesUseAsynchronization(getSerialQueue("asyn.serial.queue"))
        case "异步执行并行队列":
            performQueuesUseAsynchronization(getConcurrentQueue("asyn.concurrent.queue"))
        case "延迟执行":
                deferPerform(1)
        case "设置全局队列的优先级":
            globalQueuePriority()
        case "设置自建队列优先级":
            setCustomeQueuePriority()
        case "自动执行任务组":
            getGlobalQueue().async {
                self.performGroupQueue()
            }
        case "手动执行任务组":
            performGroupUseEnterAndleave()
        case "使用信号量添加同步锁":
            useSemaphoreLock()
        case "使用Apply循环执行":
            useDispatchApply()
        case "暂停和重启队列":
            queueSuspendAndResume()
        case "使用任务隔离栅栏":
            useBarrierAsync()
        case "dispatch源,ADD":
            useDispatchSourceAdd()
        case "dispatch源,OR":
            useDispatchSourceOr()
        case "dispatch源,定时器":
            useDispatchSourceTimer()
        default:
            break
        }
        print("********************************************************")
    }
    
    func performQueuesUseSynchronization(_ queue: DispatchQueue) {
        for i in 0..<3 {
            queue.sync() {
                currentThreadSleep(1)
                print("当前执行线程：\(Thread.current)")
                print("执行\(i)")
            }
            print("\(i)执行完毕")
        }
        print("所有队列使用同步方式执行完毕")
    }

    /**
     使用dispatch_async在当前线程中执行队列
     */
    func performQueuesUseAsynchronization(_ queue: DispatchQueue) -> Void {
        
        //一个串行队列，用于同步执行
        let serialQueue = getSerialQueue("serialQueue")
        for i in 0..<3 {
            queue.async {
                self.currentThreadSleep(Double(arc4random()%3))
                let currentThread = Thread.current
                serialQueue.sync {              //同步锁
                    print("Sleep的线程\(currentThread)")
                    print("当前输出内容的线程\(Thread.current)")
                    print("执行\(i):\(queue)\n")
                }
            }
            print("\(i)添加完毕\n")
        }
        print("使用异步方式添加队列")
    }
    
    func currentThreadSleep(_ timer: TimeInterval) {
        Thread.sleep(forTimeInterval: timer)
    }
    
    /**
     创建串行队列
     */
    func getSerialQueue(_ label: String) -> DispatchQueue {
        return DispatchQueue(label: label)
    }
    
    /**
     创建并行队列
     */
    func getConcurrentQueue(_ label: String) -> DispatchQueue {
        return DispatchQueue(label: label, attributes: .concurrent)
    }
    
    /**
     延迟执行
     */
    func deferPerform(_ time: Int) {
        let queue = getGlobalQueue()
        let delayTime = DispatchTime.now() + DispatchTimeInterval.seconds(time)
        queue.asyncAfter(deadline: delayTime) {
            print("执行线程：\(Thread.current)\ndispatch_time: 延迟\(time)秒执行\n")
        }
        
        //dispatch_walltime用于计算绝对时间,而dispatch_walltime是根据挂钟来计算的时间，即使设备睡眠了，他也不会睡眠。
        let nowInterval = Date().timeIntervalSince1970
        let nowStruct = timespec(tv_sec: Int(nowInterval), tv_nsec: 0)
        let delayWalltime = DispatchWallTime(timespec: nowStruct)
        queue.asyncAfter(wallDeadline: delayWalltime) {
            print("执行线程：\(Thread.current)\ndispatch_walltime: 延迟\(time)秒执行\n")
        }
        print(NSEC_PER_SEC) //一秒有多少纳秒
    }
    
    
    // http://www.jianshu.com/p/7efbecee6af8
    /*
     * DISPATCH_QUEUE_PRIORITY_HIGH:         .userInitiated
     * DISPATCH_QUEUE_PRIORITY_DEFAULT:      .default
     * DISPATCH_QUEUE_PRIORITY_LOW:          .utility
     * DISPATCH_QUEUE_PRIORITY_BACKGROUND:   .background
     */
    
    func getGlobalQueue(qos: DispatchQoS.QoSClass = .default) -> DispatchQueue {
        return DispatchQueue.global(qos: qos)
    }
    
    /**
     全局队列的优先级关系
     */
    func globalQueuePriority() {
        //高 > 默认 > 低 > 后台
        
        let queueHeight = getGlobalQueue(qos: .userInitiated)
        let queueDefault = getGlobalQueue()
        let queueLow = getGlobalQueue(qos: .utility)
        let queueBackground = getGlobalQueue(qos: .background)
        
        
        //优先级不是绝对的，大体上会按这个优先级来执行。 一般都是使用默认（default）优先级
        queueLow.async {
            print("Low：\(Thread.current)")
        }
        
        queueBackground.async {
            print("Background：\(Thread.current)")
        }
        
        queueDefault.async {
            print("Default：\(Thread.current)")
        }
        
        queueHeight.async {
            print("High：\(Thread.current)")
        }
    }
    
    /**
     给串行队列或者并行队列设置优先级
     */
    func setCustomeQueuePriority() {
        //优先级的执行顺序也不是绝对的
        
        //给serialQueueHigh设定DISPATCH_QUEUE_PRIORITY_HIGH优先级
        let serialQueueHigh = getSerialQueue("cn.zeluli.serial1")
        serialQueueHigh.setTarget(queue: getGlobalQueue(qos: .userInitiated))
        
        let serialQueueLow = getSerialQueue("cn.zeluli.serial1")
        serialQueueLow.setTarget(queue: getGlobalQueue(qos: .utility))
        
        
        serialQueueLow.async {
            print("低：\(Thread.current)")
        }
        
        serialQueueHigh.async {
            print("高：\(Thread.current)")
        }
    }
    
    func performGroupQueue() {
        print("\n任务组自动管理：")
        
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
            print("所有的任务组执行完毕！\n")
        }
        
        print("异步执行测试，不会阻塞当前线程")
    }
    
    /**
     * 使用enter与leave手动管理group与queue
     */
    func performGroupUseEnterAndleave() {
        print("\n任务组手动管理：")
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        let group = DispatchGroup()
        
        //将group与queue进行手动关联和管理，并且自动执行
        for i in 1...3 {
            group.enter() //进入队列组
            concurrentQueue.async {
                self.currentThreadSleep(1)
                print("任务\(i)执行完毕\n")
                group.leave()                 //离开队列组
            }
        }
        
        _ = group.wait(timeout: .distantFuture) //阻塞当前线程，直到所有任务执行完毕
        print("任务组执行完毕")
        
        group.notify(queue: concurrentQueue) {
            print("手动管理的队列执行OK")
        }
    }
    
    //信号量同步锁
    func useSemaphoreLock() {
        
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        
        //创建信号量
        let semaphoreLock = DispatchSemaphore(value: 1)
        
        var testNumber = 0
        
        for index in 1...10 {
            concurrentQueue.async {
                _ = semaphoreLock.wait(timeout: .distantFuture) //上锁
                
                testNumber += 1
                self.currentThreadSleep(Double(1))
                print(Thread.current)
                print("第\(index)次执行: testNumber = \(testNumber)\n")
                
                semaphoreLock.signal()                      //开锁
                
            }
        }
        
        print("异步执行测试\n")
    }
    
    func useBarrierAsync() {
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        for i in 0...3 {
            concurrentQueue.async {
                self.currentThreadSleep(Double(i))
                print("第一批：\(i)\(Thread.current)")
            }
        }
        
        let workItem = DispatchWorkItem(flags: .barrier) {
            print("\n第一批执行完毕后才会执行第二批\n\(Thread.current)\n")
        }
        
        concurrentQueue.async(execute: workItem)
        
        
        for i in 0...3 {
            concurrentQueue.async {
                self.currentThreadSleep(Double(i))
                print("第二批：\(i)\(Thread.current)")
            }
        }
        
        print("异步执行测试\n")
    }
    
    /**
     循环执行
     */
    func useDispatchApply() {
        
        print("循环多次执行并行队列")
        _ = getConcurrentQueue("cn.zeluli")
        //会阻塞当前线程, 但concurrentQueue队列会在新的线程中执行
        DispatchQueue.concurrentPerform(iterations: 2) { (index) in
            currentThreadSleep(Double(index))
            print("第\(index)次执行，\n\(Thread.current)\n")
        }
        
        print("\n\n循环多次执行串行队列")
        _ = getSerialQueue("cn.zeluli")
        //会阻塞当前线程, serialQueue队列在当前线程中执行
        DispatchQueue.concurrentPerform(iterations: 2) { (index) in
            currentThreadSleep(Double(index))
            print("第\(index)次执行，\n\(Thread.current)\n")
        }
    }
    
    //暂停和重启队列
    func queueSuspendAndResume() {
        let concurrentQueue = getConcurrentQueue("cn.zeluli")
        
        concurrentQueue.suspend()   //将队列进行挂起
        concurrentQueue.async { 
            print("任务执行")
        }
        
        currentThreadSleep(2)
        concurrentQueue.resume()    //将挂起的队列进行唤醒
    }
    
    /**
     以加法运算的方式合并数据
     */
    func useDispatchSourceAdd() {
        var sum = 0     //手动计数的sum, 来模拟记录merge的数据
        
        let queue = getGlobalQueue()
        //创建source
        let dispatchSource = DispatchSource.makeUserDataAddSource(queue: queue)
        
        dispatchSource.setEventHandler() {
            print("source中所有的数相加的和等于\(dispatchSource.data)")
            print("sum = \(sum)\n")
            sum = 0
            self.currentThreadSleep(0.3)
        }
        
        dispatchSource.resume()
        
        for i in 1...10 {
            sum += i
            print(i)
            dispatchSource.add(data: UInt(i))
            currentThreadSleep(0.1)
        }
    }
    
    /**
     以或运算的方式合并数据
     */
    func useDispatchSourceOr() {
        
        var or = 0     //手动计数的sum, 来记录merge的数据
        
        let queue = getGlobalQueue()
        
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
            print(i)
            dispatchSource.or(data: UInt(i))
            currentThreadSleep(0.1)
            
        }
        
        print("\nsum = \(or)")
    }
    
    /**
     使用dispatch_source创建定时器
     */
    func useDispatchSourceTimer() {
        let queue = getGlobalQueue()
        
        let source = DispatchSource.makeTimerSource(queue: queue)
        
        //设置间隔时间，从当前时间开始，允许偏差0纳秒
        source.scheduleOneshot(deadline: DispatchTime.now(), leeway: DispatchTimeInterval.nanoseconds(1))

        var timeout = 10    //倒计时时间
        
        //设置要处理的事件, 在我们上面创建的queue队列中进行执行
        
        source.setEventHandler {
            print(Thread.current)
            if(timeout <= 0) {
                source.cancel()
            } else {
                print("\(timeout)s")
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
