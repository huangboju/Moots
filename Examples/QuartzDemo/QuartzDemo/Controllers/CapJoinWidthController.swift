//
//  CapJoinWidthController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CapJoinWidthController: UIViewController {
    
    @IBOutlet weak var lineWidthSlider: UISlider!
    
    @IBOutlet weak var joinSegmentedControl: UISegmentedControl!

    @IBOutlet weak var capSegmentedControl: UISegmentedControl!

    private lazy var quartzCapJoinWidthView: QuartzCapJoinWidthView = {
        let quartzCapJoinWidthView = QuartzCapJoinWidthView()
        quartzCapJoinWidthView.translatesAutoresizingMaskIntoConstraints = false
        return quartzCapJoinWidthView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.insertSubview(quartzCapJoinWidthView, at: 0)
        quartzCapJoinWidthView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzCapJoinWidthView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzCapJoinWidthView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        quartzCapJoinWidthView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        quartzCapJoinWidthView.cap = CGLineCap(rawValue: Int32(capSegmentedControl.selectedSegmentIndex))!
        quartzCapJoinWidthView.join = CGLineJoin(rawValue: Int32(joinSegmentedControl.selectedSegmentIndex))!
        quartzCapJoinWidthView.width = CGFloat(lineWidthSlider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func takeLineCap(from sender: UISegmentedControl) {
        quartzCapJoinWidthView.cap = CGLineCap(rawValue: Int32(sender.selectedSegmentIndex))!
    }

    @IBAction func takeLineJoin(from sender: UISegmentedControl) {
        
        quartzCapJoinWidthView.join = CGLineJoin(rawValue: Int32(sender.selectedSegmentIndex))!
    }

    @IBAction func takeLineWidth(from sender: UISlider) {
        quartzCapJoinWidthView.width = CGFloat(sender.value)
    }
}
