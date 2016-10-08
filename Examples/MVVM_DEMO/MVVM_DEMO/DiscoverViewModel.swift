//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

struct DiscoverViewModel: DiscoverCellDataSource {
    var title: String = "星期一"
    var selected: Bool = false
}

extension DiscoverViewModel: DiscoverCellDelegate {
    func didSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = .blue
        } else {
            sender.backgroundColor = .red
        }
    }
    
    
    
    var selectedColor: UIColor {
        return .red
    }
}
