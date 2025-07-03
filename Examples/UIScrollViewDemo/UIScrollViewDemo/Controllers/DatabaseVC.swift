//
//  DatabaseVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2025/7/2.
//  Copyright © 2025 伯驹 黄. All rights reserved.
//

import Foundation
import SQLite

typealias Expression = SQLite.Expression

// 消息结构体
struct Message: Codable {
    let id: String
    let content: String
    let timestamp: Date
    let isRead: Bool
}

// 用户结构体，包含嵌套的消息
struct User: Codable {
    let name: String
    let email: String
    let age: Int
    let lastMessage: Message  // 嵌套的消息结构体
}

class DatabaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        testChatDatabase()
    }
    
    func testChatDatabase() {
        do {
            guard let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first else {
                return
            }
            let db = try Connection("\(path)/users.sqlite3")
            let users = Table("users")

            // 创建表，注意 lastMessage 列是 TEXT 类型用于存储 JSON
            try db.run(users.create(ifNotExists: true) { t in
                t.column(Expression<String>("userId"))
                t.column(Expression<String>("name"))
                t.column(Expression<String>("email"))
                t.column(Expression<Int>("age"))
                t.column(Expression<String>("lastMessage"))  // 存储 JSON 字符串
            })
            
            // 创建嵌套对象
            let message = Message(
                id: "msg_001",
                content: "你好，这是一条测试消息",
                timestamp: Date(),
                isRead: false
            )

            let user = User(
                name: "张三",
                email: "zhangsan@example.com",
                age: 25,
                lastMessage: message
            )

            // 插入数据 - 嵌套的 Message 会自动转换为 JSON
            let userIdSetter = Expression<String>("userId") <- "123213213"
            let insertStatement = try users.insert(user, otherSetters: [userIdSetter])
            try db.run(insertStatement)
            
            // 从数据库读取并解码嵌套结构体
            for row in try db.prepare(users) {
                let user: User = try row.decode()
                print("用户名: \(user.name)")
                print("最后消息: \(user.lastMessage.content)")
                print("消息时间: \(user.lastMessage.timestamp)")
            }
        } catch {
            print("🍀👹👹 \(error)")
        }
    }
}
