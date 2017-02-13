//
//  JokeController.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealReachability

class Cell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
         在这里打个断点，在lldb中用
         frame variable self
         就可以得到
         "_defaultMarginWidth = 16"
         */
//        print(value(forKey: "_defaultMarginWidth"))
    }
}

class JokeController: UITableViewController {

    lazy var cellHeights: [IndexPath: CGFloat] = [:]
    
    var contents: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getForUrl))

        getForUrl()
        

        tableView.separatorStyle = .none
        tableView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView?.register(Cell.self, forCellReuseIdentifier: "cell")

    }
    
    let reach = NetworkReachabilityManager()

    func getForUrl() {
        cellHeights.removeAll(keepingCapacity: true)
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.startAnimating()
        navigationItem.rightBarButtonItem?.customView = indicatorView

        // 网络状态
        let isReachable = reach?.isReachable ?? false

        let session = URLSession.shared
        /*
         * useProtocolCachePolicy 对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
         * reloadIgnoringLocalCacheData	 数据需要从原始地址加载。不使用现有缓存。
         * reloadIgnoringLocalAndRemoteCacheData*	 不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存。
         * returnCacheDataElseLoad	 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据。
         * returnCacheDataDontLoad	 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。
         * reloadRevalidatingCacheData*	从原始地址确认缓存数据的合法性后，缓存数据就可以使用，否则从原始地址加载。
         */
        
        
        // reloadIgnoringLocalAndRemoteCacheData 和 reloadRevalidatingCacheData没有实现
        
        
        let cachePolicy: URLRequest.CachePolicy = isReachable ? .reloadIgnoringLocalCacheData :  .returnCacheDataElseLoad

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 1)
        
        
        /*  
         * public 所有内容都将被缓存
         * private 内容只缓存到私有缓存中
         * no-cache 所有内容都不会被缓存
         * no-store 所有内容都不会被缓存到缓存或Internet文件中，
         */
        
        request.addValue("private", forHTTPHeaderField: "Cache-Control") // 这个头必须由服务器端指定以开启客户端的 HTTP 缓存功能。这个头的值可能包含 max-age（缓存多久），是公共 public 还是私有 private，或者不缓存 no-cache 等信息

        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.navigationItem.rightBarButtonItem?.customView = nil
            if let data = data {
                if let json = JSON(data).dictionaryValue["段子"] {
                    self.contents = json.arrayValue.flatMap { $0.dictionaryValue["digest"]?.stringValue }
                }
            }
        }

        task.resume()
        
//        URLCache()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = contents[indexPath.section]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.backgroundColor = UIColor.red
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeights[indexPath] {
            return height
        } else {
            let content = contents[indexPath.section]
            let height = content.heightWithConstrainedWidth(font: UIFont.systemFont(ofSize: UIFont.labelFontSize))
            cellHeights[indexPath] = height + 16 // ？？？ 这里为什么会有误差我也不知道
            return height
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension String {
    // 32 cell.textLabel的padding
    func heightWithConstrainedWidth(width: CGFloat = UIScreen.main.bounds.width - 32, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        let label = UILabel(frame: CGRect(origin: .zero, size: constraintRect))
        label.text = self
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.height
    }
}

