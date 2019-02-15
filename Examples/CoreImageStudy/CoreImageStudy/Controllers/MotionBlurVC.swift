//
//  MotionBlurVC.swift
//  CoreImageStudy
//
//  Created by 黄伯驹 on 2019/2/14.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class MotionBlurVC: UIViewController {
    
    private lazy var displayView: DisplayView = {
        let displayView = DisplayView()
        displayView.translatesAutoresizingMaskIntoConstraints = false
        return displayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(displayView)
        displayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        displayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        displayView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 15).isActive = true
        displayView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -15).isActive = true
    }
}

extension UIImage {
    var motionBlur: UIImage? {
        // 1. 将UIImage转换成CIImage
        
//        let ciImage = CIImage(cgImage: self)
//
//        // 2. 创建滤镜
//        self.filter = CIFilter(name: "CIMotionBlur", parameters: [kCIInputImageKey: ciImage])
//        // 设置相关参数
//        [self.filter setValue:@(10.f) forKey:@"inputRadius"];
//
//        // 3. 渲染并输出CIImage
//        CIImage *outputImage = [self.filter outputImage];
//
//        // 4. 获取绘制上下文
//        self.context = [CIContext contextWithOptions:nil];
//
//        // 5. 创建输出CGImage
//        CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//        UIImage *image = [UIImage imageWithCGImage:cgImage];
//        // 6. 释放CGImage
//        CGImageRelease(cgImage);
        
        return nil
    }
}
