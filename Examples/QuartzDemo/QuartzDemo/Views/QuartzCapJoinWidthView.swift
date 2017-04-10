//
//  QuartzCapJoinWidthView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzCapJoinWidthView: QuartzView {
    public var cap: CGLineCap = .butt {
        didSet {
            if cap != oldValue {
                setNeedsDisplay()
            }
        }
    }
    public var join: CGLineJoin = .miter {
        didSet {
            if join != oldValue {
                setNeedsDisplay()
            }
        }
    }

    public var width: CGFloat = 0 {
        didSet {
            if width != oldValue {
                setNeedsDisplay()
            }
        }
    }

    override func draw(in context: CGContext) {
        // Drawing lines with a white stroke color
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Preserve the current drawing state
        context.saveGState()
        
        // Setup the horizontal line to demostrate caps
        context.move(to: CGPoint(x: 40, y: 30))
        context.addLine(to: CGPoint(x: 280, y: 30))
        
        // Set the line width & cap for the cap demo
        context.setLineWidth(width)
        context.setLineCap(cap)
        context.strokePath()

        // Restore the previous drawing state, and save it again.
        context.restoreGState()

        context.saveGState()

        // Setup the angled line to demonstrate joins
        context.move(to: CGPoint(x: 40, y: 190))
        context.addLine(to: CGPoint(x: 160, y: 70))
        context.addLine(to: CGPoint(x: 280, y: 190))

        // Set the line width & join for the join demo
        context.setLineWidth(width)
        context.setLineJoin(join)
        context.strokePath()

        // Restore the previous drawing state.
        context.restoreGState()
    
        // If the stroke width is large enough, display the path that generated these lines
        if width >= 4.0 // arbitrarily only show when the line is at least twice as wide as our target stroke
        {
            context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            context.move(to: CGPoint(x: 40, y: 30))
            context.addLine(to: CGPoint(x: 280, y: 30))
            context.move(to: CGPoint(x: 40, y: 190))
            context.addLine(to: CGPoint(x: 160, y: 70))
            context.addLine(to: CGPoint(x: 280, y: 190))
            context.setLineWidth(2.0)
            context.strokePath()
        }
    }
}
