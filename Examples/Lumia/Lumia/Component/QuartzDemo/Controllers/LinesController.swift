//
//  LinesController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class LinesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzLineView = QuartzLineView()
        view.addSubview(quartzLineView)
        quartzLineView.translatesAutoresizingMaskIntoConstraints = false
        quartzLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzLineView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzLineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let image = UIImage(named: "Demo")

        let imageView = UIImageView(image: image!.kt_drawRectWithRoundedCorner(image!.size.width / 2))
        imageView.frame.origin.y = 300
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
