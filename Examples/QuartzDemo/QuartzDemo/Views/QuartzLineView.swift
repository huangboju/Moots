//
//  QuartzLineView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzLineView: QuartzView {

    override func draw(in context: CGContext) {
        // Drawing lines with a white stroke color
        context.setStrokeColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context.setLineWidth(2.0)

        // Draw a single line from left to right
        context.move(to: CGPoint(x: 10, y: 30))
        context.addLine(to: CGPoint(x: 310, y: 30))
        context.strokePath()

        context.setStrokeColor(UIColor.blue.cgColor)
        // Draw a connected sequence of line segments
        let addLines: [CGPoint] =
            [
                CGPoint(x: 10.0, y: 90.0),
                CGPoint(x: 70.0, y: 60.0),
                CGPoint(x: 130.0, y: 90.0),
                CGPoint(x: 190.0, y: 60.0),
                CGPoint(x: 250.0, y: 90.0),
                CGPoint(x: 310.0, y: 60.0),
        ]
        // Bulk call to add lines to the current path.
        // Equivalent to MoveToPoint(points[0]) for(i=1 i<count ++i) AddLineToPoint(points[i])
        context.addLines(between: addLines)
        context.strokePath()

        context.setStrokeColor(UIColor.red.cgColor)
        // Draw a series of line segments. Each pair of points is a segment
        let strokeSegments: [CGPoint] =
            [
                CGPoint(x: 10.0, y: 150.0),
                CGPoint(x: 70.0, y: 120.0),
                CGPoint(x: 130.0, y: 150.0),
                CGPoint(x: 190.0, y: 120.0),
                CGPoint(x: 250.0, y: 150.0),
                CGPoint(x: 310.0, y: 120.0),
        ]
        // Bulk call to stroke a sequence of line segments.
        // Equivalent to for(i=0 i<count i+=2) { MoveToPoint(point[i]) AddLineToPoint(point[i+1]) StrokePath() }
        context.strokeLineSegments(between: strokeSegments)

        // MARK: - 镂空文字
        let rect = frame
        UIColor.white.setFill()
        context.addArc(center: CGPoint(rect.midX, rect.midY), radius: rect.width/2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.fillPath()

        // Manual offset may need to be adjusted depending on the length of the text
        drawSubtractedText("Foo", in: rect, inContext: context)
    }
    
    func drawSubtractedText(_ text: String, in rect: CGRect, inContext context: CGContext) {
        // Save context state to not affect other drawing operations
        context.saveGState()

        // Magic blend mode
        context.setBlendMode(.destinationOut)
        
        // This seemingly random value adjusts the text
        // vertically so that it is centered in the circle.
        let Y_OFFSET = CGFloat(-2 * text.count + 5)

        // Context translation for label
        let LABEL_SIDE = rect.width
        context.translateBy(x: 0, y: rect.height/2-LABEL_SIDE/2+Y_OFFSET)

        // Label to center and adjust font automatically
        let label = UILabel(frame: CGRect(0, 0, LABEL_SIDE, LABEL_SIDE))

        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.adjustsFontSizeToFitWidth = true
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.layer.draw(in: context)
        
        // Restore the state of other drawing operations
        context.restoreGState()
    }
}
