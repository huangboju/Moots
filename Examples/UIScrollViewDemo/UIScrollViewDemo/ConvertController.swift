//
//  ConvertController.swift
//  UIScrollViewDemo
//
//  Created by 伯驹 黄 on 2017/1/16.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ConvertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        
        
        
        let greenViewOrigin = CGPoint(x: 150, y: 100)
        let blueViewOrigin = CGPoint(x: 30, y: 75)
        
        let redView = UIView(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.width))
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)

        let greenView = UIView(frame: CGRect(origin: greenViewOrigin, size: CGSize(width: 130, height: 130)))
        greenView.backgroundColor = UIColor.green

        let blueView = UIView(frame: CGRect(origin: blueViewOrigin, size: CGSize(width: 88, height: 88)))
        blueView.backgroundColor = UIColor.blue

        redView.addSubview(greenView)
        redView.addSubview(blueView)
//        view.addSubview(greenView)
//        view.addSubview(blueView)
        
        // 把redView坐标系上的点greenViewOrigin转换为blueView的坐标系上的点point
        let point = redView.convert(greenViewOrigin, to: blueView)
        print("point=\(point)")

        let point1 = redView.convert(greenViewOrigin, from: blueView)
        print("point1=\(point1)")

        let point2 = redView.convert(blueViewOrigin, to: greenView)
        print("point2=\(point2)")

        let point3 = redView.convert(blueViewOrigin, from: greenView)
        print("point3=\(point3)")
        
        print("\n\n\n\n\n")
        
        let rect = redView.convert(greenView.frame, to: blueView)
        print("rect=\(rect)")
        
        let rect1 = redView.convert(greenView.frame, from: blueView)
        print("rect1=\(rect1)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
