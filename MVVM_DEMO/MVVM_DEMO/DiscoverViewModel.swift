//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

struct DiscoverViewModel: DiscoverCellDataSource {
    var title: String = "星期一"
    var selected: Bool = false
}

extension DiscoverViewModel: DiscoverCellDelegate {
    func didSelected(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            sender.backgroundColor = .blueColor()
        } else {
            sender.backgroundColor = .redColor()
        }
    }
    
    
    
    var selectedColor: UIColor {
        return .redColor()
    }
}