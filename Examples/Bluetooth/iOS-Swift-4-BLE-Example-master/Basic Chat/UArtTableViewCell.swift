//
//  UArtTableViewCell.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 2/16/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit

class UArtTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
