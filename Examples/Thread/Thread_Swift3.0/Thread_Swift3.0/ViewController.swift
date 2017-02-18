//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        semaphore()
//        multitasking()
//        quickThread()
//        thread()
//        gcd()
//        gcdGroup()
//        operation()
//        operationQueue()
//        operationDependency()
//        test()
//        delay()
        semaphoreGroup()
    }
    
    func semaphoreGroup() {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 10)
        
        let queue = DispatchQueue.global()
        for i in 0..<100 {
            print(semaphore.wait(timeout: .distantFuture))
            queue.async(group: group) {
                print(i)
                Thread.sleep(forTimeInterval: 2)
                semaphore.signal()
            }
        }
        group.notify(queue: queue) { 
                print("😄")
        }
    }
    
    func semaphore() {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue(label: "StudyBlocks")
        queue.async {
            for i in 0..<5 {
                print(">> i:", i)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        for j in 0..<5 {
            print(">> Main Data:", j)
        }
    }
    
    let sem = DispatchSemaphore(value: 2)
    
    func multitasking() {
        DispatchQueue.global().async {
            self.task_first()
        }
        
        DispatchQueue.global().async {
            self.task_second()
        }
        
        DispatchQueue.global().async {
            self.task_third()
        }
    }
    
    func task_first(){
        sem.wait()
        print("First task starting")
        sleep(1)
        print("First task is done")
        sem.signal()
    }
    
    func task_second(){
        sem.wait()
        print("Second task starting")
        sleep(1)
        print("Second task is done")
        sem.signal()
    }
    
    func task_third(){
        sem.wait()
        print("Thrid task starting")
        sleep(1)
        print("Thrid task is done", #function)
        sem.signal()
    }
    
    func quickThread() {
         Thread.detachNewThreadSelector(#selector(autoRun), toTarget: self, with: "1")
    }
    
    func autoRun(text: String) {
        for i in 0 ..< 10 {
            print(Thread.current,"autoRun", i)
            Thread.exit()
        }
    }
    
    func thread() {
        let thread = Thread(target: self, selector: #selector(run), object: "1")
        thread.name = "myThread"
        thread.start()
    }
    
    func run(text: String) {
        print(Thread.current.name as Any,"run")
    }
    
    func gcd() {
        let queue = DispatchQueue(label: "myQueue")
        print("之前", Thread.current)
        queue.async {
            print("sync之前", Thread.current)
            queue.sync {
                print("sync", Thread.current)
            }
            print("sync之后", Thread.current)
        }
        print("之后", Thread.current)
    }
    
    func gcdGroup() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        queue.async(group: group) {
            for _ in 0..<3 {
                print("1",Thread.current)
            }
        }
        
        queue.async(group: group) {
            for _ in 0..<8 {
                print("2", Thread.current)
            }
        }
        
        DispatchQueue.main.async(group: group) {
            for _ in 0..<5 {
                print("main", Thread.current)
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("完成", Thread.current)
        }
    }
    
    func operation() {
        let operation = BlockOperation { 
            print(Thread.current)
        }
        
        for i in 0..<5 {
            operation.addExecutionBlock {
                NSLog("第%ld次 - %@", i, Thread.current)
            }
        }
        
        operation.start()
    }
    
    func operationQueue() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let operation = BlockOperation {
            NSLog("%@", Thread.current)
        }
        for i in 0..<5 {
            operation.addExecutionBlock {
                NSLog("第%ld次 - %@", i, Thread.current)
            }
        }
        queue.addOperation(operation)
    }
    
    func operationDependency() {
        //1.任务一：下载图片
        let operation1 = BlockOperation {
            NSLog("下载图片 - %@", Thread.current)
            Thread.sleep(forTimeInterval: 1.0)
        }
        //2.任务二：打水印
        let operation2 = BlockOperation {
            NSLog("打水印   - %@", Thread.current)
            Thread.sleep(forTimeInterval: 1.0)
        }
        //3.任务三：上传图片
        let operation3 = BlockOperation {
            NSLog("上传图片 - %@", Thread.current)
            Thread.sleep(forTimeInterval: 1.0)
        }
        operation2.addDependency(operation1)//任务二依赖任务一
        operation3.addDependency(operation2)    //任务三依赖任务二
        //5.创建队列并加入任务
        let queue = OperationQueue()
        queue.addOperations([operation3, operation2, operation1], waitUntilFinished: false)
    }
    
    func test() {
        var lastTicket = 10
        DispatchQueue.global().async {
            var ticket = lastTicket
            Thread.sleep(forTimeInterval: 0.1)
            NSLog("%i----%@", ticket, Thread.current)
            ticket -= 1
            lastTicket = ticket
        }
        
        let operation = BlockOperation { () in
            var ticket = lastTicket
            Thread.sleep(forTimeInterval: 1)
            NSLog("%i----%@", ticket, Thread.current)
            ticket -= 1
            lastTicket = ticket
        }
        operation.start()
    }
    
    func delay() {
        
        let time: TimeInterval = 2.0
        let delay = DispatchTime.now() + time
        DispatchQueue.global().asyncAfter(deadline: delay) {
            print("global 2 秒后输出", Thread.current)
        }
        print(Date())
        let dispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            print("2 秒后输出", Date(), Thread.current)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

