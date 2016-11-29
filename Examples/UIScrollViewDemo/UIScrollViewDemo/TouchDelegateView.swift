//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class TouchDelegateView: UIView {
    
    var touchDelegateView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let touchDelegateView = touchDelegateView {
            if self.point(inside: point, with: event) {
                //[fromView convertPoint:aPoint toView:toView]
                //就是将fromView坐标系中的一个点转换为toView中的一个点
                let newPoint = convert(point, to: touchDelegateView)
                let test = touchDelegateView.hitTest(newPoint, with: event)
                if let test = test {
                    return test
                } else {
                    return touchDelegateView
                }
            }
        }
        return super.hitTest(point, with: event)
    }
}

/*
 1、如fromView是nil，则返回CGrectZero。
 这种情况发生在view的init方法中; [self.superView convertPoint:aPoint toView:toView];
 此时的self.superView是nil。
 2、如果toView是nil则相当于：[fromView convertPoint:aPoint toView:selfView.window];
 所以如果要将坐标转为相对于窗口的坐标，则只要如下就可以了：
 [fromView convertPoint:aPoint toView:nil];
 
 3、fromView和toView还没有放到一个view中去，也就是没有对它们执行addSubview方法，此时它们的superView是nil。这种情况一定要小心了，
 尽量不要这么作，因为view还没有建立明确的相对坐标系，这时cocoa框架一定很抓狂，作了很多假设，一般是以创建fromView和toView的那个view作为superView来处理的，但是并不确定。 
 */

/*
 View.isHidden=YES View.alpha<=0.01 View.userInterfaceEnable=NO View.enable = NO(指继承自UIControl的View)的这4种情况下,View的pointInside返回NO，hitTest方法返回nil
 
 文／pican（简书作者）
 原文链接：http://www.jianshu.com/p/2dda99a0e09a
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */
