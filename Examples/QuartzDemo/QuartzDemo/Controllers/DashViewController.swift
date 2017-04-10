//
//  DashViewController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

struct Pattern {
    let pattern: [CGFloat]
    let count: Int
}

class DashViewController: UIViewController {

    let patterns: [Pattern] = [
        Pattern(pattern: [10, 10], count: 2),
        Pattern(pattern: [10, 20, 10], count: 3),
        Pattern(pattern: [10, 20, 30], count: 3),
        Pattern(pattern: [10, 20, 10, 30], count: 4),
        Pattern(pattern: [10, 10, 20, 20], count: 4),
        Pattern(pattern: [10, 10, 20, 30, 50], count: 5),
    ]

    @IBOutlet weak var picker: UIPickerView!

    fileprivate lazy var quartzDashView: QuartzDashView = {
        let quartzDashView = QuartzDashView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
        return quartzDashView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        
        view.insertSubview(quartzDashView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @ IBAction func takeDashPhase(from sender: UISlider) {
        quartzDashView.dashPhase = CGFloat(sender.value)
    }
}

extension DashViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return patterns.count
    }
}

extension DashViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let p = patterns[row]
        var title = "\(p.pattern[0])"
        for i in 1 ..< p.count {
            title.append("-\(p.pattern[i])")
        }
        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quartzDashView.setDashPattern(pattern: patterns[row].pattern, count: patterns[row].count)
    }
}
