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
        var rect = self.view.bounds
        rect.size.height = 400
        let maskView = MaskView(frame: rect)
        maskView.maskColor = UIColor(white: 0, alpha: 0.6)
        return maskView
    }()
    
    private lazy var maskView2: MaskView = {
        let maskView2 = MaskView(frame: CGRect(x: 100, y: 500, width: 52, height: 52))
        maskView2.maskColor = UIColor.red
        return maskView2
    }()
    
    private lazy var shapeMaskLayer: ShapeMaskLayer = {
        let shapeMaskLayer = ShapeMaskLayer(rect: CGRect(x: 200, y: 500, width: 52, height: 52))
        shapeMaskLayer.maskColor = UIColor.green
        return shapeMaskLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        maskView.addTransparentRect(CGRect(x: 20, y: 100, width: 100, height: 100))
        maskView.addTransparentRoundedRect(CGRect(x: 20, y: 220, width: 100, height: 100), cornerRadius: 50)
        maskView.addTransparentRoundedRect(CGRect(x: 140, y: 100, width: 100, height: 100), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))
        maskView.addTransparentOvalRect(CGRect(x: 140, y: 220, width: 150, height: 100))
        
        view.addSubview(maskView)
        
        maskView2.addTransparentRoundedRect(CGRect(x: 2, y: 2, width: 48, height: 48), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 2, height: 2))
        view.addSubview(maskView2)
        
        shapeMaskLayer.addTransparentRoundedRect(CGRect(x: 2, y: 2, width: 48, height: 48), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 2, height: 2))
        view.layer.addSublayer(shapeMaskLayer)
    }
}
