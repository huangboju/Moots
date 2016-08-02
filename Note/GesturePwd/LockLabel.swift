//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockLabel: UILabel {
    
    var options: LockOptions!
    
    init(frame: CGRect, options: LockOptions) {
        super.init(frame: frame)
        textAlignment = .Center
        backgroundColor = options.backgroundColor
        self.options = options
    }
    
    func showNormal(message: String?) {
        text = message
        textColor = options.normalTitleColor
    }
    
    func showWarn(message: String?) {
        text = message
        textColor = options.warningTitleColor
        layer.shake()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
