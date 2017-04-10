//
//  QuartzTextView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzTextView: QuartzView {
    override func draw(in context: CGContext) {
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // Some initial setup for our text drawing needs.
        // First, we will be doing our drawing in Helvetica-36pt with the MacRoman encoding.
        // This is an 8-bit encoding that can reference standard ASCII characters
        // and many common characters used in the Americas and Western Europe.
        
//        CGContextSelectFont(context, "Helvetica", 36.0, kCGEncodingMacRoman)
        
        // Next we set the text matrix to flip our text upside down. We do this because the context itself
        // is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
        context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        // And now we actually draw some text. This screen will demonstrate the typical drawing modes used.
        context.setTextDrawingMode(.fill)
//        CGContextShowTextAtPoint(context, 10.0, 30.0, kTextString, kTextStringLength)
        context.setTextDrawingMode(.stroke)
//        CGContextShowTextAtPoint(context, 10.0, 70.0, kTextString, kTextStringLength)
//        CGContextSetTextDrawingMode(context, kCGTextFillStroke)
//        CGContextShowTextAtPoint(context, 10.0, 110.0, kTextString, kTextStringLength)
//        
        // Now lets try the more complex Glyph functions. These functions allow you to draw any glyph available in a font,
        // but provide no assistance with converting characters to glyphs or layout, and as such require considerably more knowledge
        // of text to use correctly. Specifically, you need to understand Unicode encoding and how to interpret the information
        // present in the font itself, such as the cmap table.
        // To get you started, we are going to do the minimum necessary to draw a glyphs into the current context.
        let helvetica = CGFont("Helvetica" as CFString)
        context.setFont(helvetica!)
        context.setFontSize(12.0)
        context.setTextDrawingMode(.fill)
        // Next we'll display lots of glyphs from the font.
        var start: CGGlyph = 0
        for y in 0 ..< 20 {
            var glyphs = [CGGlyph](repeating: CGGlyph(), count: 32)
            for i in 0 ..< 32 {
                glyphs[i] = start + UInt16(i)
            }
            start += 32
            context.showGlyphs(glyphs, at: [CGPoint(10, 150.0 + 12 * CGFloat(y))])
        }
    }
}
