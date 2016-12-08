//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class LayoutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let subview = UIView()
        view.addSubview(subview)
        subview.backgroundColor = UIColor.red
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        // item1.attribute1 = multiplier × item2.attribute2 + constant

        let height1 = NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        let width1 = NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)

        let centerX = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        subview.addConstraints([height1, width1])
        subview.superview!.addConstraints([centerX, centerY])
        
        /*
            NSLayoutAttributeLeading
            在习惯由左向右看的地区，相当于NSLayoutAttributeLeft。在习惯从右至左看的地区，相当于NSLayoutAttributeRight

            NSLayoutAttributeTrailing
            在习惯由左向右看的地区，相当于NSLayoutAttributeRight。在习惯从右至左看的地区，相当于NSLayoutAttributeLeft
         
            文／扭只好（简书作者）
            原文链接：http://www.jianshu.com/p/2ca8ab057511
            著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
         */
        
        let blueView = UIView()
        blueView.backgroundColor = UIColor.blue
        view.addSubview(blueView)//系统默认会给autoresizing 约束
        // 关闭autoresizing 不关闭否则程序崩溃
        blueView.translatesAutoresizingMaskIntoConstraints = false

        //宽度约束
        let width = NSLayoutConstraint(item: blueView, attribute: .width, relatedBy:.equal, toItem:nil, attribute: .notAnAttribute, multiplier:0.0, constant:200)
        
        blueView.addConstraint(width)//自己添加约束
        
        //高度约束
        let height = NSLayoutConstraint(item: blueView, attribute: .height, relatedBy:.equal, toItem: nil, attribute: .notAnAttribute, multiplier:0.0, constant:200)
        
        blueView.addConstraint(height)//自己添加约束
        
        //右边约束
        let right = NSLayoutConstraint(item: blueView, attribute: .centerX, relatedBy:.equal, toItem: view, attribute: .centerX, multiplier:1.0, constant: 0)

        blueView.superview!.addConstraint(right)//父控件添加约束

        //下边约束
        let bottom = NSLayoutConstraint(item: blueView, attribute: .top, relatedBy:.equal, toItem:subview, attribute: .bottom, multiplier:1.0, constant: 20)

        blueView.superview!.addConstraint(bottom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
