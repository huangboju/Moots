//
//  QuartzGradientView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

enum GradientType: Int {
    case linear = 0
    case radial = 1
}

class QuartzGradientView: QuartzView {
    
    public var type: GradientType = .linear {
        didSet {
            if type != oldValue {
                setNeedsDisplay()
            }
        }
    }
    public var extendsPastStart = false {
        didSet {
            if extendsPastStart != oldValue {
                setNeedsDisplay()
            }
        }
    }
    public var extendsPastEnd = false {
        didSet {
            if extendsPastEnd != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    private var _gradient: CGGradient?
    
    var gradient: CGGradient {
        if _gradient == nil {
            let rgb = CGColorSpaceCreateDeviceRGB()
            let colors =
                [
                    UIColor(red: 204.0 / 255.0, green: 224.0 / 255.0, blue: 244.0 / 255.0, alpha: 1).cgColor,
                    UIColor(red: 29.0 / 255.0, green: 156.0 / 255.0, blue: 215.0 / 255.0, alpha: 1).cgColor,
                    UIColor(red: 0, green: 50.0 / 255.0, blue: 126.0 / 255.0, alpha: 1).cgColor
            ] as CFArray
            _gradient = CGGradient(colorsSpace: rgb, colors: colors, locations: nil)
        }
        return _gradient!
    }

    var drawingOptions: CGGradientDrawingOptions {
        var options: UInt32 = 0
        if extendsPastStart {
            options |= CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue
        }
        if extendsPastEnd {
            options |= CGGradientDrawingOptions.drawsAfterEndLocation.rawValue
        }
        return CGGradientDrawingOptions(rawValue: options)
    }

    override func draw(in context: CGContext) {
        // Use the clip bounding box, sans a generous border
        let clip = context.boundingBoxOfClipPath.insetBy(dx: 20.0, dy: 20.0)
        
        var start = CGPoint()
        var end = CGPoint()
        var startRadius: CGFloat = 0
        var endRadius: CGFloat = 0
        
        // Clip to area to draw the gradient, and draw it. Since we are clipping, we save the graphics state
        // so that we can revert to the previous larger area.
        context.saveGState()
        context.clip(to: clip)
        
        let options = drawingOptions
        switch type {
        case .linear:
            // A linear gradient requires only a starting & ending point.
            // The colors of the gradient are linearly interpolated along the line segment connecting these two points
            // A gradient location of 0.0 means that color is expressed fully at the 'start' point
            // a location of 1.0 means that color is expressed fully at the 'end' point.
            // The gradient fills outwards perpendicular to the line segment connectiong start & end points
            // (which is why we need to clip the context, or the gradient would fill beyond where we want it to).
            // The gradient options (last) parameter determines what how to fill the clip area that is "before" and "after"
            // the line segment connecting start & end.
            start = clip.demoLGStart
            end = clip.demoLGEnd
            context.drawLinearGradient(gradient, start: start, end: end, options: options)
            context.restoreGState()
        case .radial:
            // A radial gradient requires a start & end point as well as a start & end radius.
            // Logically a radial gradient is created by linearly interpolating the center, radius and color of each
            // circle using the start and end point for the center, start and end radius for the radius, and the color ramp
            // inherant to the gradient to create a set of stroked circles that fill the area completely.
            // The gradient options specify if this interpolation continues past the start or end points as it does with
            // linear gradients.
            
            start = clip.demoRGCenter
            end = start
            startRadius = clip.demoRGInnerRadius
            endRadius = clip.demoRGOuterRadius
            context.drawRadialGradient(gradient, startCenter: start, startRadius: startRadius, endCenter: end, endRadius: endRadius, options: options)
            context.restoreGState()
        }

        // Show the clip rect
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.stroke(clip, width: 2.0)
    }
}

extension CGRect {
    // Returns an appropriate starting point for the demonstration of a linear gradient
    var demoLGStart: CGPoint {
        return CGPoint(minX, minY + height * 0.25)
    }

    // Returns an appropriate ending point for the demonstration of a linear gradient
    var demoLGEnd: CGPoint {
        return CGPoint(minX, minY + height * 0.75)
    }
    
    // Returns the center point for for the demonstration of the radial gradient
    var demoRGCenter: CGPoint {
        return CGPoint(midX, midY)
    }

    // Returns an appropriate inner radius for the demonstration of the radial gradient
    var demoRGInnerRadius: CGFloat {
        return min(width, height) * 0.125
    }

    // Returns an appropriate outer radius for the demonstration of the radial gradient
    var demoRGOuterRadius: CGFloat {
        return min(width, height) * 0.5
    }
}
