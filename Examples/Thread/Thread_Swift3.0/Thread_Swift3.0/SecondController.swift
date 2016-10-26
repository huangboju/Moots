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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
