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

class ViewController: UIViewController {
    
    var targetRect: NSValue?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    fileprivate lazy var data = [IssueModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromServer()

        tableView.register(GLImageCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }
    
    func refresh() {
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func fetchDataFromServer() {
        let url = "http://baobab.wandoujia.com/api/v2/feed?date=1457883945551&num=7"
        Alamofire.request(url).responseJSON { response in
            if let result = DATA(response.result.value).dictionaryValue["issueList"] {
                self.data = result.map { IssueModel(dict: $0.1.dictionary) }
                self.tableView.reloadData()
            }
        }
    }

    func loadImageForVisibleCells() {
        let cells = tableView.visibleCells.flatMap { $0 as? GLImageCell }
        for cell in cells {
            if let indexPath = tableView.indexPath(for: cell) {
                setup(cell: cell, with: indexPath)
            }
        }
    }
    
    func setup(cell: GLImageCell, with indexPath: IndexPath) {
        let item = data[indexPath.section].itemList[indexPath.row]
        let targetURL = URL(string: item.feed)
        let cellFrame = tableView.rectForRow(at: indexPath)
        if cell.photoView.sd_imageURL() != targetURL {
            cell.photoView.alpha = 0
            let manager = SDWebImageManager.shared()
            
            var shouldLoadImage = true
            if let targetRect = targetRect {
                if !targetRect.cgRectValue.intersects(cellFrame) {
                    let cache = manager?.imageCache
                    let key = manager?.cacheKey(for: targetURL)
                    if cache?.imageFromMemoryCache(forKey: key) != nil {
                        shouldLoadImage = false
                    }
                }
            }
            if shouldLoadImage {
                cell.photoView.frame = CGRect(origin: .zero, size: cellFrame.size)
                cell.photoView.sd_setImage(with: targetURL!, placeholderImage: nil, options: .handleCookies, completed: { (image, error, type, url) in
                    UIView.animate(withDuration: 0.25, animations: {
                        cell.photoView.alpha = 1
                    })
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        targetRect = NSValue(cgRect: rect)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        targetRect = nil
        loadImageForVisibleCells()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty {
            return 0
        }
        let issueModel = data[section]
        return issueModel.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}


