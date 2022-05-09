//
//  QuartzPatternView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzPatternView: QuartzView {
    
    
    // Colored patterns specify colors as part of their drawing
    private let ColoredPatternCallback: CGPatternDrawPatternCallback = { _ , context in
        // Dark Blue
        context.setFillColor(red: 29.0 / 255.0, green: 156.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.00)
        context.fill(CGRect(0.0, 0.0, 8.0, 8.0))
        context.fill(CGRect(8.0, 8.0, 8.0, 8.0))

        // Light Blue
        context.setFillColor(red: 204.0 / 255.0, green: 224.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.00)
        context.fill(CGRect(8.0, 0.0, 8.0, 8.0))
        context.fill(CGRect(0.0, 8.0, 8.0, 8.0))
    }
    
    // Uncolored patterns take their color from the given context
   private let UncoloredPatternCallback: CGPatternDrawPatternCallback = { _ , context in
        context.fill(CGRect(0.0, 0.0, 8.0, 8.0))
        context.fill(CGRect(8.0, 8.0, 8.0, 8.0))
        context.fill(CGRect(0.0, 0.0, 8.0, 8.0))
        context.fill(CGRect(8.0, 8.0, 8.0, 8.0))
    }

    private var  _uncoloredPatternColorSpace: CGColorSpace?
    
    private var uncoloredPatternColorSpace: CGColorSpace {
        if _uncoloredPatternColorSpace == nil {
            // With an uncolored pattern we still need to create a pattern colorspace, but now we need a parent colorspace
            // We'll use the DeviceRGB colorspace here. We'll need this colorspace along with the CGPatternRef to draw this pattern later.
            let deviceRGB = CGColorSpaceCreateDeviceRGB()
            _uncoloredPatternColorSpace = CGColorSpace(patternBaseSpace: deviceRGB)
        }
        
        return _uncoloredPatternColorSpace!
    }
    
    private var _uncoloredPattern: CGPattern?
    
    private var uncoloredPattern: CGPattern {
        if _uncoloredPattern == nil {
            var uncoloredPatternCallbacks = CGPatternCallbacks(version: 0, drawPattern: UncoloredPatternCallback, releaseInfo: nil)
            // As above, we create a CGPatternRef that specifies the qualities of our pattern
            _uncoloredPattern = CGPattern(
                info: nil, // 'info' pointer
                bounds: CGRect(0.0, 0.0, 16.0, 16.0), // coordinate space
                matrix: .identity, // transform
                xStep: 16.0, yStep: 16.0, // spacing
                tiling: .noDistortion,
                isColored: false, // this is an uncolored pattern, thus to draw it we need to specify both color and alpha
                callbacks: &uncoloredPatternCallbacks); // callbacks for this pattern
        }

        return _uncoloredPattern!
    }
    
    private var _coloredPatternColor: CGColor?
    
    private var coloredPatternColor: CGColor {
        // Colored Pattern setup
        if _coloredPatternColor == nil {
            var coloredPatternCallbacks = CGPatternCallbacks(version: 0, drawPattern: ColoredPatternCallback, releaseInfo: nil)
            // First we need to create a CGPatternRef that specifies the qualities of our pattern.
            
            let coloredPattern = CGPattern(info: nil, // 'info' pointer for our callback
                bounds: CGRect(0.0, 0.0, 16.0, 16.0), // the pattern coordinate space, drawing is clipped to this rectangle
                matrix: .identity, // a transform on the pattern coordinate space used before it is drawn.
                xStep: 16, yStep: 16, // the spacing (horizontal, vertical) of the pattern - how far to move after drawing each cell
                tiling: .noDistortion,
                isColored: true, // this is a colored pattern, which means that you only specify an alpha value when drawing it
                callbacks: &coloredPatternCallbacks) // the callbacks for this pattern.

            // To draw a pattern, you need a pattern colorspace.
            // Since this is an colored pattern, the parent colorspace is NULL, indicating that it only has an alpha value.
            let coloredPatternColorSpace = CGColorSpace(patternBaseSpace: nil)
            var alpha: CGFloat = 1.0
            // Since this pattern is colored, we'll create a CGColorRef for it to  drawing it easier and more efficient.
            // From here on, the colored pattern is referenced entirely via the associated CGColorRef rather than the
            // originally created CGPatternRef.

            _coloredPatternColor = CGColor(patternSpace: coloredPatternColorSpace!, pattern: coloredPattern!, components: &alpha)
        }
        return _coloredPatternColor!
    }
    
    override func draw(in context: CGContext) {
        // Draw the colored pattern. Since we have a CGColorRef for this pattern, we just set
        // that color current and draw.
        context.setFillColor(coloredPatternColor)
        context.fill(CGRect(10.0, 10.0, 90.0, 90.0))

        // You can also stroke with a pattern.
        context.setStrokeColor(coloredPatternColor)
        context.stroke(CGRect(120.0, 10.0, 90.0, 90.0), width: 8.0)
        
        // Since we aren't encapsulating our pattern in a CGColorRef for the uncolored pattern case, setup requires two steps.
        // First you have to set the context's current colorspace (fill or stroke) to a pattern colorspace,
        // indicating to Quartz that you want to draw a pattern.
        context.setFillColorSpace(uncoloredPatternColorSpace)
        // Next you set the pattern and the color that you want the pattern to draw with.
        let color1: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
        context.setFillPattern(uncoloredPattern, colorComponents: color1)
        // And finally you draw!
        context.fill(CGRect(10.0, 120.0, 90.0, 90.0))
        // As long as the current colorspace is a pattern colorspace, you are free to change the pattern or pattern color
        let color2: [CGFloat] = [0.0, 1.0, 0.0, 1.0]
        context.setFillPattern(uncoloredPattern, colorComponents: color2)
        context.fill(CGRect(10.0, 230.0, 90.0, 90.0))

        // And of course, just like the colored case, you can stroke with a pattern as well.
        context.setStrokeColorSpace(uncoloredPatternColorSpace)
        context.setStrokePattern(uncoloredPattern, colorComponents: color1)
        context.stroke(CGRect(120.0, 120.0, 90.0, 90.0), width: 8.0)
        // As long as the current colorspace is a pattern colorspace, you are free to change the pattern or pattern color
        context.setStrokePattern(uncoloredPattern, colorComponents: color2)
        context.stroke(CGRect(120.0, 230.0, 90.0, 90.0), width: 8.0)
    }
}
