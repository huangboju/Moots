//
//  AverageComparisonVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/20.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import UIKit

class AverageComparisonVC: UIViewController {
    
    private let comparisonView = AverageComparisonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        comparisonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(comparisonView)
        
        NSLayoutConstraint.activate([
            comparisonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            comparisonView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            comparisonView.widthAnchor.constraint(equalToConstant: 350),
            comparisonView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // 可以设置自定义值
        comparisonView.topAverage = 169
        comparisonView.bottomAverage = 159
    }
}
