//
//  CustomCollectionViewHeaderView.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 13/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

protocol CollectionViewReusableViewDelegate: class {
    
    func collectionViewReusableViewSwitcherAction(_ view: CollectionViewReusableView)
}

class CollectionViewReusableView: UICollectionReusableView {
    
    weak var delegate: CollectionViewReusableViewDelegate?
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    private(set) lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(switcherAction), for: .valueChanged)
        return switcher
    }()

    private lazy var switcherLabel: UILabel = {
        let label = UILabel()
        label.text = "Attach Header Content To Safe Area"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(switcher)
        addSubview(switcherLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if switcher.isOn {
            label.frame = sa_safeAreaFrame
            switcher.frame.origin.x = bounds.width - sa_safeAreaInsets.right - switcher.frame.width
            switcherLabel.frame.origin.x = sa_safeAreaInsets.left
            switcherLabel.frame.size.width = sa_safeAreaFrame.width
        }
        else {
            label.frame = bounds
            switcher.frame.origin.x = bounds.width - switcher.frame.width
            switcherLabel.frame.origin.x = 0.0
            switcherLabel.frame.size.width = bounds.width
        }
        
        switcher.frame.origin.y = bounds.height - switcher.frame.height - 5.0

        switcherLabel.frame.origin.y = 5.0
        switcherLabel.frame.size.height = 20.0
    }
    
    // MARK: - Actions
    
    @objc private func switcherAction() {
        delegate?.collectionViewReusableViewSwitcherAction(self)
    }
}
