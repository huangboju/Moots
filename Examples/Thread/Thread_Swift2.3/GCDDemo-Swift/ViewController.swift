//
//  ViewController.swift
//  GCDDemo-Swift
//
//  Created by Mr.LuDashi on 16/3/29.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //同步执行串行队列
    @IBAction func tapButton1(sender: AnyObject) {
        print("\n同步执行串行队列")
        performQueuesUseSynchronization(getSerialQueue("syn.serial.queue"))
    }
    
    //同步执行并行队列
    @IBAction func tapButton2(sender: AnyObject) {
        print("\n同步执行并行队列")
        performQueuesUseSynchronization(getConcurrentQueue("syn.concurrent.queue"))
    }
    
    @IBAction func tapButton3(sender: AnyObject) {
        print("\n异步执行串行队列")
        performQueuesUseAsynchronization(getSerialQueue("asyn.serial.queue"))
    }

    @IBAction func tapButton4(sender: AnyObject) {
        print("\n异步执行并行队列")
        performQueuesUseAsynchronization(getConcurrentQueue("asyn.concurrent.queue"))
        
    }
    
    /**
     延迟执行
     
     - parameter sender: 
     */
    @IBAction func tapButton5(sender: AnyObject) {
        deferPerform(1)
    }
    
    /**
     设置全局队列的优先级
     
     - parameter sender:
     */
    @IBAction func tapButton6(sender: AnyObject) {
        globalQueuePriority()
    }
    
    /**
     设置自建队列优先级
     
     - parameter sender:
     */
    @IBAction func tapButton7(sender: AnyObject) {
        setCustomeQueuePriority()
    }
    
    /**
     自动管理任务组
     
     - parameter sender:
     */
    @IBAction func tapButton8(sender: AnyObject) {
        dispatch_async(getGlobalQueue()) { 
            performGroupQueue()
            
        }
    }
    
    //手动管理任务组
    @IBAction func tapButton08(sender: AnyObject) {
        performGroupUseEnterAndleave()
    }
    
    /**
     信号量同步锁
     
     - parameter sender:
     */
    @IBAction func tapButton12(sender: AnyObject) {
        useSemaphoreLock()
    }

    
    
    /**
     使用任务栅栏
     
     - parameter sender:
     */
    @IBAction func tapButton9(sender: AnyObject) {
        useBarrierAsync()
    }
    
    @IBAction func tapButton10(sender: AnyObject) {
        useDispatchApply()
    }
    
    @IBAction func tapButton11(sender: AnyObject) {
        queueSuspendAndResume()
    }
    
    
    @IBAction func tapButton13(sender: AnyObject) {
        useDispatchSourceAdd()
    }
    
    @IBAction func tapButton14(sender: AnyObject) {
        useDispatchSourceOr()
    }
    
    
    @IBAction func tapButton15(sender: AnyObject) {
        useDispatchSourceTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

