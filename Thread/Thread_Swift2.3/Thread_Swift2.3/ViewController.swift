//
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        thread()
        //        autoThread()
        //        gcd()
        //        gcdGroup()
        operation()
        //        operationQueue()
        //        operationDependency()
        //        test()
        delay()
        
        //        semaphore()
        //        task()
    }
    
    func semaphore() {
        let semaphore = dispatch_semaphore_create(0) // 0表示没有资源
        
        //创建一个并发队列
        
        let queue = dispatch_queue_create("StudyBlocks", nil)
        
        //异步执行
        dispatch_async(queue) {
            for i in 0..<5 {
                print(">> i:", i)
            }
            print(dispatch_semaphore_signal(semaphore), semaphore.description)
        }
        
        //虽然是并发队列+异步函数, 但执行到wait的时候, 发现信号量为0, 所以会阻塞在这里. 直到异步函数里的for循环执行完毕, 然后dispatch_semaphore_signal(semaphore)函数将信号量+1, 才会执行wait后面的for循环.
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        for j in 0..<5 {
            print(">> Main Data:", j)
        }
    }
    
    let sem = dispatch_semaphore_create(2)
    
    func task() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), { () in
            self.task_first()
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), { () in
            self.task_second()
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), { () in
            self.task_third()
        })
    }
    
    func task_first(){
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        print("First task starting")
        sleep(1)
        print("First task is done")
        dispatch_semaphore_signal(sem)
    }
    
    func task_second(){
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        print("Second task starting")
        sleep(1)
        print("Second task is done")
        dispatch_semaphore_signal(sem)
    }
    
    func task_third(){
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        print("Thrid task starting")
        sleep(1)
        print("Thrid task is done")
        dispatch_semaphore_signal(sem)
    }
    
    func autoThread() {
        NSThread.detachNewThreadSelector(#selector(autoRun), toTarget: self, withObject: "1")
    }
    
    func autoRun(text: String) {
        for i in 0 ..< 10 {
            print(NSThread.currentThread(),"autoRun", i)
            NSThread.exit()
        }
    }
    
    func thread() {
        let thread = NSThread(target: self, selector: #selector(run), object: "1")
        thread.name = "thread"
        thread.start()
    }
    
    func run(text: String) {
        print(NSThread.currentThread(),"run")
    }
    
    func gcd() {
        //        print(NSThread.currentThread())
        //        let queue = dispatch_queue_create("gcdRun", nil)
        //        dispatch_async(queue) { () in
        //            print(NSThread.currentThread(),"gcd====")
        //        }
        //        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL)
        print("之前", NSThread.currentThread())
        dispatch_async(queue) { () in
            print("sync之前", NSThread.currentThread())
            dispatch_sync(queue, { () in
                print("sync", NSThread.currentThread())
            })
            print("sync之后", NSThread.currentThread())
        }
        print("之后", NSThread.currentThread())
    }
    
    func gcdGroup() {
        let group = dispatch_group_create()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_group_async(group, queue) { () in
            for _ in 0..<3 {
                print("1",NSThread.currentThread())
            }
        }
        
        dispatch_group_async(group, dispatch_get_main_queue()) { () in
            for _ in 0..<8 {
                print("main",NSThread.currentThread())
            }
        }
        
        dispatch_group_async(group, queue) { () in
            for _ in 0..<5 {
                print("2",NSThread.currentThread())
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () in
            print("完成", NSThread.currentThread())
        }
    }
    
    func operation() {
        let operation = NSBlockOperation { () in
            print(NSThread.currentThread())
        }
        
        for i in 0..<5 {
            operation.addExecutionBlock({ () in
                //               print("第\(i)次", NSThread.currentThread())
                NSLog("第%ld次 - %@", i, NSThread.currentThread())
            })
        }
        operation.start()
    }
    
    func operationQueue() {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        let operation = NSBlockOperation { () in
            NSLog("%@", NSThread.currentThread())
        }
        for i in 0..<5 {
            operation.addExecutionBlock({ () in
                //               print("第\(i)次", NSThread.currentThread())
                NSLog("第%ld次 - %@", i, NSThread.currentThread())
            })
        }
        queue.addOperation(operation)
    }
    
    func operationDependency() {
        //1.任务一：下载图片
        let operation1 = NSBlockOperation { () in
            NSLog("下载图片 - %@", NSThread.currentThread())
            NSThread.sleepForTimeInterval(1.0)
        }
        //2.任务二：打水印
        let operation2 = NSBlockOperation { () in
            NSLog("打水印   - %@", NSThread.currentThread())
            NSThread.sleepForTimeInterval(1.0)
        }
        //3.任务三：上传图片
        let operation3 = NSBlockOperation { () in
            NSLog("上传图片 - %@", NSThread.currentThread())
            NSThread.sleepForTimeInterval(1.0)
        }
        //4.设置依赖
        //        operation2.addDependency(operation1)//任务二依赖任务一
        operation3.addDependency(operation1)
        operation3.addDependency(operation2)    //任务三依赖任务二
        //5.创建队列并加入任务
        let queue = NSOperationQueue()
        queue.addOperations([operation3, operation2, operation1], waitUntilFinished: false)
    }
    
    func test() {
        var lastTicket = 10
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_sync(queue) { () in
            var ticket = lastTicket
            NSThread.sleepForTimeInterval(0.1)
            NSLog("%i----%@", ticket, NSThread.currentThread())
            ticket -= 1
            lastTicket = ticket
        }
        
        _ = NSBlockOperation { () in
            var ticket = lastTicket
            NSThread.sleepForTimeInterval(1)
            NSLog("%i----%@", ticket, NSThread.currentThread())
            ticket -= 1
            lastTicket = ticket
        }
    }
    
    func delay() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
                                  Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, queue) {
            print("2 秒后输出")
        }
        let del = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        print(del)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

