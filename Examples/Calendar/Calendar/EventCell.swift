//
//  EventCell.swift
//  Calendar
//
//  Created by 伯驹 黄 on 2016/11/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.y = 8
        detailTextLabel?.frame.origin.y = frame.height - 8 - (detailTextLabel?.frame.height ?? 0)
    }

}
