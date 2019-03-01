//
//  SandBox.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2016/12/29.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

// QunarFlight团队博客~iOS 中数据持久化的几种方式
// http://blog.flight.dev.qunar.com/2016/11/10/ios-data-persistence-learn/#more

// JSONSerialization
// http://www.hangge.com/blog/cache/detail_647.html
// http://swiftcafe.io/2015/07/18/swift-json

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
        ],
        [
            "writeToJSON"
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

        print("📂\(String(describing: path))\n\n")
    }

    // 创建文件夹
    func createDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default

            let iOSDirectory = documentsPath + "/iOS"
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
            let iOSDirectory = documentsPath + "/iOS.txt"
        print("📃\(iOSDirectory)\n\n")
        let contents = "新建文件".data(using: .utf8)
        let isSuccess = fileManager.createFile(atPath: iOSDirectory, contents: contents, attributes: nil)
        print(isSuccess ? "✅" : "❌")
    }

    func writeFile() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let iOSPath = documentsPath + "/iOS.json"

        guard let dataFilePath = Bundle.main.path(forResource: "test", ofType: "json") else { return }
        let data = try? Data(contentsOf: URL(fileURLWithPath: dataFilePath))
        do {
            try data?.write(to: URL(fileURLWithPath: iOSPath))
//            try content.write(toFile: iOSPath, atomically: true, encoding: .utf8)
        } catch let error {
            print("❌\(error)")
        }
    }

    func readFileContent() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let iOSPath = documentsPath + "/iOS.txt"

        do {
            let contents = try String(contentsOf: URL(fileURLWithPath: iOSPath), encoding: .utf8)
            print(contents)
        } catch let error {
            print("❌\(error)")
        }
    }

    func isExist() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let iOSPath = documentsPath + "/iOS.txt"
        let fileManager = FileManager.default
            if fileManager.fileExists(atPath: iOSPath) {
            print("📃存在")
        } else {
            print("📃不存在")
        }
    }

    func fileSize() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let iOSPath = documentsPath + "/iOS.txt"
        let fileManager = FileManager.default
            if fileManager.fileExists(atPath: iOSPath) {
            do {
                let att = try fileManager.attributesOfItem(atPath: iOSPath)
                let size = att[.size]
                let creationDate = att[.creationDate]
                let ownerAccountName = att[.ownerAccountName]
                let modificationDate = att[.modificationDate]

                print("size=\(String(describing: size))", "creationDate=\(String(describing: creationDate))", "ownerAccountName=\(String(describing: ownerAccountName))", "modificationDate=\(String(describing: modificationDate))")
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
        // 通过移动该文件对文件重命名
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
            for path in paths where path.first != "." { // 剔除隐藏文件
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

        let sourcePath = documentsPath + "/iOS.json"

        do {
            let fileHandle = try FileHandle(forUpdating: URL(fileURLWithPath: sourcePath))

            fileHandle.seekToEndOfFile() // 将节点跳到文件的末尾

            let data = "追加的数据".data(using: .utf8)

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

            print("✅\(String(describing: contents))")
        } catch let error {
            print("❌\(error)")
        }
    }
    
    func writeToJSON() {
        //Swift对象
        let user:[String: Any] = [
            "uname": "张三",
            "tel": ["mobile": "138", "home": "010"]
        ]
        //首先判断能不能转换
        if !JSONSerialization.isValidJSONObject(user) {
            print("is not a valid json object")
            return
        }
        
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读

        do {
            let data = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            let iOSPath = documentsPath + "/iOS.json"
            try data.write(to: URL(fileURLWithPath: iOSPath))
            print("✅✅✅", iOSPath)
        } catch let error {
            print("❌\(error)")
        }

//        //把Data对象转换回JSON对象
//        let json = try? JSONSerialization.jsonObject(with: data!,
//                                                     options:.allowFragments) as! [String: Any]
//        print("Json Object:", json)
//        //验证JSON对象可用性
//        let uname = json?["uname"]
//        let mobile = (json?["tel"] as! [String: Any])["mobile"]
//        print("get Json Object:","uname: \(uname), mobile: \(mobile)")
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
