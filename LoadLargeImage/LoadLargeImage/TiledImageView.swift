//
//  Created by 伯驹 黄 on 16/9/22.
//

class TiledImageView: UIView {
    var imageScale: CGFloat!
    var image: UIImage?
    var imageRect: CGRect!
    
    init(frame: CGRect, image: UIImage, scale: CGFloat) {
        super.init(frame: frame)
        
        self.image = image
        guard let cgImage = image.cgImage else {
            return
        }
        
        imageRect = CGRect(x: 0, y: 0, width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
        imageScale = scale
        let tiledLayer = layer as? CATiledLayer
        tiledLayer?.levelsOfDetail = 4
        tiledLayer?.levelsOfDetailBias = 4
        tiledLayer?.tileSize = CGSize(width: 512.0, height: 512.0)
    }
    
    override var layer: CALayer {
        return CATiledLayer()
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(), let cgImage = image?.cgImage {
            context.saveGState()
            context.scaleBy(x: imageScale, y: imageScale)
            context.draw(cgImage, in: imageRect)
            context.restoreGState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
