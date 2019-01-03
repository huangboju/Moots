//
//  BlurController.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2019/1/2.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import UIKit

class BlurController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        let image = UIImage(named: "flowers")?.blurred(radius: 10)
        let imageView = UIImageView(image: UIImage(named: "flowers"))
        view.addSubview(imageView)
        imageView.frame.origin = CGPoint(x: 0, y: 100)
        
        let darkBlur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurView)
        
//        let image = UIImage(named: "flowers")?.blurred(radius: 10)
//        let imageView1 = UIImageView(image: image)
//        imageView1.frame = CGRect(x: 0, y: imageView.frame.maxY, width: imageView.frame.width, height: imageView.frame.height)
//        view.addSubview(imageView1)
    }
    
    
    var context = CIContext(options: nil)
    
    func blurEffect() -> UIImage {
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: UIImage(named: "flowers")!)
        currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter?.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter?.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter?.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter?.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        return UIImage(cgImage: cgimg!)
    }
}
