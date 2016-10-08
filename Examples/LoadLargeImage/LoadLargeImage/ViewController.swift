//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ViewController: UIViewController {
    
    let kImageFilename = "large_leaves_70mp.jpg"
    let bytesPerMB: CGFloat = 1048576.0
    let bytesPerPixel: CGFloat = 4.0
    let pixelsPerMB: CGFloat = 1048576.0 / 4.0
    let kDestImageSizeMB: CGFloat = 60.0
    let destTotalPixels: CGFloat = 60.0 * 1048576.0 / 4.0
    let tileTotalPixels: CGFloat = 20 * 1048576.0 / 4.0
    let destSeemOverlap: CGFloat = 2
    
    private var sourceImage: UIImage!
    private var sourceResolution = CGSize()
    private var sourceTotalPixels: CGFloat!
    private var sourceTotalMB: CGFloat!
    private var imageScale: CGFloat!
    private var destResolution = CGSize()
    private var destContext: CGContext!
    private var sourceTile = CGRect()
    private var destTile = CGRect()
    private var sourceSeemOverlap: CGFloat!
    private var destImage: UIImage!
    private var scrollView: ImageScrollView!
    
    private lazy var progressView: UIImageView = {
        return UIImageView(frame: self.view.frame)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressView)
        
        DispatchQueue.global().async {
            self.downsize()
        }
    }
    
    func downsize() {
        
        sourceImage = UIImage(contentsOfFile: Bundle.main.path(forResource:kImageFilename, ofType: nil)!)
        
        sourceResolution.width = CGFloat(sourceImage.cgImage!.width)
        sourceResolution.height = CGFloat(sourceImage.cgImage!.height)
        
        sourceTotalPixels = sourceResolution.width * sourceResolution.height
        
        sourceTotalMB = sourceTotalPixels / pixelsPerMB
        
        imageScale = destTotalPixels / sourceTotalPixels
        
        destResolution.width = CGFloat(Int(sourceResolution.width * imageScale))
        destResolution.height = CGFloat(Int(sourceResolution.height * imageScale))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerRow = bytesPerPixel * destResolution.width
        
        let destBitmapData = malloc(Int(bytesPerRow * destResolution.height))

        destContext = CGContext(data: destBitmapData, width: Int(destResolution.width), height: Int(destResolution.height), bitsPerComponent: 8, bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        if destContext == nil {
            free( destBitmapData )
            NSLog("failed to create the output bitmap context!")
        }
        
        destContext.translateBy(x: 0, y: destResolution.height)
        destContext.scaleBy( x: 1.0, y: -1.0)
        
        sourceTile.size.width = sourceResolution.width
        
        sourceTile.size.height = CGFloat(Int(tileTotalPixels / sourceTile.size.width))
        
        sourceTile.origin.x = 0.0
        
        destTile.size.width = destResolution.width
        destTile.size.height = sourceTile.size.height * imageScale
        destTile.origin.x = 0.0
        
        sourceSeemOverlap = CGFloat((destSeemOverlap / destResolution.height) * sourceResolution.height)
        
        var sourceTileImageRef: CGImage!
        
        var iterations = Int(sourceResolution.height / sourceTile.size.height)
        
        let remainder = Int(sourceResolution.height) % Int(sourceTile.size.height)
        
        if remainder > 0 {
            iterations += 1
        }
        
        let sourceTileHeightMinusOverlap = sourceTile.size.height
        
        sourceTile.size.height += sourceSeemOverlap
        destTile.size.height += destSeemOverlap
        
        for y in 0..<iterations {
            sourceTile.origin.y = CGFloat(y) * sourceTileHeightMinusOverlap + sourceSeemOverlap
            
            destTile.origin.y = destResolution.height - (CGFloat(y + 1) * sourceTileHeightMinusOverlap * imageScale + destSeemOverlap)
            
            sourceTileImageRef = sourceImage.cgImage?.cropping(to: sourceTile)
            
            if y == iterations - 1 && remainder > 0 {
                var dify = destTile.size.height
                destTile.size.height = CGFloat(sourceTileImageRef.height) * imageScale
                dify -= destTile.size.height
                destTile.origin.y += dify
            }
            
            destContext.draw(sourceTileImageRef, in: destTile)
            
            if y < iterations - 1 {
                sourceImage = UIImage(contentsOfFile: Bundle.main.path(forResource:kImageFilename, ofType: nil)!)
                DispatchQueue.main.sync {
                    updateScrollView()
                }
            }
        }
        DispatchQueue.main.sync {
            self.initializeScrollView()
        }
    }
    
    func createImageFromContext() {
        if let destImageRef = destContext.makeImage() {
            destImage = UIImage(cgImage: destImageRef, scale: 1, orientation: .downMirrored)
        }
    }

    func updateScrollView() {
        createImageFromContext()
        progressView.image = destImage
    }
    
    func initializeScrollView() {
        progressView.removeFromSuperview()
        createImageFromContext()
        
        // create a scroll view to display the resulting image.
        scrollView = ImageScrollView(frame: view.bounds, image: destImage!)
        view.addSubview(scrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

