//
//  SwitchCell.swift
//  MVVM_DEMO
//
//  Created by 伯驹 黄 on 16/5/23.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

protocol SwitchCellDatasorce {
    var title: String { get }
    var switchOn: Bool { get }
}

protocol SwitchCellDelegate {
    func onSwitchTogleOn(on: Bool)
    
    var switchColor: UIColor { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension SwitchCellDelegate {
    
    var switchColor: UIColor {
        return .purpleColor()
    }
    
    var textColor: UIColor {
        return .blackColor()
    }
    
    var font: UIFont {
        return .systemFontOfSize(17)
    }
}

class SwitchCell: UITableViewCell {
    
    var label: UILabel!
    var switchToggle: UISwitch!
    
    private var dataSource: SwitchCellDatasorce?
    private var delegate: SwitchCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        contentView.addSubview(label)
        
        switchToggle = UISwitch(frame: CGRect(x: frame.width - 100, y: 10, width: 0, height: 0))
        switchToggle.addTarget(self, action: #selector(onSwitchToggle), forControlEvents: .ValueChanged)
        contentView.addSubview(switchToggle)
    }
    
    func configure(withDataSource dataSource: SwitchCellDatasorce, delegate: SwitchCellDelegate?) {
        self.dataSource = dataSource
        self.delegate = delegate
        
        label.text = dataSource.title
        switchToggle.on = dataSource.switchOn
        // color option added!
        switchToggle.onTintColor = delegate?.switchColor
    }
    
    func onSwitchToggle(sender: UISwitch) {
        delegate?.onSwitchTogleOn(sender.on)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
