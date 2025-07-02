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

class DatabaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        testChatDatabase()
    }
    
    func testChatDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            print("🍀数据库路径: \(path)")

            let db = try Connection("\(path)/chat.sqlite3")

            // 定义用户表
            let users = Table("users")
            let userId = Expression<String>("id")
            let userName = Expression<String>("name")
            let userEmail = Expression<String>("email")
            let userCreatedAt = Expression<Date>("created_at")

            // 定义消息表
            let messages = Table("messages")
            let messageId = Expression<Int64>("id")
            let messageUserId = Expression<String>("user_id") // 外键
            let messageContent = Expression<String>("content")
            let messageCreatedAt = Expression<Date>("created_at")

            // 创建用户表
            try db.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: true)
                t.column(userName)
                t.column(userEmail, unique: true)
                t.column(userCreatedAt)
            })
            print("✅ 用户表创建成功")

            // 创建消息表
            try db.run(messages.create(ifNotExists: true) { t in
                t.column(messageId, primaryKey: .autoincrement)
                t.column(messageUserId)
                t.column(messageContent)
                t.column(messageCreatedAt)
                t.foreignKey(messageUserId, references: users, userId, delete: .cascade)
            })
            print("✅ 消息表创建成功")

            // 清理旧数据（可选，用于重复运行测试）
            try db.run(messages.delete())
            try db.run(users.delete())
            print("✅ 清理旧数据成功")

            // 插入示例用户（使用固定ID以便重复运行）
            let user1Id = "user-zhang-san-001"
            let insertUser1 = users.insert(or: .replace,
                userId <- user1Id,
                userName <- "张三",
                userEmail <- "zhangsan@example.com",
                userCreatedAt <- Date()
            )
            try db.run(insertUser1)
            
            let user2Id = "user-li-si-002"
            let insertUser2 = users.insert(or: .replace,
                userId <- user2Id,
                userName <- "李四",
                userEmail <- "lisi@example.com",
                userCreatedAt <- Date()
            )
            try db.run(insertUser2)
            
            print("✅ 插入用户成功 - 用户1 ID: \(user1Id), 用户2 ID: \(user2Id)")

            // 为用户插入消息
            let messagesData = [
                (user1Id, "你好，这是张三的第一条消息"),
                (user1Id, "张三的第二条消息"),
                (user1Id, "张三今天心情不错"),
                (user2Id, "李四来了！"),
                (user2Id, "李四的第二条消息"),
            ]

            for (uId, content) in messagesData {
                let insertMessage = messages.insert(
                    messageUserId <- uId,
                    messageContent <- content,
                    messageCreatedAt <- Date()
                )
                try db.run(insertMessage)
            }
            print("✅ 插入消息成功")

            // 查询所有用户
            print("\n📋 所有用户:")
            for user in try db.prepare(users) {
                print("用户ID: \(user[userId]), 姓名: \(user[userName]), 邮箱: \(user[userEmail])")
            }

            // 查询特定用户的所有消息
            print("\n💬 张三的所有消息:")
            let zhangSanMessages = messages.filter(messageUserId == user1Id)
            for message in try db.prepare(zhangSanMessages) {
                print("消息ID: \(message[messageId]), 内容: \(message[messageContent])")
            }

            // 使用JOIN查询用户及其消息
            print("\n🔗 用户及其消息 (JOIN查询):")
            let userMessagesQuery = users
                .select(userName, messageContent, messageId)
                .join(messages, on: userId == messageUserId)
            for row in try db.prepare(userMessagesQuery) {
                print("用户: \(row[userName]), 消息: \(row[messageContent]), 消息ID: \(row[messageId])")
            }

            // 统计每个用户的消息数量
            print("\n📊 每个用户的消息数量:")
            
            let messageCount = messageId.count
            let messageCountQuery = users
                .select(userName, messageCount)
                .join(.leftOuter, messages, on: userId == messageUserId)
                .group(userId)
            
            for row in try db.prepare(messageCountQuery) {
                print("用户: \(row[userName]), 消息数量: \(row[messageCount])")
            }

            // 删除示例：删除某条消息
            let firstMessage = messages.filter(messageId == 1)
            try db.run(firstMessage.delete())
            print("✅ 删除了ID为1的消息")

            // 更新示例：更新用户信息
            let zhangSan = users.filter(userId == user1Id)
            try db.run(zhangSan.update(userName <- "张三(已更新)"))
            print("✅ 更新了张三的用户名")

        } catch {
            print("❌ 数据库操作出错: \(error)")
        }
    }
}
