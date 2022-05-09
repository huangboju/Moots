//
//  QuartzBezierView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzBezierView: QuartzView {
    override func draw(in context: CGContext) {
        // Drawing with a white stroke color
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context.setLineWidth(2.0)
        
        // Draw a bezier curve with end points s,e and control points cp1,cp2
        var s = CGPoint(x: 30.0, y: 120.0)
        var e = CGPoint(x: 300.0, y: 120.0)
        var cp1 = CGPoint(x: 120.0, y: 30.0)
        let cp2 = CGPoint(x: 210.0, y: 210.0)
        context.move(to: s)
        context.addCurve(to: e, control1: cp1, control2: cp2)
        context.strokePath()

        // Show the control points.
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.move(to: s)
        context.addLine(to: cp1)
        context.move(to: e)
        context.addLine(to: cp2)
        context.strokePath()

        // Draw a quad curve with end points s,e and control point cp1
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        s = CGPoint(x: 30.0, y: 300.0)
        e = CGPoint(x: 270.0, y: 300.0)
        cp1 = CGPoint(x: 150.0, y: 180.0)
        context.move(to: s)
        context.addQuadCurve(to: e, control: cp1)
        context.strokePath()

        // Show the control point.
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.move(to: s)
        context.addLine(to: cp1)
        context.strokePath()
    }
}
