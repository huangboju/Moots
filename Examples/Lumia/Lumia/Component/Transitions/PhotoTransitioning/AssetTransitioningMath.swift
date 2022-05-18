/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Convenience math operators
*/

import QuartzCore

func clip<T : Comparable>(_ x0: T, _ x1: T, _ v: T) -> T {
    return max(x0, min(x1, v))
}

func lerp<T : FloatingPoint>(_ v0: T, _ v1: T, _ t: T) -> T {
    return v0 + (v1 - v0) * t
}

public extension CGVector {
    func subtract(rhs: CGVector) -> CGVector {
        return CGVector(dx: dx - rhs.dx, dy: dy - rhs.dy)
    }
}

extension CGPoint {
    func add(rhs: CGVector) -> CGPoint {
        return CGPoint(x: x + rhs.dx, y: y + rhs.dy)
    }
}


func +(lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x + rhs.x, dy: lhs.y + rhs.y)
}



func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func *(left: CGVector, right:CGFloat) -> CGVector {
    return CGVector(dx: left.dx * right, dy: left.dy * right)
}

extension CGPoint {
    var vector: CGVector {
        return CGVector(dx: x, dy: y)
    }
}

extension CGVector {
    var magnitude: CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    var point: CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    func apply(transform t: CGAffineTransform) -> CGVector {
        return point.applying(t).vector
    }
}


