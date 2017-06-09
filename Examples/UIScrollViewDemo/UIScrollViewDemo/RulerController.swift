//
//  RulerController.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/6/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class MootsCollectionCell: UICollectionViewCell {

    var textLabel: UILabel?

    private lazy var line: CALayer = {
        let line = CALayer()
        line.frame = CGRect(x: (self.frame.width - 1) / 2, y: 0, width: 1, height: self.frame.height)
        line.backgroundColor = UIColor.red.cgColor
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.addSublayer(line)
    }

    var index: Int = 0 {
        didSet {
            textLabel?.removeFromSuperview()
            if index % 5 == 0 {
                textLabel = UILabel()
                textLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                textLabel?.text = "\(index * 100)"
                textLabel?.sizeToFit()
                textLabel?.center.x = line.frame.minX
                contentView.addSubview(textLabel!)

                // 用0.6大概是黄金比
                line.frame.size.height = flat(frame.height * goldenRatio)
            } else {
                line.frame.size.height = flat(frame.height * goldenRatio * goldenRatio)
            }
            line.frame.origin.y = frame.height - line.frame.height
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RulerController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColor.white

        let rulerView = RulerView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300))

        view.addSubview(rulerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
