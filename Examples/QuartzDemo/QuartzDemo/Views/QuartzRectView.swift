//
//  QuartzRectView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzRectView: QuartzView {

    override func draw(in context: CGContext) {
        // Drawing with a white stroke color
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // And drawing with a blue fill color
        context.setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context.setLineWidth(2.0)
        
        // Add Rect to the current path, then stroke it
        context.addRect(CGRect(x: 30.0, y: 30.0, width: 60.0, height: 60.0))
        context.strokePath()
        
        // Stroke Rect convenience that is equivalent to above
        context.stroke(CGRect(x: 30.0, y: 120.0, width: 60.0, height: 60.0))
        
        // Stroke rect convenience equivalent to the above, plus a call to CGContextSetLineWidth().
        context.stroke(CGRect(x: 30.0, y: 210.0, width: 60.0, height: 60.0), width: 10.0)
        // Demonstate the stroke is on both sides of the path.
        context.saveGState()
        context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        context.stroke(CGRect(x: 30.0, y: 210.0, width: 60.0, height: 60.0), width: 2.0)
        context.restoreGState()

        
        context.setStrokeColor(UIColor.yellow.cgColor)
        let rects: [CGRect] =
            [
                CGRect(x: 120.0, y: 30.0, width: 60.0, height: 60.0),
                CGRect(x: 120.0, y: 120.0, width: 60.0, height: 60.0),
                CGRect(x: 120.0, y: 210.0, width: 60.0, height: 60.0),
        ]
        // Bulk call to add rects to the current path.
        context.addRects(rects)
        context.strokePath()

        
        // Create filled rectangles via two different paths.
        // Add/Fill path
        context.addRect(CGRect(x: 210.0, y: 30.0, width: 60.0, height: 60.0))
        context.fillPath()
        // Fill convienience.
        context.fill(CGRect(x: 210.0, y: 120.0, width: 60.0, height: 60.0))
    }
}
