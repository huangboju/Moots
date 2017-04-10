//
//  QuartzClippingView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzClippingView: QuartzView {
    
    private var _image: CGImage?
    
    var image: CGImage {
        if _image == nil {
            let imagePath = Bundle.main.path(forResource: "Ship.png", ofType: nil)
            let img = UIImage(contentsOfFile: imagePath!)
            _image = img?.cgImage
        }
        return _image!
    }
    
    func addStar(to context: CGContext, at center: CGPoint, radius: CGFloat, angle:CGFloat) {
        let n = Float(angle * .pi / 5.0)
        let x = radius * CGFloat(sinf(n)) + center.x
        let y = radius * CGFloat(cosf(n)) + center.y
        context.move(to: CGPoint(x, y))
        
        let m = Float(4.0 * .pi + angle)
        for i in 1 ..< 5 {
            let x = radius * CGFloat(sinf((Float(i) * m) / 5.0)) + center.x
            let y = radius * CGFloat(cosf((Float(i) * m) / 5.0)) + center.y
            context.addLine(to: CGPoint(x, y))
        }
        // And close the subpath.
        context.closePath()
    }

    override func draw(in context: CGContext) {
        // NOTE
        // So that the images in this demo appear right-side-up, we flip the context
        // In doing so we need to specify all of our Y positions relative to the height of the view.
        // The value we subtract from the height is the Y coordinate for the *bottom* of the image.
        let height = bounds.height
        context.translateBy(x: 0.0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        // We'll draw the original image for comparision
        context.draw(image, in: CGRect(10.0, height - 100.0, 90.0, 90.0))

        // First we'll use clipping rectangles to remove the body of the ship.
        // We use CGContextClipToRects() to clip to a set of rectangles.
        
        context.saveGState()
        // For this operation we extract the 35 pixel strip on each side of the source image.
        let clips: [CGRect] =
            [
                CGRect(110.0, height - 100.0, 35.0, 90.0),
                CGRect(165.0, height - 100.0, 35.0, 90.0),
        ]
        // While convinient, this is just the equivalent of adding each rectangle to the current path,
        // then calling CGContextClip().
        context.clip(to: clips)
        context.draw(image, in: CGRect(110.0, height - 100.0, 90.0, 90.0))
        context.restoreGState()

        // You can also clip to aribitrary shapes, which can be useful for special effects.
        // In this case we are going to clip to a star.
        // We will actually clip the image twice, using the different clipping modes.
        addStar(to: context, at: CGPoint(55.0, height - 150.0), radius: 45, angle: 0)
        context.saveGState()
        
        // Clip to the current path using the non-zero winding number rule.
        context.clip()
        
        // To  the area we draw to a bit more obvious, we'll the image over a red rectangle.
        context.fill(CGRect(10.0, height - 190.0, 90.0, 90.0))
        
        // And finally draw the image
        context.draw(image, in: CGRect(10.0, height - 190.0, 90.0, 90.0))
        context.restoreGState()

        addStar(to: context, at: CGPoint(155.0, height - 150.0), radius: 45, angle: 0)
        context.saveGState()
        
        // Clip to the current path using the even-odd rule.
        context.clip(using: .evenOdd)
        
        // To  the area we draw to a bit more obvious, we'll the image over a red rectangle.
        context.fill(CGRect(110.0, height - 190.0, 90.0, 90.0))
        
        // And finally draw the image
        context.draw(image, in: CGRect(110.0, height - 190.0, 90.0, 90.0))
        context.restoreGState()
        
        // Finally making the path slightly more complex by enscribing it in a rectangle changes what is clipped
        // For EO clipping mode this will invert the clip (for non-zero winding this is less predictable).
        addStar(to: context, at: CGPoint(255.0, height - 150.0), radius: 45, angle: 0)
        context.addRect(CGRect(210, height - 190, 90, 90))
        context.saveGState()

        // Clip to the current path using the even-odd rule.
        context.clip(using: .evenOdd)

        // To  the area we draw to a bit more obvious, we'll the image over a red rectangle.
        context.fill(CGRect(210.0, height - 190.0, 90.0, 90.0))
        
        // And finally draw the image
        context.draw(image, in: CGRect(210.0, height - 190.0, 90.0, 90.0))
        context.restoreGState()
    }
}
