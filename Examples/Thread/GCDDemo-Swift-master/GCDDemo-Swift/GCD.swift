//
//  GCD.swift
//  GCDDemo-Swift
//
//  Created by Mr.LuDashi on 16/3/29.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation

/**
 获取当前线程
 
 - returns: NSThread
 */
func getCurrentThread() -> NSThread {
    let currentThread = NSThread.currentThread()
    return currentThread
}

/**
 当前线程休眠
 
 - parameter timer: 休眠时间/单位：s
 */
func currentThreadSleep(timer: NSTimeInterval) -> Void {
    NSThread.sleepForTimeInterval(timer)
    
    //或者使用
    //sleep(UInt32(timer))
}



/**
 获取主队列
 
 - returns: dispatch_queue_t
 */
func getMainQueue() -> dispatch_queue_t {
    return dispatch_get_main_queue();
}


/**
 获取全局队列, 并指定优先级
 
 - parameter priority: 优先级
 DISPATCH_QUEUE_PRIORITY_HIGH        高
 DISPATCH_QUEUE_PRIORITY_DEFAULT     默认
 DISPATCH_QUEUE_PRIORITY_LOW         低
 DISPATCH_QUEUE_PRIORITY_BACKGROUND  后台
 - returns: 全局队列
 */
func getGlobalQueue(priority: dispatch_queue_priority_t = DISPATCH_QUEUE_PRIORITY_DEFAULT) -> dispatch_queue_t {
    return dispatch_get_global_queue(priority, 0)
}



/**
 创建并行队列
 
 - parameter label: 并行队列的标记
 
 - returns: 并行队列
 */
func getConcurrentQueue(label: String) -> dispatch_queue_t {
    return dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT)
}


/**
 创建串行队列
 
 - parameter label: 串行队列的标签
 
 - returns: 串行队列
 */
func getSerialQueue(label: String) -> dispatch_queue_t {
    return dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL)
}


/**
 使用dispatch_sync在当前线程中执行队列
 
 - parameter queue: 队列
 */
func performQueuesUseSynchronization(queue: dispatch_queue_t) -> Void {
    
    for i in 0..<3 {
        dispatch_sync(queue) {
            currentThreadSleep(1)
            print("当前执行线程：\(getCurrentThread())")
            print("执行\(i)")
        }
        print("\(i)执行完毕")
    }
    print("所有队列使用同步方式执行完毕")
}

/**
 使用dispatch_async在当前线程中执行队列
 
 - parameter queue: 队列
 */
func performQueuesUseAsynchronization(queue: dispatch_queue_t) -> Void {
    
    //一个串行队列，用于同步执行
    let serialQueue = getSerialQueue("serialQueue")
    
    for i in 0..<3 {
        dispatch_async(queue) {
            currentThreadSleep(Double(arc4random()%3))
            let currentThread = getCurrentThread()
            
            dispatch_sync(serialQueue, {              //同步锁
                print("Sleep的线程\(currentThread)")
                print("当前输出内容的线程\(getCurrentThread())")
                print("执行\(i):\(queue)\n")
            })
        }
        
        print("\(i)添加完毕\n")
    }
    print("使用异步方式添加队列")
}


/**
 延迟执行
 
 - parameter time: 延迟执行的时间
 */
func deferPerform(time: Double) -> Void {
    
    //dispatch_time用于计算相对时间,当设备睡眠时，dispatch_time也就跟着睡眠了
    let delayTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, getGlobalQueue()) {
        print("执行线程：\(getCurrentThread())\ndispatch_time: 延迟\(time)秒执行\n")
    }
    
    //dispatch_walltime用于计算绝对时间,而dispatch_walltime是根据挂钟来计算的时间，即使设备睡眠了，他也不会睡眠。
    let nowInterval = NSDate().timeIntervalSince1970
    var nowStruct = timespec(tv_sec: Int(nowInterval), tv_nsec: 0)
    let delayWalltime = dispatch_walltime(&nowStruct, Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(delayWalltime, getGlobalQueue()) {
        print("执行线程：\(getCurrentThread())\ndispatch_walltime: 延迟\(time)秒执行\n")
    }
    
    print(NSEC_PER_SEC) //一秒有多少纳秒
}

/**
 全局队列的优先级关系
 */
