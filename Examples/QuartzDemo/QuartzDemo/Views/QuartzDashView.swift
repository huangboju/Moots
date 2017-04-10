//
//  QuartzDashView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzDashView: QuartzView {
    public var dashPhase: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var dashPattern: [CGFloat] = [10, 10]

    func setDashPattern(pattern: [CGFloat], count: Int) {
        if count != dashPattern.count {
            dashPattern = pattern
            setNeedsDisplay()
        }
    }

    override func draw(in context: CGContext) {
        // Drawing lines with a white stroke color
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Each dash entry is a run-length in the current coordinate system
        // The concept is first you determine how many points in the current system you need to fill.
        // Then you start consuming that many pixels in the dash pattern for each element of the pattern.
        // So for example, if you have a dash pattern of {10, 10}, then you will draw 10 points, then skip 10 points, and repeat.
        // As another example if your dash pattern is {10, 20, 30}, then you draw 10 points, skip 20 points, draw 30 points,
        // skip 10 points, draw 20 points, skip 30 points, and repeat.
        // The dash phase factors into this by stating how many points into the dash pattern to skip.
        // So given a dash pattern of {10, 10} with a phase of 5, you would draw 5 points (since phase plus 5 yields 10 points),
        // then skip 10, draw 10, skip 10, draw 10, etc.

        context.setLineDash(phase: dashPhase, lengths: dashPattern)

        // Draw a horizontal line, vertical line, rectangle and circle for comparison
        context.move(to: CGPoint(x: 10, y: 20))
        context.addLine(to: CGPoint(x: 310, y: 20))
        context.move(to: CGPoint(x: 160, y: 30))
        context.addLine(to: CGPoint(x: 160, y: 130))
        context.addRect(CGRect(x: 10.0, y: 30.0, width: 100.0, height: 100.0))
        context.addEllipse(in: CGRect(x: 210.0, y: 30.0, width: 100.0, height: 100.0))
        // And width 2.0 so they are a bit more visible
        context.setLineWidth(2.0)
        context.strokePath()
    }
}
