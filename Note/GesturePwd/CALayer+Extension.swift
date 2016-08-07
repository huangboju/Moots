//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension CALayer {
    func shake() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let s = 16
        keyFrameAnimation.values = [0, -s, 0, s, 0, -s, 0, s, 0]
        keyFrameAnimation.duration = 0.1
        keyFrameAnimation.repeatCount = 2
        addAnimation(keyFrameAnimation, forKey: "shake")
    }
}