func globalQueuePriority() {
    //高 > 默认 > 低 > 后台
    let queueHeight: dispatch_queue_t = getGlobalQueue(DISPATCH_QUEUE_PRIORITY_HIGH)
    let queueDefault: dispatch_queue_t = getGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT)
    let queueLow: dispatch_queue_t = getGlobalQueue(DISPATCH_QUEUE_PRIORITY_LOW)
    let queueBackground: dispatch_queue_t = getGlobalQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND)
   
    
    //优先级不是绝对的，大体上会按这个优先级来执行。 一般都是使用默认（default）优先级
    dispatch_async(queueLow) {
        print("Low：\(getCurrentThread())")
    }
    
    dispatch_async(queueBackground) {
        print("Background：\(getCurrentThread())")
    }
    
    dispatch_async(queueDefault) {
        print("Default：\(getCurrentThread())")
    }
    
    dispatch_async(queueHeight) {
        print("High：\(getCurrentThread())")
    }
}

/**
 给串行队列或者并行队列设置优先级
 */
func setCustomeQueuePriority() {
    //优先级的执行顺序也不是绝对的
    
    //给serialQueueHigh设定DISPATCH_QUEUE_PRIORITY_HIGH优先级
    let serialQueueHigh = getSerialQueue("cn.zeluli.serial1")
    dispatch_set_target_queue(serialQueueHigh, getGlobalQueue(DISPATCH_QUEUE_PRIORITY_HIGH))
    
    let serialQueueLow = getSerialQueue("cn.zeluli.serial1")
    dispatch_set_target_queue(serialQueueLow, getGlobalQueue(DISPATCH_QUEUE_PRIORITY_LOW))
    
    
    dispatch_async(serialQueueLow) {
        print("低：\(getCurrentThread())")
    }
    
    dispatch_async(serialQueueHigh) {
        print("高：\(getCurrentThread())")
    }
}

/**
 一组队列执行完毕后在执行需要执行的东西，可以使用dispatch_group来执行队列
 */
func performGroupQueue() {
    print("\n任务组自动管理：")
    
    let concurrentQueue: dispatch_queue_t = getConcurrentQueue("cn.zeluli")
    let group: dispatch_group_t = dispatch_group_create()
    
    //将group与queue进行管理，并且自动执行
    for i in 1...3 {
        dispatch_group_async(group, concurrentQueue) {
            currentThreadSleep(1)
            print("任务\(i)执行完毕\n")
        }
    }
    
    //队列组的都执行完毕后会进行通知
    dispatch_group_notify(group, getMainQueue()) {
        print("所有的任务组执行完毕！\n")
    }

    print("异步执行测试，不会阻塞当前线程")
}

/**
 * 使用enter与leave手动管理group与queue
 */
func performGroupUseEnterAndleave() {
    print("\n任务组手动管理：")
    let concurrentQueue: dispatch_queue_t = getConcurrentQueue("cn.zeluli")
    let group: dispatch_group_t = dispatch_group_create()
    
    //将group与queue进行手动关联和管理，并且自动执行
    for i in 1...3 {
        dispatch_group_enter(group)                     //进入队列组
        
        dispatch_async(concurrentQueue, {
            currentThreadSleep(1)
            print("任务\(i)执行完毕\n")
            
            dispatch_group_leave(group)                 //离开队列组
        })
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)   //阻塞当前线程，直到所有任务执行完毕
    print("任务组执行完毕")
    
    dispatch_group_notify(group, concurrentQueue) {
        print("手动管理的队列执行OK")
    }
}

//信号量同步锁
func useSemaphoreLock() {
    
    let concurrentQueue = getConcurrentQueue("cn.zeluli")
    
    //创建信号量
    let semaphoreLock: dispatch_semaphore_t = dispatch_semaphore_create(1)
    
    var testNumber = 0
    
    for index in 1...10 {
        dispatch_async(concurrentQueue, {
            dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER) //上锁
            
            testNumber += 1
            currentThreadSleep(Double(1))
            print(getCurrentThread())
            print("第\(index)次执行: testNumber = \(testNumber)\n")
            
            dispatch_semaphore_signal(semaphoreLock)                      //开锁
            
        })
    }
    
    print("异步执行测试\n")
}




