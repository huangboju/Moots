//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class LockInfoView: UIView {
    
    private var options: LockOptions?
    
    init(frame: CGRect, options: LockOptions) {
        super.init(frame: frame)
        backgroundColor = options.backgroundColor
        self.options = options
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, self.options?.arcLineWidht ?? 1)
        
        self.options?.normalTitleColor.set()
        
        let path = CGPathCreateMutable()
        
        let marginV: CGFloat = 3
        let padding: CGFloat = 1
        let rectWH = (rect.width - marginV * 2 - padding * 2) / 3
        
        for idx in 0..<9 {
            let row = CGFloat(idx % 3)
            let col = CGFloat(idx / 3)
            let rectX = (rectWH + marginV) * row + padding
            let rectY = (rectWH + marginV) * col + padding
            let rect = CGRect(x: rectX, y: rectY, width: rectWH, height: rectWH)
            CGPathAddEllipseInRect(path, nil, rect)
        }
        
        //添加路径
        CGContextAddPath(context, path)
        
        //绘制路径
        CGContextStrokePath(context)
    }
}






