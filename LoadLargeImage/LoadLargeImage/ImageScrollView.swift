//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ImageScrollView: UIScrollView {
    var frontTiledView: TiledImageView?
    // The old TiledImageView that we draw on top of when the zooming stops
    var backTiledView: TiledImageView?
    // A low res version of the image that is displayed until the TiledImageView
    // renders its content.
    var backgroundImageView: UIImageView?
    var minimumScale: CGFloat!
    // current image zoom scale
    var imageScale: CGFloat!
    var image: UIImage?
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollViewDecelerationRateFast
        delegate = self
        maximumZoomScale = 5.0
        minimumZoomScale = 0.25
        
        backgroundColor = UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1)
        
        self.image = image
        if let cgImage = image.cgImage {
            let cgImageWidth = CGFloat(cgImage.width)
            let cgImageHeight = CGFloat(cgImage.height)
            var imageRect = CGRect(x: 0, y: 0, width: cgImageWidth, height: cgImageHeight)
            
            imageScale = frame.width / imageRect.width
            minimumScale = imageScale * 0.75
            print("imageScale:", imageScale)
            imageRect.size = CGSize(width: imageRect.width*imageScale, height: imageRect.height*imageScale)
            
            UIGraphicsBeginImageContext(imageRect.size)
            
            let context = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.draw(cgImage, in: imageRect)
            context.restoreGState()
            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView?.frame = imageRect
            backgroundImageView?.contentMode = .scaleAspectFit
            
            addSubview(backgroundImageView!)
            sendSubview(toBack: backgroundImageView!)
            
            frontTiledView = TiledImageView(frame: imageRect, image: image, scale: imageScale)
            addSubview(frontTiledView!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let boundsSize = bounds.size
        var frameToCenter = frontTiledView!.frame
        // center horizontally
        if frameToCenter.width < boundsSize.width {
            frameToCenter.origin.x = boundsSize.width - frameToCenter.width / 2
        } else {
            frameToCenter.origin.x = 0
        }

        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        frontTiledView?.frame = frameToCenter
        backgroundImageView?.frame = frameToCenter
        frontTiledView?.contentScaleFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return frontTiledView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageScale! *= scale
        if imageScale < minimumScale {
            imageScale = minimumScale
        }
        guard let cgImage = image?.cgImage else {
            return
        }
        let imageRect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        frontTiledView = TiledImageView(frame: imageRect, image: image!, scale: imageScale)
        addSubview(frontTiledView!)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        backTiledView?.removeFromSuperview()
        backTiledView = frontTiledView
    }
}
