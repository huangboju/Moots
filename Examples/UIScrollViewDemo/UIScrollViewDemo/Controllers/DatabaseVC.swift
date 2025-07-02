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

// MARK: - 数据库管理器单例
class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection?
    private let dbQueue = DispatchQueue(label: "com.app.database", qos: .utility)
    
    // 表定义
    let users = Table("users")
    let userId = Expression<String>("id")
    let userName = Expression<String>("name")
    let userEmail = Expression<String>("email")
    let userCreatedAt = Expression<Date>("created_at")
    
    let messages = Table("messages")
    let messageId = Expression<Int64>("id")
    let messageUserId = Expression<String>("user_id")
    let messageContent = Expression<String>("content")
    let messageCreatedAt = Expression<Date>("created_at")
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            print("🍀数据库路径: \(path)")
            
            db = try Connection("\(path)/chat.sqlite3")
            createTables()
        } catch {
            print("❌ 数据库初始化失败: \(error)")
        }
    }
    
    private func createTables() {
        do {
            // 创建用户表
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: true)
                t.column(userName)
                t.column(userEmail, unique: true)
                t.column(userCreatedAt)
            })
            
            // 创建消息表
            try db?.run(messages.create(ifNotExists: true) { t in
                t.column(messageId, primaryKey: .autoincrement)
                t.column(messageUserId)
                t.column(messageContent)
                t.column(messageCreatedAt)
                t.foreignKey(messageUserId, references: users, userId, delete: .cascade)
            })
            
            print("✅ 数据库表创建成功")
        } catch {
            print("❌ 创建表失败: \(error)")
        }
    }
    
    // MARK: - 用户操作
    func insertUser(id: String, name: String, email: String) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        try dbQueue.sync {
            let insert = users.insert(or: .replace,
                userId <- id,
                userName <- name,
                userEmail <- email,
                userCreatedAt <- Date()
            )
            try db.run(insert)
        }
    }
    
    func getAllUsers() throws -> [UserModel] {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        return try dbQueue.sync {
            var userList: [UserModel] = []
            for user in try db.prepare(users) {
                let userModel = UserModel(
                    id: user[userId],
                    name: user[userName],
                    email: user[userEmail],
                    createdAt: user[userCreatedAt]
                )
                userList.append(userModel)
            }
            return userList
        }
    }
    
    // MARK: - 消息操作
    func insertMessage(userId: String, content: String) throws {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        try dbQueue.sync {
            let insert = messages.insert(
                messageUserId <- userId,
                messageContent <- content,
                messageCreatedAt <- Date()
            )
            try db.run(insert)
        }
    }
    
    func getMessagesForUser(userId: String) throws -> [MessageModel] {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        return try dbQueue.sync {
            var messageList: [MessageModel] = []
            let userMessages = messages.filter(messageUserId == userId)
            for message in try db.prepare(userMessages) {
                let messageModel = MessageModel(
                    id: message[messageId],
                    userId: message[messageUserId],
                    content: message[messageContent],
                    createdAt: message[messageCreatedAt]
                )
                messageList.append(messageModel)
            }
            return messageList
        }
    }
    
    func getAllMessagesWithUsers() throws -> [(UserModel, MessageModel)] {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        return try dbQueue.sync {
            var results: [(UserModel, MessageModel)] = []
            let query = users
                .select(userName, userEmail, messageContent, messageId, messageCreatedAt)
                .join(messages, on: userId == messageUserId)
            
            for row in try db.prepare(query) {
                let user = UserModel(
                    id: "", // 在这个查询中我们不需要用户ID
                    name: row[userName],
                    email: row[userEmail],
                    createdAt: Date() // 临时值
                )
                let message = MessageModel(
                    id: row[messageId],
                    userId: "",
                    content: row[messageContent],
                    createdAt: row[messageCreatedAt]
                )
                results.append((user, message))
            }
            return results
        }
    }
    
    // MARK: - 清理数据（测试用）
    func clearAllData() throws {
        guard let db = db else { throw DatabaseError.connectionFailed }
        
        try dbQueue.sync {
            try db.run(messages.delete())
            try db.run(users.delete())
        }
    }
}

// MARK: - 数据模型
struct UserModel {
    let id: String
    let name: String
    let email: String
    let createdAt: Date
}

struct MessageModel {
    let id: Int64
    let userId: String
    let content: String
    let createdAt: Date
}

// MARK: - 错误类型
enum DatabaseError: Error {
    case connectionFailed
    case insertFailed
    case queryFailed
    
    var localizedDescription: String {
        switch self {
        case .connectionFailed:
            return "数据库连接失败"
        case .insertFailed:
            return "数据插入失败"
        case .queryFailed:
            return "数据查询失败"
        }
    }
}

class DatabaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        testChatDatabase()
    }
    
    func testChatDatabase() {
        do {
            let dbManager = DatabaseManager.shared
            
            // 清理旧数据（测试用）
            try dbManager.clearAllData()
            print("✅ 清理旧数据成功")
            
            // 插入示例用户
            try dbManager.insertUser(id: "user-zhang-san-001", name: "张三", email: "zhangsan@example.com")
            try dbManager.insertUser(id: "user-li-si-002", name: "李四", email: "lisi@example.com")
            print("✅ 插入用户成功")
            
            // 插入消息
            let messagesData = [
                ("user-zhang-san-001", "你好，这是张三的第一条消息"),
                ("user-zhang-san-001", "张三的第二条消息"),
                ("user-zhang-san-001", "张三今天心情不错"),
                ("user-li-si-002", "李四来了！"),
                ("user-li-si-002", "李四的第二条消息"),
            ]
            
            for (userId, content) in messagesData {
                try dbManager.insertMessage(userId: userId, content: content)
            }
            print("✅ 插入消息成功")
            
            // 查询所有用户
            print("\n📋 所有用户:")
            let users = try dbManager.getAllUsers()
            for user in users {
                print("用户ID: \(user.id), 姓名: \(user.name), 邮箱: \(user.email)")
            }
            
            // 查询张三的消息
            print("\n💬 张三的所有消息:")
            let zhangSanMessages = try dbManager.getMessagesForUser(userId: "user-zhang-san-001")
            for message in zhangSanMessages {
                print("消息ID: \(message.id), 内容: \(message.content)")
            }
            
            // 查询所有用户及其消息
            print("\n🔗 所有用户及其消息:")
            let userMessages = try dbManager.getAllMessagesWithUsers()
            for (user, message) in userMessages {
                print("用户: \(user.name), 消息: \(message.content)")
            }
            
        } catch {
            print("❌ 数据库操作出错: \(error)")
        }
    }
}
