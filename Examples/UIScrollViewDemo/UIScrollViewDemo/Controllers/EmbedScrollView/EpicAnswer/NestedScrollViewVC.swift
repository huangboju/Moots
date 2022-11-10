//
//  NestedScrollViewVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/4/30.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation
import UIKit
import StackScrollView

extension UIView {

    var safeAreaBottom: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.bottom
            }
         }
         return 0
    }

    var safeAreaTop: CGFloat {
         if #available(iOS 11, *) {
            if let window = UIApplication.shared.keyWindowInConnectedScenes {
                return window.safeAreaInsets.top
            }
         }
         return 0
    }
}

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }

    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

final class NestedScrollViewVC: UIViewController, UIScrollViewDelegate {
    
    private lazy var topScrollView: UIScrollView = {
        let topScrollView = UIScrollView()
        topScrollView.contentInsetAdjustmentBehavior = .never
        topScrollView.delegate = self
        return topScrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private lazy var stackScroll: StackScrollView = {
        let stackScroll = StackScrollView()
        stackScroll.contentInsetAdjustmentBehavior = .never
        for i in 0 ..< 10 {
            stackScroll.append(view: LabelStackCell(title: "cell:\(i)"))
        }
        return stackScroll
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.clipsToBounds = false
        containerView.backgroundColor = .systemGreen
        return containerView
    }()
    
    private var stickyHeight: CGFloat {
        return stackScroll.frame.maxY
    }

    // https://stackoverflow.com/questions/13221488/uiscrollview-within-a-uiscrollview-how-to-keep-a-smooth-transition-when-scrolli
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tableView.panGestureRecognizer)
        tableView.removeGestureRecognizer(tableView.panGestureRecognizer)
        
        view.addSubview(containerView)

        stackScroll.frame = CGRect(x: 0, y: UIApplication.statusBarHeight + 44, width: view.frame.width, height: 400)
        containerView.addSubview(stackScroll)

        let bottom = view.safeAreaBottom
        containerView.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: stackScroll.frame.maxY, width: view.frame.width, height: view.frame.height - bottom)

        tableView.addObserver(self,
                              forKeyPath: "contentSize",
                              options: .new,
                              context: nil)

        view.addSubview(topScrollView)
        topScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let scrollviewOrigin = topScrollView.frame.origin;
        topScrollView.scrollIndicatorInsets = UIEdgeInsets(top: -scrollviewOrigin.y, left: 0, bottom: scrollviewOrigin.y, right: scrollviewOrigin.x)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //the scroll view underneath (in the container view) will have a max content offset equal to the content height
        //but minus the bounds height
        if scrollView.contentOffset.y <= stickyHeight {
            //in this scenario we are still within the content for the contained scrollview
            //so we make sure the container view is scrolled to the top and set the offset for the contained scrollview
            tableView.contentOffset = .zero

            containerView.bounds.origin.y = scrollView.contentOffset.y
        } else {
            tableView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y - stickyHeight)
            containerView.bounds.origin.y = stickyHeight
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView,
           obj == self.tableView &&
            keyPath == "contentSize" {
            var size = tableView.contentSize
            size.height += (tableView.frame.minY + view.safeAreaBottom)
            topScrollView.contentSize = size
        }
    }
}

extension NestedScrollViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
