//
//  SandBox.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2016/12/29.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

// http://www.superqq.com/blog/2015/07/24/nsfilemanagerwen-jian-cao-zuo-de-shi-ge-xiao-gong-neng/

// http://blog.flight.dev.qunar.com/2016/11/10/ios-data-persistence-learn/#more

class SandBox: UITableViewController {
    
    enum Path: String {
        case home = "Home Directory"
        case documents = "Documents"
        case library = "Library"
        case caches = "Caches"
        case tmp = "Tmp"
    }
    
    let titles: [[String]] = [
        [
            "Home Directory",
            "Documents",
            "Library",
            "Caches",
            "Tmp"
        ],
        [
            "createDirectory",
            "createFile",
            "writeFile",
            "readFileContent",
            "isExist",
            "fileSize",
            "deleteFile",
            "moveFile",
            "renameFile",
            "copyFile",
            "findFile"
        ],
        [
            "addContents",
            "findContents"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func excute(_ rawValue: String) {
        var path: String!

        switch Path(rawValue: rawValue)! {
        case .home:
            path = NSHomeDirectory()
        case .documents:
            path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        case .library:
            path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
        case .caches:
            path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        case .tmp:
            path = NSTemporaryDirectory()
        }

        print("📂\(path)\n\n")
    }

    // 创建文件夹
    func createDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        
        let iOSDirectory = documentsPath +  "/iOS"
        print("📂\(iOSDirectory)\n\n")
        do {
            try fileManager.createDirectory(at: URL(fileURLWithPath: iOSDirectory), withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func createFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let iOSDirectory = documentsPath +  "/iOS.txt"
        print("📃\(iOSDirectory)\n\n")
        let contents = "新建文件".data(using: String.Encoding.utf8)
        let isSuccess = fileManager.createFile(atPath: iOSDirectory, contents: contents, attributes: nil)
        print(isSuccess ? "✅" : "❌")
    }
    
    func writeFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let iOSPath = documentsPath +  "/iOS.txt"
        
        let content = "写入数据"
        do {
            try content.write(toFile: iOSPath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func readFileContent() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let iOSPath = documentsPath +  "/iOS.txt"
        
        do {
            let contents = try String(contentsOf: URL(fileURLWithPath: iOSPath), encoding: .utf8)
            print(contents)
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func isExist() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let iOSPath = documentsPath +  "/iOS.txt"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: iOSPath) {
            print("📃存在")
        } else {
            print("📃不存在")
        }
    }
    
    func fileSize() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let iOSPath = documentsPath +  "/iOS.txt"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: iOSPath) {
            do {
                let att = try fileManager.attributesOfItem(atPath: iOSPath)
                let size = att[FileAttributeKey.size]
                let creationDate = att[FileAttributeKey.creationDate]
                let ownerAccountName = att[FileAttributeKey.ownerAccountName]
                let modificationDate = att[FileAttributeKey.modificationDate]

                print("size=\(size)", "creationDate=\(creationDate)", "ownerAccountName=\(ownerAccountName)", "modificationDate=\(modificationDate)")
            } catch let error {
                print("❌\(error)")
            }
        } else {
            print("📃不存在")
        }
    }
    
//    func folderSize() {
//        let fileManager = FileManager.default
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        
//        let isExist = fileManager.fileExists(atPath: documentsPath)
//        
//        if isExist {
//            
//            let childFileEnumerator = fileManager.subpaths(atPath: documentsPath)
//            let folderSize = 0
//            let fileName = @""
//            while ((fileName = [childFileEnumerator nextObject]) != nil){
//                NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//                folderSize += [self fileSizeAtPath:fileAbsolutePath];
//            }
//            return folderSize / (1024.0 * 1024.0)
//        } else {
//            NSLog(@"file is not exist");
//            return 0;
//        }
//    }
    
    func deleteFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let iOSPath = documentsPath + "/iOS.txt"
        
        do {
            try fileManager.removeItem(atPath: iOSPath)
            print("✅删除")
        } catch let error {
            print("📃删除错误\(error)")
        }
    }
    
    func moveFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default

        let filePath = documentsPath + "/iOS.txt"
        
        let moveToPath = documentsPath + "/iOS/iOS1.txt"
        
        do {
            try fileManager.moveItem(atPath: filePath, toPath: moveToPath)
            print("✅移动")
        } catch let error {
            print("❌\(error)")
        }
    }

    func renameFile() {
        //通过移动该文件对文件重命名
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        
        let filePath = documentsPath + "/iOS.txt"
        let moveToPath = documentsPath + "/rename.txt"
        do {
            try fileManager.moveItem(atPath: filePath, toPath: moveToPath)
            print("✅重命名")
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func copyFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        
        let filePath = documentsPath + "/iOS.txt"
        let moveToPath = documentsPath + "/copy.txt"
        
        do {
            try fileManager.copyItem(atPath: filePath, toPath: moveToPath)
            print("✅")
        } catch let error {
            print("❌", error)
        }
    }

    func findFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default

        // 当前文件夹下的所有文件
        if let paths = fileManager.subpaths(atPath: documentsPath) {
            for path in paths where path.characters.first != "." { // 剔除隐藏文件
                print("\(documentsPath)/\(path)\n")
            }
        }
        
        // 查找当前文件夹
        do {
            let paths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            paths.forEach { print($0) }
        } catch let error {
            print(error)
        }
    }
    
    // 向文件追加数据
    func addContents() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let sourcePath = documentsPath + "/iOS.txt"
        
        do {
            let fileHandle = try FileHandle(forUpdating: URL(fileURLWithPath: sourcePath))
            
            fileHandle.seekToEndOfFile() // 将节点跳到文件的末尾
            
            let data = "追加的数据".data(using: String.Encoding.utf8)
            
            fileHandle.write(data!) // 追加写入数据
            
            fileHandle.closeFile()
            print("✅")
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func findContents() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let sourcePath = documentsPath + "/copy.txt"
        
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: sourcePath))
            
            let length = fileHandle.availableData.count

            fileHandle.seek(toFileOffset: UInt64(length / 2)) // 偏移量文件的一半

            let data = fileHandle.readDataToEndOfFile()
            
            let contents = String(data: data, encoding: String.Encoding.utf8)
            
            fileHandle.closeFile()

            print("✅\(contents)")
        } catch let error {
            print("❌\(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = titles[indexPath.section][indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            excute(titles[indexPath.section][indexPath.row])
        } else {
            perform(Selector(titles[indexPath.section][indexPath.row]))
        }
    }
}
