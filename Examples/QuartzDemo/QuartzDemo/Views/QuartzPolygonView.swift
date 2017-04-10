//
//  QuartzPolygonView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzPolygonView: QuartzView {
    
    public var drawingMode: CGPathDrawingMode = .eoFill {
        willSet {
            if drawingMode != newValue {
                setNeedsDisplay()
            }
        }
    }

    override func draw(in context: CGContext) {
        // Drawing with a white stroke color
        context.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
        // Drawing with a blue fill color
        context.setFillColor(red: 0, green: 0, blue: 1, alpha: 1)
        // Draw them with a 2 stroke width so they are a bit more visible.
        context.setLineWidth(2)

        // Add a star to the current path
        var _center = CGPoint(x: 90, y: 90)
        context.move(to: CGPoint(x: _center.x, y: _center.y + 60))

        for i in 1 ..< 5 {
            let n = CGFloat(i) * 4 * .pi / 5
            let x = CGFloat(60 * sinf(Float(n)))
            let y = CGFloat(60 * cosf(Float(n)))
            context.addLine(to: CGPoint(x: _center.x + x, y: _center.y + y))
        }
        // And close the subpath.
        context.closePath()

        // Now add the hexagon to the current path
        _center = CGPoint(x: 210, y: 90)
        context.move(to: CGPoint(x: _center.x, y: _center.y + 60))
        for i in 1 ..< 6 {
            let n = CGFloat(i) * 2 * .pi / 6
            let x = CGFloat(60 * sinf(Float(n)))
            let y = CGFloat(60 * cosf(Float(n)))
            context.addLine(to: CGPoint(x: _center.x + x, y: _center.y + y))
        }
        // And close the subpath.
        context.closePath()

        // Now draw the star & hexagon with the current drawing mode.
        context.drawPath(using: drawingMode)
    }
}
