//
//  ViewController.swift
//  RunTime
//
//  Created by 伯驹 黄 on 2016/10/19.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

// let url = URL(string: "http://c.m.163.com/recommend/getChanListNews?channel=duanzi&passport=D3pXYOdJ%2BBxaWHO1/pK4OxnEOMj%2B7fVC1uf3muOsgN/L2AgtwrES0PPiPHJrLH2UePBK0dNsyevylzp8V9OOiA%3D%3D&devId=CY3plXq5jD2/czZ5NH%2BY9ginxA%2B0lR2yURfd9uV%2B1akZr3JPv6rg6oowBwVl8SLu&version=19.1&spever=false&net=wifi&lat=&lon=&ts=1482994987&sign=H3qeeO3JnenIG7O6%2BJ2mp8tGek0tTTlNXH8JJJpV2Ct48ErR02zJ6/KXOnxX046I&encryption=1&canal=appstore&offset=0&size=10&fn=1")!
let url = URL(string: "http://c.m.163.com/recommend/getChanListNews?size=10")!

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var data: [[String]] = [
        [
            "getForUrl",
            "getForRequest",
            "post"
        ],
        [
            "getForDelegate"
        ],
        [
            "download"
        ],
        [
            "webViewController",
            "jokeController",
            "menuItemController"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "URLSession"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        let bottomLine = NELineLabel(frame: CGRect(x: 0, y: 10, width: 200, height: 20))
        bottomLine.center.x = tableView.center.x
        bottomLine.text = "段子"
        bottomLine.textAlignment = .center
        bottomLine.textColor = UIColor.lightGray

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        footerView.addSubview(bottomLine)

        tableView.tableFooterView = footerView
        getForRequest()

        tableView.separatorInset = .zero // 在iOS10设置这一句就能实现分割线左边到头
    }

    func menuItemController() {
        let controller = MenuItemController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    func webViewController() {
        let controller = WebViewController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func jokeController() {
        let controller = JokeController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    func getForUrl() {
        let session = URLSession.shared
        // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("✅")
                }
            } catch let error {
                print(error, "⚠️")
            }
        }

        task.resume()
    }

    func getForRequest()  {
        let session = URLSession.shared

        // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad, timeoutInterval: 1)
        request.addValue("private", forHTTPHeaderField: "Cache-Control")

        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("✅")
                }
            } catch let error {
                print(error, "⚠️")
            }
        }

        task.resume()
    }

    // vapor
    // http://www.cocoachina.com/ios/20161031/17891.html

    func post() {
        let url = URL(string: "http://localhost:8080/bird")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "bird=daka&pwd=123".data(using: .utf8)

        // 由于要先对request先行处理,我们通过request初始化task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("✅", json)
                }
            } catch let error {
                print(error, "⚠️")
            }
        }
        task.resume()
    }

    func getForDelegate() {
        // 使用代理方法需要设置代理,但是session的delegate属性是只读的,要想设置代理只能通过这种方式创建session

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())

        // 创建任务(因为要使用代理方法,就不需要block方式的初始化了)
        let task = session.dataTask(with: URLRequest(url: url))
        task.resume()
    }

    func download() {
        print(NSHomeDirectory(), "数据库")
        let session = URLSession.shared
        let url = URL(string: "https://www.google.com.hk/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwjQrLv5i5nRAhVIxFQKHaSxBfQQjRwIBw&url=%68%74%74%70%3a%2f%2f%77%77%77%2e%6b%61%6e%67%67%75%69%2e%63%6f%6d%2f%62%61%6f%6a%69%61%6e%2f%7a%74%2f%32%30%31%35%30%35%31%34%2f%32%35%36%33%36%2e%68%74%6d%6c&psig=AFQjCNGSMCV1Nfvt1JsyQognfcXchk-MMg&ust=1483090270393310")!
        let task = session.downloadTask(with: url) { (url, response, error) in
            // location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件挪到需要的地方
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last?.appending(response?.suggestedFilename ?? "") ?? ""

            let tmp = NSTemporaryDirectory()
            var location: String?

            if let paths = FileManager.default.subpaths(atPath: tmp) {
                for path in paths where path.characters.first != "." { // 剔除隐藏文件
                    print("\(tmp)/\(path)\n")
                    location = "\(tmp)/\(path)"
                }
            }
            if let location = location {
                do {
                    try FileManager.default.moveItem(at: URL(fileURLWithPath: location), to: URL(fileURLWithPath: path))
                } catch let error {
                    print(error)
                }
            }
        }
        // 启动任务
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: URLSessionDataDelegate {
    // 1.接收到服务器的响应
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
    }

    // 2.接收到服务器的数据（可能调用多次）
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function)
    }

    // 3.请求成功或者失败（如果失败，error有值）
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(#function)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // http://www.jianshu.com/p/1274343055a7
        if indexPath.row == 0 {
            // preservesSuperviewLayoutMargins 表明当前视图是否保留父视图的margins，设置为true，如果当前视图的margins小于父视图的margins，那么当前视图使用父视图的margins，默认为false
            // cell如果是IB加载，preservesSuperviewLayoutMargins为false，cell如果是代码加载，preservesSuperviewLayoutMargins为true。
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = .zero
        }
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let actionName = data[indexPath.section][indexPath.row]
        perform(Selector(actionName))
    }
}
