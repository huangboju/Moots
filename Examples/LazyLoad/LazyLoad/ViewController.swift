//
//  ViewController.swift
//  LazyLoad
//
//  Created by 伯驹 黄 on 2016/10/8.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    fileprivate lazy var data = [Any]()
    var targetRect: NSValue?

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(GLImageCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }
    
    func refresh() {
        
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func fetchDataFromServer() {
        
    }
    
    func objectFor(row: Int) -> [String: Any]? {
        return row < data.count ? data[row] as? [String: Any] : nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    enum StringType {
        case color, font
    }
    func attributeStr(type: StringType = .color, text: String, targetText: String, color: UIColor = .red, font: UIFont = UIFont.systemFont(ofSize: 12), negate: Bool = false) -> NSMutableAttributedString {
        guard text.contains(targetText) else { return NSMutableAttributedString(string: text) }
        var targetRange = (text as NSString).range(of: targetText)
        var tempRange: NSRange!
        if negate {
            tempRange = targetRange
            targetRange = NSRange(location: 0, length: targetRange.location)
        }
        let attributedString = NSMutableAttributedString(string: text)
        func set(range: NSRange) {
            switch type {
            case .color:
                attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            case .font:
                attributedString.addAttribute(NSFontAttributeName, value: font, range: range)
            }
        }
        set(range: targetRange)
        if negate {
            set(range: NSRange(location: tempRange.location + tempRange.length, length: text.characters.count - tempRange.location - tempRange.length))
        }
        return attributedString
    }
}

extension ViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = indexPath.row.description
        cell.detailTextLabel?.attributedText = attributeStr(text: "今天天气好晴朗", targetText: "天气")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return GLImageCell(style: .value1, reuseIdentifier: "cell")
    }
}


