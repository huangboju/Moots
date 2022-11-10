//
//  QuartzBlendingView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzBlendingView: QuartzView {
    
    public var sourceColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    public var destinationColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    public var blendMode: CGBlendMode = .normal {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in context: CGContext) {
        // Start with a background whose color we don't use in the demo
        context.setFillColor(gray: 0.2, alpha: 1.0)
        context.fill(bounds)
        // We want to just lay down the background without any blending so we use the Copy mode rather than Normal
        context.setBlendMode(.copy)
        // Draw a rect with the "background" color - this is the "Destination" for the blending formulas
        context.setFillColor(destinationColor.cgColor)
        context.fill(CGRect(110.0, 20.0, 100.0, 100.0))
        // Set up our blend mode
        context.setBlendMode(blendMode)
        // And draw a rect with the "foreground" color - this is the "Source" for the blending formulas
        context.setFillColor(sourceColor.cgColor)
        context.fill(CGRect(60.0, 45.0, 200.0, 50.0))
    }
}
