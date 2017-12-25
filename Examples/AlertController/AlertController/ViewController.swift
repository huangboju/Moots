//
//  ViewController.swift
//  AlertController
//
//  Created by 伯驹 黄 on 2016/10/10.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(frame: view.frame.insetBy(dx: 100, dy: 200))
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.backgroundColor = .green
        view.addSubview(button)
        
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }

    func action() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { _ in
        }
        alertController.addAction(ok)

        let image = UIImage(named: "ic_attachment")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)

        let alertControllerTitleStr = NSMutableAttributedString(string: "测试")
        
        alertControllerTitleStr.append(NSAttributedString(attachment: attachment))
        
        alertControllerTitleStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location: 0, length: 2))
        
        
        
        let alertControllerMessageStr = NSMutableAttributedString(string: "今天天气好晴朗")

        alertControllerMessageStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 0, length: 4))
        
        alertController.setValue(alertControllerMessageStr, forKey: "attributedMessage")

        ok.setValue(UIColor.blue, forKey: "titleTextColor")

        present(alertController, animated: true) {
        }

        alertController.setValue(alertControllerTitleStr, forKey: "attributedTitle")
    }
}
