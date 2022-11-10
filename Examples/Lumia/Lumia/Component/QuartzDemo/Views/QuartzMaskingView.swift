//
//  QuartzMaskingView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzMaskingView: QuartzView {

    private var maskingImage: CGImage {
        if _maskingImage == nil {
            createImages()
        }
        return _maskingImage!
    }
    
    
    private var alphaImage: CGImage {
        if _alphaImage == nil {
            createImages()
        }
        return _alphaImage!
    }

    private var _alphaImage: CGImage?
    private var _maskingImage: CGImage?

    func createImages() {
        // Load the alpha image, which is just the same Ship.png image used in the clipping demo
        
        let imagePath = Bundle.main.path(forResource: "Ship", ofType: "png")
        let img = UIImage(contentsOfFile: imagePath!)
        _alphaImage = img?.cgImage
        
        // To show the difference with an image mask, we take the above image and process it to extract
        // the alpha channel as a mask.
        // Allocate data

        var data = Data(count: 90 * 90 * 1)
        // Create a bitmap context
        let colorSpace = CGColorSpace(patternBaseSpace: nil)
        let context = CGContext(data: &data, width: 90, height: 90, bitsPerComponent: 9, bytesPerRow: 90, space: colorSpace!, bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue)
        // Set the blend mode to copy to avoid any alteration of the source data
        context?.setBlendMode(.copy)
        // Draw the image to extract the alpha channel
        context?.draw(_alphaImage!, in: CGRect(0.0, 0.0, 90.0, 90.0))
        // Now the alpha channel has been copied into our NSData object above, so discard the context and lets  an image mask.
        
        // Create a data provider for our data object (NSMutableData is tollfree bridged to CFMutableDataRef, which is compatible with CFDataRef)
        let dataProvider = CGDataProvider(data: data as CFData)
        // Create our new mask image with the same size as the original image
        
        _maskingImage = CGImage(maskWidth: 90, height: 90, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: 90, provider: dataProvider!, decode: nil, shouldInterpolate: true)
    }

    override func draw(in context: CGContext) {
        // NOTE
        // So that the images in this demo appear right-side-up, we flip the context
        // In doing so we need to specify all of our Y positions relative to the height of the view.
        // The value we subtract from the height is the Y coordinate for the *bottom* of the image.
        let height = bounds.height
        context.translateBy(x: 0.0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Quartz also allows you to mask to an image or image mask, the primary difference being
        // how the image data is interpreted. Note that you can use any image
        // When you use a regular image, the alpha channel is interpreted as the alpha values to use,
        // that is a 0.0 alpha indicates no pass and a 1.0 alpha indicates full pass.
        context.saveGState()
        context.clip(to: CGRect(10.0, height - 100.0, 90.0, 90.0), mask: alphaImage)
        // Because we're clipping, we aren't going to be particularly careful with our rect.
        context.fill(bounds)
        context.restoreGState()
        
        context.saveGState()
        // You can also use the clip rect given to scale the mask image
        context.clip(to: CGRect(110.0, height - 190.0, 180.0, 180.0), mask: alphaImage)
        // As above, not being careful with bounds since we are clipping.
        context.fill(bounds)
        context.restoreGState()
        
        // Alternatively when you use a mask image the mask data is used much like an inverse alpha channel,
        // that is 0.0 indicates full pas and 1.0 indicates no pass.
        context.saveGState()
        context.clip(to: CGRect(10.0, height - 300.0, 90.0, 90.0), mask: maskingImage)
        // Because we're clipping, we aren't going to be particularly careful with our rect.
        context.fill(bounds)
        context.restoreGState()
        
        context.saveGState()
        // You can also use the clip rect given to scale the mask image
        context.clip(to: CGRect(110.0, height - 390.0, 180.0, 180.0), mask: maskingImage)
        // As above, not being careful with bounds since we are clipping.
        context.fill(bounds)
        context.restoreGState()
    }
}
