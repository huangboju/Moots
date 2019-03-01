//
//  CurveLayer.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

let Radius: CGFloat =  10.0
let Space: CGFloat  =  1.0
let LineLength: CGFloat = 30.0
let Degree: CGFloat = .pi / 3

class CurveLayer: CALayer {

    var progress: CGFloat = 0.0

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        let CenterY = frame.height / 2
        UIGraphicsPushContext(ctx)
        let context = UIGraphicsGetCurrentContext()

        // Path 1
        let curvePath1 = UIBezierPath()
        curvePath1.lineCapStyle = .round
        curvePath1.lineJoinStyle = .round
        curvePath1.lineWidth = 2.0

        // arrowPath
        let arrowPath = UIBezierPath()

        let x = frame.width / 2 - Radius
        let piValue = CGFloat.pi * CGFloat(9 / 10)

        if progress <= 0.5 {
            let pointA = CGPoint(x: x, y: CenterY - Space + (1 - 2 * progress) * (CenterY - LineLength) + LineLength)
            let pointB = CGPoint(x: x, y: CenterY - Space + (1 - 2 * progress) * (CenterY - LineLength))
            curvePath1.move(to: pointA)
            curvePath1.addLine(to: pointB)

            // arrow
            arrowPath.move(to: pointB)
            arrowPath.addLine(to: CGPoint(x: pointB.x - 3 * cos(Degree), y: pointB.y + 3 * sin(Degree)))
            curvePath1.append(arrowPath)
        } else if progress > 0.5 {
            let pointA = CGPoint(x: x, y: CenterY - Space + LineLength - LineLength * (progress - 0.5) * 2)
            let pointB = CGPoint(x: x, y: CenterY - Space)
            curvePath1.move(to: pointA)
            curvePath1.addLine(to: pointB)
            curvePath1.addArc(withCenter: CGPoint(x: frame.width / 2, y: CenterY - Space), radius: Radius, startAngle: .pi, endAngle: CGFloat.pi + (piValue * (progress - 0.5) * 2), clockwise: true)

            // arrow
            arrowPath.move(to: curvePath1.currentPoint)
            arrowPath.addLine(to: CGPoint(x: curvePath1.currentPoint.x - 3 * (cos(Degree - (piValue * (progress - 0.5) * 2))), y: curvePath1.currentPoint.y + 3 * (sin(Degree - (piValue * (progress - 0.5) * 2)))))
            curvePath1.append(arrowPath)
        }

        // Path 2
        let curvePath2 = UIBezierPath()
        curvePath2.lineCapStyle = .round
        curvePath2.lineJoinStyle = .round
        curvePath2.lineWidth = 2.0
        if progress <= 0.5 {
            let pointA = CGPoint(x: frame.width / 2 + Radius, y: 2 * progress * (CenterY + Space - LineLength))
            let pointB = CGPoint(x: frame.width / 2 + Radius, y: LineLength + 2 * progress * (CenterY + Space - LineLength))
            curvePath2.move(to: pointA)
            curvePath2.addLine(to: pointB)

            // arrow
            arrowPath.move(to: pointB)
            arrowPath.addLine(to: CGPoint(x: pointB.x + 3 * cos(Degree), y: pointB.y - 3 * sin(Degree)))
            curvePath2.append(arrowPath)
        }

        if progress > 0.5 {
            curvePath2.move(to: CGPoint(x: frame.width / 2 + Radius, y: CenterY + Space - LineLength + LineLength * (progress - 0.5) * 2))
            curvePath2.addLine(to: CGPoint(x: frame.width / 2 + Radius, y: CenterY + Space))
            curvePath2.addArc(withCenter: CGPoint(x: frame.width / 2, y: (CenterY + Space)), radius: Radius, startAngle: 0, endAngle: piValue * (progress - 0.5) * 2, clockwise: true)

            // arrow
            arrowPath.move(to: curvePath2.currentPoint)
            arrowPath.addLine(to: CGPoint(x: curvePath2.currentPoint.x + 3 * (cos(Degree - (piValue * (progress - 0.5) * 2))), y: curvePath2.currentPoint.y - 3 * (sin(Degree - (piValue * (progress - 0.5) * 2)))))
            curvePath2.append(arrowPath)
        }

        context?.saveGState()
        context?.restoreGState()

        UIColor(white: 0.3, alpha: 1).setStroke()
        arrowPath.stroke()
        curvePath1.stroke()
        curvePath2.stroke()

        UIGraphicsPopContext()
    }
}
