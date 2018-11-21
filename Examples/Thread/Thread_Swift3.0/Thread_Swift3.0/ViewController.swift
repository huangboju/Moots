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
//        semaphoreGroup()
//        dispatchIO()
//        listenFile()

//        let formattedString = "A string"
//        let data = Array(formattedString.utf8).withUnsafeBytes {
//            DispatchData(bytes: $0)
//        }
        
//        serialQueue()
        setTargetQueue()
    }
    
    func setTargetQueue() {
        // 设置优先级
        
//        //给serialQueueHigh设定DISPATCH_QUEUE_PRIORITY_HIGH优先级
//        let serialQueueHigh = DispatchQueue(label: "cn.zeluli.serial1")
//        DispatchQueue.global(qos: .userInitiated).setTarget(queue: serialQueueHigh)
//
//        let serialQueueLow = DispatchQueue(label: "cn.zeluli.serial1")
//        DispatchQueue.global(qos: .utility).setTarget(queue: serialQueueLow)
//
//        serialQueueLow.async {
//            print("低：\(Thread.current)")
//        }
//
//        serialQueueHigh.async {
//            print("高：\(Thread.current)")
//        }
        
        // 执行层次
        let targetQueue  = DispatchQueue(label: "com.gcd.setTargetQueue2.targetSerialQueue")

        let serialQueue1 = DispatchQueue(label: "com.gcd.setTargetQueue2.serialQueue1", target: targetQueue)
        let serialQueue2 = DispatchQueue(label: "com.gcd.setTargetQueue2.serialQueue2", target: targetQueue)
        let serialQueue3 = DispatchQueue(label: "com.gcd.setTargetQueue2.serialQueue3", target: targetQueue)
        let serialQueue4 = DispatchQueue(label: "com.gcd.setTargetQueue2.serialQueue4", target: targetQueue)
        
        serialQueue1.async {
            print(1, Thread.current)
        }
        serialQueue2.async {
            print(2, Thread.current)
        }
        serialQueue3.async {
            print(3, Thread.current)
        }
        serialQueue4.async {
            print(4, Thread.current)
        }
    }

    func serialQueue() {
        let serialQueue = DispatchQueue(label: "", qos: .default)
        serialQueue.async {
            print(1)
        }
        print(2)
        serialQueue.async {
            print(3)
        }
        print(4)
    }

    func listenFile() {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!)
        let monitoredDirectoryFileDescriptor = open(fileURL.path, O_EVTONLY)

        let directoryMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredDirectoryFileDescriptor, eventMask: .write)

        directoryMonitorSource.setEventHandler {
            print("change file")
        }

        directoryMonitorSource.setCancelHandler {
            close(monitoredDirectoryFileDescriptor)
        }

        directoryMonitorSource.resume()
    }


    // http://www.jianshu.com/p/073bc1399677
    func dispatchIO() {

        let queue = DispatchQueue(label: "pipeQ")
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!)
        let fileDescriptor = open(fileURL.path, O_RDWR)

        let io = DispatchIO(type: .stream, fileDescriptor: fileDescriptor, queue: queue) { (error) in
            print(error)
        }

        io.setLimit(highWater: 1024)
        io.read(offset: 0, length: 8, queue: queue) { (done, data, error) in
            if let data = data {
                data.enumerateBytes { (aa, b, f) in
                    print(String(data: Data(buffer: aa), encoding: .utf8))
                }
                print("thread : \(Thread.current), data length : \(data.count), return value : \(error)")
                self.demoIOWrite(data: data)
            }
        }

//        DispatchIO.read(fromFileDescriptor: fileDescriptor, maxLength: -1, runningHandlerOn: queue) {
//            (data, num) -> Void in
//            print("thread : \(Thread.current), data length : \(data.count), return value : \(num)")
//
//            // 调用下面的异步写
//            self.demoIOWrite(data: data)
//        }
    }

    func demoIOWrite(data: DispatchData) {

        let queue = DispatchQueue(label: "demo.async_queue", attributes: .concurrent)

        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!)
        let fileDescriptor = open(fileURL.path, O_RDWR)
        DispatchIO.write(toFileDescriptor: fileDescriptor, data: data, runningHandlerOn: queue) {
            (data, num) -> Void in
            print("thread : \(Thread.current), data length : \(data), return value : \(num)")
        }
    }

    func semaphoreGroup() {
        let group = DispatchGroup()

        let semaphore = DispatchSemaphore(value: 10)

        let queue = DispatchQueue.global()

        for i in 0 ..< 100 {
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

    @objc func autoRun(text: String) {
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

    @objc func run(text: String) {
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

        for i in 0 ..< 5 {
            operation.addExecutionBlock {
                NSLog("第%ld次 - %@", i, Thread.current)
            }
        }

        operation.start()
    }


    func operationQueue() {

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        let operation = BlockOperation {
            NSLog("%@", Thread.current)
        }

        for i in 0 ..< 5 {
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

        let dispatchTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            print("2 秒后输出", Date(), Thread.current)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

