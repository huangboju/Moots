//
//  DynamicStackViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class DynamicStackViewController: AutoLayoutBaseController {
    
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

    override func initSubviews() {
        
        scrollView.backgroundColor = .gray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        if #available(iOS 11, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        if #available(iOS 11, *) {
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -20).isActive = true
        }

        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)

        stackView.addArrangedSubview(editButton)
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    @objc func editAction() {
        guard let addButtonContainerView = stackView.arrangedSubviews.last else { fatalError("Expected at least one arranged view in the stack view.") }
        let nextEntryIndex = stackView.arrangedSubviews.count - 1
        
        let offset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + addButtonContainerView.bounds.height)
        
        let newEntryView = createEntryView()
        newEntryView.isHidden = true
        
        stackView.insertArrangedSubview(newEntryView, at: nextEntryIndex)

        UIView.animate(withDuration: 0.25, animations: {
            newEntryView.isHidden = false
            self.scrollView.contentOffset = offset
        })
    }

    /// Creates a horizontal stack view entry to place within the parent `stackView`.
    fileprivate func createEntryView() -> UIView {
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let number = UUID().uuidString
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        numberLabel.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue - 1), for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue - 1), for: .horizontal)

        let deleteButton = UIButton(type: .roundedRect)
        deleteButton.setTitle("Delete", for: UIControl.State())
        deleteButton.addTarget(self, action: #selector(deleteStackView), for: .touchUpInside)

        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)

        return stack
    }

    @objc func deleteStackView(_ sender: UIButton) {
        guard let entryView = sender.superview else { return }

        UIView.animate(withDuration: 0.25, animations: {
            entryView.isHidden = true
        }, completion: { _ in
            entryView.removeFromSuperview()
        })
    }
}
