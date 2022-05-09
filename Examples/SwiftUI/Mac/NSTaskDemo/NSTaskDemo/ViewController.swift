//
//  ViewController.swift
//  NSTaskDemo
//
//  Created by alexiuce  on 2017/7/27.
//  Copyright © 2017年 alexiuce . All rights reserved.
//

import Cocoa

let kSelectedFilePath = "userSelectedPath"


class ViewController: NSViewController {

    @IBOutlet weak var repoPath: NSTextField!           // git 仓库path
    @IBOutlet weak var savePath: NSTextField!           // 本地保存路径
    @IBOutlet var showInfoTextView: NSTextView!     // 显示结果内容
    
    var isLoadingRepo  = false                                 // 记录是否正在加载中..
    
    var outputPipe = Pipe()
    
    var task : Process?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfoTextView.textColor = NSColor.white
        // Do any additional setup after loading the view.
    }

// 选择保存路径
    @IBAction func selectPath(_ sender: NSButton) {
        // 1. 创建打开文档面板对象
        let openPanel = NSOpenPanel()
        // 2. 设置确认按钮文字
        openPanel.prompt = "Select"
        // 3. 设置禁止选择文件
        openPanel.canChooseFiles = true
        // 4. 设置可以选择目录
        openPanel.canChooseDirectories = true
        // 5. 弹出面板框
        openPanel.beginSheetModal(for: self.view.window!) { (result) in
            // 6. 选择确认按钮
            if result == .OK {
                // 7. 获取选择的路径
                self.savePath.stringValue = (openPanel.directoryURL?.path)!
                // 8. 保存用户选择路径(为了可以在其他地方有权限访问这个路径,需要对用户选择的路径进行保存)
                UserDefaults.standard.setValue(openPanel.url?.path, forKey: kSelectedFilePath)
                UserDefaults.standard.synchronize()
            }
            // 9. 恢复按钮状态
            sender.state = .off
        }
    }
    // clone按钮事件:(这里名称用了pull,不想改了,大家自己使用的时候,最好使用clone来命名)
    @IBAction func startPull(_ sender: NSButton) {
//        guard  let executePath = UserDefaults.standard.value(forKey: kSelectedFilePath) as? String else {
//            print("no selected path")
//            return
//        }
        let executePath = "/Users/jourhuang/Desktop/Test"
        guard repoPath.stringValue != "" else {return}
        if isLoadingRepo {return}   // 如果正在执行,则返回
        isLoadingRepo = true   // 设置正在执行标记
        task = Process()     // 创建NSTask对象
        // 设置task
        task?.launchPath = "/bin/bash"    // 执行路径(这里是需要执行命令的绝对路径)
        // 设置执行的具体命令
        task?.arguments = ["-c","cd \(executePath); git clone \(repoPath.stringValue)"]
        
        task?.terminationHandler = { proce in              // 执行结束的闭包(回调)
            self.isLoadingRepo = false    // 恢复执行标记
            print("finished")
            self.showFiles()
        }
        captureStandardOutputAndRouteToTextView(task!)
        task?.launch()                // 开启执行
        task?.waitUntilExit()       // 阻塞直到执行完毕
    }
    
    // 显示目录文档列表
    fileprivate func showFiles() {
        guard  let executePath = UserDefaults.standard.value(forKey: kSelectedFilePath) as? String else {
            print("no selected path")
            return
        }
       let listTask = Process()     // 创建NSTask对象
        // 设置task
        listTask.launchPath = "/bin/bash"    // 执行路径(这里是需要执行命令的绝对路径)
        // 设置执行的具体命令
       
        listTask.arguments = ["-c","cd \(executePath + "/" + (repoPath.stringValue as NSString).lastPathComponent); ls "]
    
        captureStandardOutputAndRouteToTextView(listTask)
        
        listTask.launch()                // 开启执行
        listTask.waitUntilExit()
        
    }
    
}

extension ViewController{
    fileprivate func captureStandardOutputAndRouteToTextView(_ task:Process) {
        //1. 设置标准输出管道
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        
        //2. 在后台线程等待数据和通知
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        //3. 接受到通知消息
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) { notification in
            
            //4. 获取管道数据 转为字符串
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            if outputString != ""{
                //5. 在主线程处理UI
                DispatchQueue.main.async(execute: {
                    let previousOutput = self.showInfoTextView.string
                    let nextOutput = previousOutput + "\n" + outputString
                    self.showInfoTextView.string = nextOutput
                    // 滚动到可视位置
                    let range = NSRange(location:nextOutput.count,length:0)
                    self.showInfoTextView.scrollRangeToVisible(range)
                })
            }            
            //6. 继续等待新数据和通知
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }

}



