//
//  MaskViewVC.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/10/27.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class MaskViewVC: UIViewController {
    
    private lazy var maskView: MaskView = {
        let maskView = MaskView(frame: self.view.bounds)
        maskView.maskColor = UIColor(white: 0, alpha: 0.6)
        return maskView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        maskView.addTransparentRect(CGRect(x: 20, y: 100, width: 100, height: 100))
        maskView.addTransparentRoundedRect(CGRect(x: 20, y: 220, width: 100, height: 100), cornerRadius: 50)
        maskView.addTransparentRoundedRect(CGRect(x: 140, y: 100, width: 100, height: 100), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))
        maskView.addTransparentOvalRect(CGRect(x: 140, y: 220, width: 150, height: 100))
        
        view.addSubview(maskView)
    }
}
