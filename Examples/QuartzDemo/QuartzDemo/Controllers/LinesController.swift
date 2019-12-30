//
//  LinesController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension UIView {
    var safaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
}


class LinesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzLineView = QuartzLineView()
        view.addSubview(quartzLineView)
        quartzLineView.translatesAutoresizingMaskIntoConstraints = false
        quartzLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzLineView.bottomAnchor.constraint(equalTo: view.safaBottomAnchor).isActive = true
        quartzLineView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let image = UIImage(named: "Demo")

        let imageView = UIImageView(image: image!.kt_drawRectWithRoundedCorner(image!.size.width / 2))
        imageView.frame.origin.y = 100
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
