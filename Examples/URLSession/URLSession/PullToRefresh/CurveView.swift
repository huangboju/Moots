//
//  CurveView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

class CurveView: UIView {
    var progress: CGFloat = 0.0 {
        didSet {
            curveLayer.progress = progress
            curveLayer.setNeedsDisplay()
        }
    }

    fileprivate var curveLayer: CurveLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        curveLayer = CurveLayer()
        curveLayer.frame = bounds
        curveLayer.contentsScale = UIScreen.main.scale
        curveLayer.progress = 0.0
        curveLayer.setNeedsDisplay()
        layer.addSublayer(curveLayer)
    }
}
