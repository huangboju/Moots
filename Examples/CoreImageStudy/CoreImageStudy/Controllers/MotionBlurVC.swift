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
        
        let image = UIImage(named: "test1")
        displayView.originalImage = image
        displayView.processedImage = image?.motionBlur
        
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
        
        let ciImage = CIImage(cgImage: self.cgImage!)

        // 2. 创建滤镜
        let filter = CIFilter(name: "CIMotionBlur", parameters: [kCIInputImageKey: ciImage])
        // 设置相关参数
        filter?.setValue(10, forKey: "inputRadius")

        // 3. 渲染并输出CIImage
        guard let outputImage = filter?.outputImage else { return nil }

        // 4. 获取绘制上下文
        let context = CIContext(options: nil)

        // 5. 创建输出CGImage
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
