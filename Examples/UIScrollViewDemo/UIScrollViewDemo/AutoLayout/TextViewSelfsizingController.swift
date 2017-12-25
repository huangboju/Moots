//
//  TextViewSelfsizing.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/12/23.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class TextViewSelfsizingCell: UITableViewCell, Reusable {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(textView)

        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextViewSelfsizingCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let vc: TextViewSelfsizingController? = viewController()

        let currentOffset = vc!.tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        vc?.tableView.beginUpdates()
        vc?.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        vc?.tableView.setContentOffset(currentOffset, animated: false)
    }
}

class TextViewSelfsizingController: AutoLayoutBaseController {
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(TextViewSelfsizingCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func initSubviews() {
        view.addSubview(tableView)
    }
}

extension TextViewSelfsizingController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}
