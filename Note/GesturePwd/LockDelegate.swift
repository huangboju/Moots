//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol LockDelegate {
    var hideBarBottomLine: Bool { get }
    var barTintColor: UIColor { get }
    var barTittleColor: UIColor {  get }
    var barTittleFont: UIFont { get }
}

extension LockDelegate {
    var hideBarBottomLine: Bool {
        return false
    }
    
    var barTintColor: UIColor {
        return UIColor.redColor()
    }
    
    var barTittleFont: UIFont {
        return UIFont.systemFontOfSize(18)
    }
}
