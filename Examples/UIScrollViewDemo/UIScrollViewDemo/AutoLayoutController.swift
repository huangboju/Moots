//
//  AutoLayoutController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/7/18.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class AutoLayoutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        let testView = TestView()
        view.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        testView.text = "fdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjkl"
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class TestView: UIView {
    let textLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
    }

    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
