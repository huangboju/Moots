//
//  ViewController.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit
import Alamofire
import WebImage


class LazyLoadVC: UIViewController {
    
    
    var targetRect: CGRect?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    fileprivate lazy var data = [LazyLoadModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTestData()

        tableView.register(GLImageCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }

    func refresh() {
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }

    func buildTestData() {
        // Simulate an async request
        DispatchQueue.global().async {
            // Data from `data.json`
            guard let dataFilePath = Bundle.main.path(forResource: "data", ofType: "json") else { return }
            do {
                let item = try Data(contentsOf: URL(fileURLWithPath: dataFilePath))
                let rootDict = DATA(data: item).dictionaryValue
                guard let datas = rootDict["data"]?.arrayValue else { return }
                self.data = datas.map { LazyLoadModel($0.dictionaryValue) }
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func loadImageForVisibleCells() {
        guard let cells = tableView.visibleCells as? [GLImageCell] else { return }
        for cell in cells {
            guard let indexPath = tableView.indexPath(for: cell) else { continue }
            setup(cell: cell, with: indexPath)
        }
    }

    func setup(cell: GLImageCell, with indexPath: IndexPath) {
        let item = data[indexPath.row].hoverURL
        guard let targetURL = URL(string: item) else { return }
        let cellFrame = tableView.rectForRow(at: indexPath)
        if cell.photoView.sd_imageURL() != targetURL {
            cell.photoView.alpha = 0
            let manager = SDWebImageManager.shared()
            manager?.imageDownloader.setValue("http://image.baidu.com/i?tn=baiduimage&ipn=r&ct=201326592&cl=2&lm=-1&st=-1&fm=index&fr=&sf=1&fmq=&pv=&ic=0&nc=1&z=&se=1&showtab=0&fb=0&width=&height=&face=0&istype=2&ie=utf-8&word=cat&oq=cat&rsp=-1", forHTTPHeaderField: "Referer")
            var shouldLoadImage = true
            if let targetRect = targetRect, !targetRect.intersects(cellFrame) {
                let cache = manager?.imageCache
                let key = manager?.cacheKey(for: targetURL)
                if cache?.imageFromMemoryCache(forKey: key) != nil {
                    print(targetRect)
                    shouldLoadImage = false
                }
            }
            guard shouldLoadImage else { return }
            cell.photoView.frame = CGRect(origin: .zero, size: cellFrame.size)
            cell.photoView.sd_setImage(with: targetURL, placeholderImage: nil, options: .handleCookies, completed: { (image, error, type, url) in
                UIView.animate(withDuration: 0.25, animations: {
                    cell.photoView.alpha = 1
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LazyLoadVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = data[indexPath.row]
        return tableView.frame.width / item.width * item.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageCell = cell as? GLImageCell {
            setup(cell: imageCell, with: indexPath)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        targetRect = nil
        loadImageForVisibleCells()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let rect = CGRect(origin: targetContentOffset.move(), size: scrollView.frame.size)
        targetRect = rect
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        targetRect = nil
        loadImageForVisibleCells()
    }
}

extension LazyLoadVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}


