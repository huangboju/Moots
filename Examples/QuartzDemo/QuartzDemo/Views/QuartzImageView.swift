//
//  QuartzImageView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzImageView: QuartzView {
    
    private var image: CGImage {
        let imagePath = Bundle.main.path(forResource: "Demo", ofType: "png")
        return UIImage(contentsOfFile: imagePath!)!.cgImage!
    }

    override func draw(in context: CGContext) {
        var imageRect = CGRect()
        imageRect.origin = CGPoint(8.0, 8.0)
        imageRect.size = CGSize(64.0, 64.0)
        
        // Note: The images are actually drawn upside down because Quartz image drawing expects
        // the coordinate system to have the origin in the lower-left corner, but a UIView
        // puts the origin in the upper-left corner. For the sake of brevity (and because
        // it likely would go unnoticed for the image used) this is not addressed here.
        // For the demonstration of PDF drawing however, it is addressed, as it would definately
        // be noticed, and one method of addressing it is shown there.
        
        // Draw the image in the upper left corner (0,0) with size 64x64
        context.draw(image, in: imageRect)

        // Tile the same image across the bottom of the view
        // CGContextDrawTiledImage() will fill the entire clipping area with the image, so to avoid
        // filling the entire view, we'll clip the view to the rect below. This rect extends
        // past the region of the view, but since the view's rectangle has already been applied as a clip
        // to our drawing area, it will be intersected with this rect to form the final clipping area
        context.clip(to: CGRect(0.0, 80.0, bounds.width, bounds.height))
        
        // The origin of the image rect works similarly to the phase parameter for SetLineDash and
        // SetPatternPhase and specifies where in the coordinate system the "first" image is drawn.
        // The size (previously set to 64x64) specifies the size the image is scaled to before being tiled.
        imageRect.origin = CGPoint(32.0, 112.0)
        context.draw(image, in: imageRect, byTiling: true)

        // Highlight the "first" image from the DrawTiledImage call.
        context.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        context.fill(imageRect)
        // And stroke the clipped area
        context.setLineWidth(3.0)
        context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        context.stroke(context.boundingBoxOfClipPath)
    }
}