/**
 循环执行
 */
func useDispatchApply() {
    
    print("循环多次执行并行队列")
    let concurrentQueue: dispatch_queue_t = getConcurrentQueue("cn.zeluli")
    //会阻塞当前线程, 但concurrentQueue队列会在新的线程中执行
    dispatch_apply(3, concurrentQueue) { (index) in
        
        currentThreadSleep(Double(index))
        print("第\(index)次执行，\n\(getCurrentThread())\n")
    }
    
    
    
    print("\n\n循环多次执行串行队列")
    let serialQueue: dispatch_queue_t = getSerialQueue("cn.zeluli")
    //会阻塞当前线程, serialQueue队列在当前线程中执行
    dispatch_apply(3, serialQueue) { (index) in
        
        currentThreadSleep(Double(index))
        print("第\(index)次执行，\n\(getCurrentThread())\n")
    }
}

//暂停和重启队列
func queueSuspendAndResume() {
    let concurrentQueue = getConcurrentQueue("cn.zeluli")
    
    dispatch_suspend(concurrentQueue)   //将队列进行挂起
    dispatch_async(concurrentQueue) { 
        print("任务执行")
    }
    
    currentThreadSleep(2)
    dispatch_resume(concurrentQueue)    //将挂起的队列进行唤醒
}

/**
 使用给队列加栅栏
 */
func useBarrierAsync() {
    let concurrentQueue: dispatch_queue_t = getConcurrentQueue("cn.zeluli")
    for i in 0...3 {
        dispatch_async(concurrentQueue) {
            currentThreadSleep(Double(i))
            print("第一批：\(i)\(getCurrentThread())")
        }
    }
    
    
    dispatch_barrier_async(concurrentQueue) {

        print("\n第一批执行完毕后才会执行第二批\n\(getCurrentThread())\n")
    }
    
    
    for i in 0...3 {
        dispatch_async(concurrentQueue) {
            currentThreadSleep(Double(i))
            print("第二批：\(i)\(getCurrentThread())")
        }
    }
    
    print("异步执行测试\n")
}

/**
 以加法运算的方式合并数据
 */
func useDispatchSourceAdd() {
    var sum = 0     //手动计数的sum, 来模拟记录merge的数据
    
    let queue = getGlobalQueue()
    
    //创建source
    let dispatchSource:dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue)
    
    dispatch_source_set_event_handler(dispatchSource) {
        print("source中所有的数相加的和等于\(dispatch_source_get_data(dispatchSource))")
        print("sum = \(sum)\n")
        sum = 0
       currentThreadSleep(0.3)
    }

    dispatch_resume(dispatchSource)
    
    for i in 1...10 {
        sum += i
        print(i)
        dispatch_source_merge_data(dispatchSource, UInt(i))
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
    let dispatchSource:dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_OR, 0, 0, queue)
    
    dispatch_source_set_event_handler(dispatchSource) {
        print("source中所有的数相加的和等于\(dispatch_source_get_data(dispatchSource))")
        print("or = \(or)\n")
        or = 0
        currentThreadSleep(0.3)
        
    }
    
    dispatch_resume(dispatchSource)
    
    for i in 1...10 {
        or |= i
        print(i)
        dispatch_source_merge_data(dispatchSource, UInt(i))
        
        currentThreadSleep(0.1)
        
    }
    
    print("\nsum = \(or)")
}

/**
 使用dispatch_source创建定时器
 */
func useDispatchSourceTimer() {
    let queue: dispatch_queue_t = getGlobalQueue()
    let source: dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
   
    //设置间隔时间，从当前时间开始，允许偏差0纳秒
    dispatch_source_set_timer(source, DISPATCH_TIME_NOW, UInt64(1 * NSEC_PER_SEC), 0)
    
    var timeout = 10    //倒计时时间
    
    //设置要处理的事件, 在我们上面创建的queue队列中进行执行
    dispatch_source_set_event_handler(source) {
        print(getCurrentThread())
        if(timeout <= 0) {
            dispatch_source_cancel(source)
        } else {
            print("\(timeout)s")
            timeout -= 1
        }
    }
    
    //倒计时结束的事件
    dispatch_source_set_cancel_handler(source) { 
        print("倒计时结束")
    }
    dispatch_resume(source)
}


