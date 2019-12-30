//
//  TouchView.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 04/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class TouchView: UIView {

    lazy var label: UILabel = {
        let label = UILabel()
        if let filePath = Bundle.main.path(forResource: "Text", ofType: "txt") {
            label.text = try? String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
        }
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 255.0 / 255.0, green: 190.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = sa_safeAreaFrame
    }
}
