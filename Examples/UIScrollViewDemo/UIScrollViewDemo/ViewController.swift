//
//  ViewController.swift
//  RunTime
//
//  Created by 伯驹 黄 on 2016/10/19.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var data: [[UIViewController.Type]] = [
        [
            FriendTableViewController.self,
            PagingEnabled.self,
            InfiniteScrollViewController.self,
            ScrollViewController.self,
            PagingSecondController.self,
            ConvertController.self
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIScrollView"
        
        
        let bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130))
        bannerView.set(content: ["", "", "", ""])
        bannerView.pageStepTime = 1
        bannerView.handleBack = {
            print($0)
        }

        tableView.tableHeaderView = bannerView

        let subView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        print(subView.isDescendant(of: view))
        
        
        
        let array = NSArray(objects: "2.0", "2.3", "3.0", "4.0", "10")
        
        
        let sum = array.value(forKeyPath: "@sum.floatValue")
        
        let avg = array.value(forKeyPath: "@avg.floatValue")
        let max = array.value(forKeyPath: "@max.floatValue")
        let min = array.value(forKeyPath: "@min.floatValue")

        print(sum, avg, max, min)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let controllerName = "\(data[indexPath.section][indexPath.row].classForCoder())"
        if let controller = controllerName.fromClassName() as? UIViewController {
            controller.title = controllerName
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension String {
    func fromClassName() -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + self
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}

extension UICollectionViewFlowLayout {
    /// 修正collection布局有缝隙
    func fixSlit(rect: inout CGRect, colCount: CGFloat, space: CGFloat = 0) -> CGFloat {
        let totalSpace = (colCount - 1) * space
        let itemWidth = (rect.width - totalSpace) / colCount
        var realItemWidth = floor(itemWidth) + 0.5
        if realItemWidth < itemWidth {
            realItemWidth += 0.5
        }
        let realWidth = colCount * realItemWidth + totalSpace
        let pointX = (realWidth - rect.width) / 2
        rect.origin.x = -pointX
        rect.size.width = realWidth
        return (rect.width - totalSpace) / colCount
    }
}

extension UIView {
    var viewController: UIViewController? {
        var viewController: UIViewController?
        var next = self.next
        while next != nil {
            if next!.isKind(of: UIViewController.self) {
                viewController = next as? UIViewController
                break
            }
            next = next?.next
        }
        return viewController
    }
}

