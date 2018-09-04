//
//  SimpleStackViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/10/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit
import Alamofire

class SimpleStackViewController: AutoLayoutBaseController {
    
    let label = UILabel()
    
    var resuest: DataRequest?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🍑🍑🍑🍑")
        resuest = Alamofire.request("https://httpbin.org/get").response { (response) in
            print("🐏🐏🐏🐏")
            self.label.text = ""
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resuest?.cancel()
    }

    override func initSubviews() {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        view.addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true

        let titleLabel = UILabel()
        titleLabel.backgroundColor = .red
        titleLabel.text = "Flowers"
        titleLabel.alpha = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        stackView.addArrangedSubview(titleLabel)

        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
        imageView.image = UIImage(named: "flowers")

        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("Edit", for: .normal)
        stackView.addArrangedSubview(button)
    }
}
