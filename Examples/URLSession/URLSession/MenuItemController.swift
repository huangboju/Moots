//
//  MenuItemController.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class MenuItemController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = indexPath.row.description

        return cell
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let board = UIPasteboard.general
        board.string = indexPath.row.description
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class MenuItemCell: UITableViewCell {
    
    /*!
     *  是此cell成为可以第一相应着
     *
     *  @return 此处必须返回yes
     */
    override var canBecomeFirstResponder: Bool {
        return true
    }

    /**
     *  这个函数用来控制
     *
     *  @param action 返回所有的menu能相应的方法（包括自定义的和系统自己的）
     *  @param sender
     *
     *  @return 使想要显示的方法返回yes，不需要相应的方法返回no
     */
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if [#selector(test1), #selector(test2)].contains(action) {
            return true
        }
        return true
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // http://nshipster.cn/uimenucontroller/
    func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.becomeFirstResponder() // 这句很重要
            let menuController = UIMenuController.shared
            let item1 = UIMenuItem(title: "测试1", action: #selector(test1))
            let item2 = UIMenuItem(title: "测试2", action: #selector(test2))
            menuController.menuItems = [item1, item2]
            menuController.setTargetRect(frame, in: superview!)
            menuController.setMenuVisible(true, animated: true)
        }
    }

    func test1() {
        print(#function)
    }

    func test2() {
        print(#function)
    }
}
