//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .Center
        backgroundColor = CoreLockViewBgColor
    }
    
    func showNormal(message: String?) {
        text = message
        textColor = CoreLockNormalColor
    }
    
    func showWarn(message: String?) {
        text = message
        textColor = CoreLockWarnColor
        layer.shake()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
