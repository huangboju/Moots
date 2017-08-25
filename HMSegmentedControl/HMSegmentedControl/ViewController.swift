//
//  ViewController.swift
//  HMSegmentedControl
//
//  Created by 伯驹 黄 on 2017/6/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Minimum code required to use the segmented control with the default styling.
        let viewWidth = view.frame.width

        let segmentedControl = HMSegmentedControl(sectionTitles: ["Trending", "News", "Library"])
        segmentedControl.frame = CGRect(x: 0, y: 60, width: viewWidth, height: 40)
        segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        view.addSubview(segmentedControl)

        // Segmented control with scrolling
        let segmentedControl1 = HMSegmentedControl(sectionTitles: ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"])
        segmentedControl1.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl1.frame = CGRect(x: 0, y: 120, width: viewWidth, height: 40)
        segmentedControl1.segmentEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        segmentedControl1.selectionStyle = .fullWidthStripe
        segmentedControl1.selectionIndicatorLocation = .down
        segmentedControl1.isVerticalDividerEnabled = true
        segmentedControl1.verticalDividerColor = UIColor.black
        segmentedControl1.verticalDividerWidth = 1.0
        segmentedControl1.titleFormatter = { (segmentedControl, title, index, selected) in
            let attString = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.blue])
            return attString
        }
        segmentedControl1.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        view.addSubview(segmentedControl1)
        
        let images = (1...4).flatMap { UIImage(named: "\($0)") }
        let selectedImages = (1...4).flatMap { UIImage(named: "\($0)-selected") }
        let segmentedControl2 = HMSegmentedControl(sectionImages: images, sectionSelectedImages: selectedImages)
        segmentedControl2.frame = CGRect(x: 0, y: 180, width: viewWidth, height: 50)
        segmentedControl2.selectionIndicatorHeight = 4.0
        segmentedControl2.backgroundColor = UIColor.clear
        segmentedControl2.selectionIndicatorLocation = .down
        segmentedControl2.selectionStyle = .textWidthStripe
        segmentedControl2.addTarget(self, action: #selector(segmentedControlChangedValue), for: .valueChanged)
        view.addSubview(segmentedControl2)
        

        let segmentedControl3 = HMSegmentedControl(sectionTitles: ["One", "Two", "Three", "4", "Five"])
        segmentedControl3.frame = CGRect(x: 0, y: 250, width: viewWidth, height: 50)
        segmentedControl3.indexChangeHandle = { index in
            print(index)
        }
        segmentedControl3.selectionIndicatorHeight = 4.0
        segmentedControl3.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1)
        segmentedControl3.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentedControl3.selectionIndicatorColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 1)
        segmentedControl3.selectionIndicatorBoxColor = UIColor.black
        segmentedControl3.selectionIndicatorBoxOpacity = 1.0
        segmentedControl3.selectionStyle = .box
        segmentedControl3.selectedSegmentIndex = -1
        segmentedControl3.selectionIndicatorLocation = .down
        segmentedControl3.shouldAnimateUserSelection = false
        segmentedControl3.tag = 2
        view.addSubview(segmentedControl3)
    }

    func segmentedControlChangedValue() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

