//
//  AlignmentRectController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2018/4/28.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class AlignmentRectView: UILabel {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return size
    }
    
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        let rect = super.alignmentRect(forFrame: frame)
        print("🍀🍀\(#function)🍀🍀")
        print(rect)
        print("\n\n")
        return rect
    }
    
    override func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
        let rect = super.frame(forAlignmentRect: alignmentRect)
        print("🍀🍀\(#function)🍀🍀")
        print(rect)
        print("\n\n")
        return rect
    }

    override var alignmentRectInsets: UIEdgeInsets {
        let inset = super.alignmentRectInsets
        print("🍀🍀\(#function)🍀🍀")
        print(inset)
        print("\n\n")
        inset.bottom += 10
        return inset
    }
}

class AlignmentRectController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        initTest1()
//        initStackView()
    }

    let subview1 = AlignmentRectView()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        temp.text = ""
    }
    
    func initTest1() {
        let subview = AlignmentRectView()
        subview.text = "这是一段测试代码"
        view.addSubview(subview)
        subview.backgroundColor = UIColor.randomFlat()
        subview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    
        subview1.numberOfLines = 0
        subview1.text = "这是一段测试代码\n这是一段测试代码"
        view.addSubview(subview1)
        subview1.backgroundColor = UIColor.randomFlat()
        subview1.snp.makeConstraints { (make) in
            make.top.equalTo(subview.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        let subview2 = AlignmentRectView()
        subview2.numberOfLines = 0
        subview2.text = "这是代码\n这是代码"
        view.addSubview(subview2)
        subview2.backgroundColor = UIColor.randomFlat()
        subview2.snp.makeConstraints { (make) in
            make.top.equalTo(subview1.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    var temp: AlignmentRectView!
    
    func initStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.spacing = 10
        stackView.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalToSuperview()
        }
        let texts = [
            "这是一段测试代码",
            "这是一段测试代码\n这是一段测试代码",
            "这是代码\n这是代码"
        ]
        
        for (i, text) in texts.enumerated() {
            let subview = AlignmentRectView()
            subview.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 100, height: 100)).priority(999)
            }
            subview.text = text
            subview.numberOfLines = 0
            subview.backgroundColor = UIColor.randomFlat()
            if i == 1 {
                temp = subview
            }
            stackView.addArrangedSubview(subview)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
