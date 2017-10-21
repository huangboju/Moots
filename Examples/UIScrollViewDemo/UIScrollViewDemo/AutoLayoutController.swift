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
        testView.backgroundColor = UIColor.lightGray
        testView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(self.view.snp.leftMargin)
            make.right.equalTo(self.view.snp.rightMargin)
        }
        testView.text = "fdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjklfdasgw1jlkqlknvzfeqwfdsfsafsafasourwiqeoqnvzxlnlkjasghfdjkl"
        
        
        centerView()
        
        twoEqual()

    }

    func twoEqual() {
        let view1 = UIView()
        view1.backgroundColor = .blue
        view.addSubview(view1)
        
        let view2 = UIView()
        view2.backgroundColor = .red
        view.addSubview(view2)

        view1.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.height.equalTo(50)
            make.bottom.equalTo(-100)
            make.size.equalTo(view2)
        }

        view2.snp.makeConstraints { (make) in
            make.trailing.equalTo(-16)
            make.leading.equalTo(view1.snp.trailing).offset(20)
            make.centerY.equalTo(view1)
        }
    }

    func centerView() {
        
        let helperView = UILayoutGuide()
        view.addLayoutGuide(helperView)

        let imageView = UIImageView(image: UIImage(named: "icon_emotion"))
        view.addSubview(imageView)

        let textLabel = UILabel()
        textLabel.text = "今天天气好晴朗"
        textLabel.backgroundColor = .gray
        view.addSubview(textLabel)

        imageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView)
        }

        helperView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.trailing.equalTo(textLabel)
            make.leading.equalTo(imageView)
        }
        
        
        let viewsDictionary = [
            "imageView": imageView,
            "label": textLabel
        ]

        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[imageView]-[label]-(>=0)-|", options: [], metrics: nil, views: viewsDictionary)
        view.addConstraints(constraints)
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
