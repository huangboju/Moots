//
//  PDFController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PDFController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let quartzPDFView = QuartzPDFView()
        view.addSubview(quartzPDFView)
        quartzPDFView.translatesAutoresizingMaskIntoConstraints = false
        quartzPDFView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzPDFView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzPDFView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzPDFView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
