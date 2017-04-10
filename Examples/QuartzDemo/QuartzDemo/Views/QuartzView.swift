//
//  QuartzView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzView: UIView {
    
    /*
     Common view properties are set in the storyboard.
     backgroundColor = [UIColor blackColor];
     opaque = YES;
     clearsContextBeforeDrawing = YES;
     */
    
    /*
     Because we use the CGContext a lot, it is convienient for our demonstration classes to do the real work inside of a method that passes the context as a parameter, rather than having to query the context continuously, or setup that parameter for every subclass.
     */
    
    // As a matter of convinience we'll do all of our drawing here in subclasses of QuartzView.
    func draw(in context: CGContext) {
        // Default is to do nothing.
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("nil")
            return
        }
        draw(in: context)
    }
}

extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
}

extension CGSize {
    init(_ w: CGFloat, _ h: CGFloat) {
        self.init(width: w, height: h)
    }
}

extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}


