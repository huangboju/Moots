//
//  SimpleLabelAndTextField.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class DynamicHeightColumns: AutoLayoutBaseController {
    
    private var labels: [UILabel] = []

    override func initSubviews() {
        let firstLabel = generatLabel(with: "First Name")
        labels.append(firstLabel)

        view.addSubview(firstLabel)
        firstLabel.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        firstLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        let firstLabelTopCostraint = firstLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
        firstLabelTopCostraint.priority = UILayoutPriority(rawValue: 249)
        firstLabelTopCostraint.isActive = true
        

        let firstField = generatField(with: "Enter First Name")
        view.addSubview(firstField)
        firstField.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        let firstFieldTopCostraint = firstField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
        firstFieldTopCostraint.priority = UILayoutPriority(rawValue: 249)
        firstFieldTopCostraint.isActive = true

        firstField.lastBaselineAnchor.constraint(equalTo: firstLabel.lastBaselineAnchor).isActive = true
        firstField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstField.leadingAnchor.constraint(equalTo: firstLabel.trailingAnchor, constant: 8).isActive = true

        let middleLabel = generatLabel(with: "Middle Name")
        labels.append(middleLabel)
        view.addSubview(middleLabel)
        middleLabel.leadingAnchor.constraint(equalTo: firstLabel.leadingAnchor).isActive = true

        middleLabel.topAnchor.constraint(greaterThanOrEqualTo: firstLabel.bottomAnchor).isActive = true

        let middleLabelTopCostraint = middleLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor)
        middleLabelTopCostraint.priority = UILayoutPriority(rawValue: 249)
        middleLabelTopCostraint.isActive = true

        let middleField = generatField(with: "Enter Middle Name")
        view.addSubview(middleField)
        middleField.leadingAnchor.constraint(equalTo: middleLabel.trailingAnchor, constant: 8).isActive = true
        middleField.lastBaselineAnchor.constraint(equalTo: middleLabel.lastBaselineAnchor).isActive = true
        middleField.trailingAnchor.constraint(equalTo: firstField.trailingAnchor).isActive = true
        middleField.widthAnchor.constraint(equalTo: firstField.widthAnchor).isActive = true

        middleField.topAnchor.constraint(greaterThanOrEqualTo: firstField.bottomAnchor, constant: 8).isActive = true
        let middleFieldTopCostraint = middleField.topAnchor.constraint(equalTo: firstField.bottomAnchor)
        middleFieldTopCostraint.priority = UILayoutPriority(rawValue: 245)
        middleFieldTopCostraint.isActive = true

        let lastLabel = generatLabel(with: "Last Name")
        labels.append(lastLabel)
        view.addSubview(lastLabel)
        lastLabel.leadingAnchor.constraint(equalTo: firstLabel.leadingAnchor).isActive = true
        lastLabel.topAnchor.constraint(greaterThanOrEqualTo: middleLabel.bottomAnchor).isActive = true

        let lastLabelTopCostraint = lastLabel.topAnchor.constraint(equalTo: middleLabel.bottomAnchor)
        lastLabelTopCostraint.priority = UILayoutPriority(rawValue: 249)
        lastLabelTopCostraint.isActive = true

        let lastField = generatField(with: "Enter Last Name")
        view.addSubview(lastField)
        lastField.trailingAnchor.constraint(equalTo: firstField.trailingAnchor).isActive = true
        lastField.widthAnchor.constraint(equalTo: firstField.widthAnchor).isActive = true
        lastField.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: 8).isActive = true
        lastField.lastBaselineAnchor.constraint(equalTo: lastLabel.lastBaselineAnchor).isActive = true

        lastField.topAnchor.constraint(greaterThanOrEqualTo: middleField.bottomAnchor, constant: 8).isActive = true
        let lastFieldTopCostraint = lastField.topAnchor.constraint(equalTo: middleField.bottomAnchor)
        lastFieldTopCostraint.priority = UILayoutPriority(rawValue: 245)
        lastFieldTopCostraint.isActive = true
    }

    private func generatLabel(with title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }

    private func generatField(with placeholder: String) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = placeholder
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    var usingLargeFont = false
    
    var timer: Timer?
    
    // MARK: UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeFontSizeTimerDidFire), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }

    // MARK: Timer
    @objc func changeFontSizeTimerDidFire(_ timer: Timer) {
        // Toggle the font preference.
        usingLargeFont = !usingLargeFont

        // Determine which font should now be used.
        let font = UIFont.systemFont(ofSize: usingLargeFont ? 36.0 : 17.0)

        for label in labels {
            label.font = font
        }
    }
}



