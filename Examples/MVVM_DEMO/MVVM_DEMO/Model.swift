//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

struct Model: SwitchCellDatasorce {
    var title = "Minion Mode!!!"
    var switchOn = true
}

extension Model: SwitchCellDelegate {
    
    func onSwitchTogleOn(_ on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
    
}
