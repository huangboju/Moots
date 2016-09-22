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
            
            imageRect.size = CGSize(width: imageRect.width*imageScale, height: imageRect.height*imageScale)
            
            UIGraphicsBeginImageContext(imageRect.size)
            
            guard let context = UIGraphicsGetCurrentContext() else  {
                return
            }
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
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageScrollView: UIScrollViewDelegate {

}
