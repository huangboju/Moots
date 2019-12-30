//
//  GradientController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class GradientController: UIViewController {
    
    private lazy var quartzGradientView: QuartzGradientView = {
        let quartzGradientView = QuartzGradientView()
        quartzGradientView.translatesAutoresizingMaskIntoConstraints = false
        return quartzGradientView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(quartzGradientView)
        quartzGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzGradientView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }

    @IBAction func takeGradientType(from sender: UISegmentedControl) {
        quartzGradientView.type = GradientType(rawValue: sender.selectedSegmentIndex)!
    }

    @IBAction func takeExtendsPastStart(from sender: UISwitch) {
        quartzGradientView.extendsPastStart = sender.isOn
    }
    
    
    @IBAction func takeExtendsPastEnd(from sender: UISwitch) {
        quartzGradientView.extendsPastEnd = sender.isOn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
