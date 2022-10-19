/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Cocoa


class StickerBoardViewController: NSViewController {
  
  @IBOutlet var topLayer: DestinationView!
  @IBOutlet var targetLayer: NSView!
  @IBOutlet var invitationLabel: NSTextField!
  
  enum Appearance {
    static let maxStickerDimension: CGFloat = 150.0
    static let shadowOpacity: Float =  0.4
    static let shadowOffset: CGFloat = 4
    static let imageCompressionFactor = 1.0
    static let maxRotation: UInt32 = 12
    static let rotationOffset: CGFloat = 6
    static let randomNoise: UInt32 = 200
    static let numStars = 20
    static let maxStarSize: CGFloat = 30
    static let randonStarSizeChange: UInt32 = 25
    static let randomNoiseStar: UInt32 = 100
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    topLayer.delegate = self
    configureShadow(targetLayer)
  }
  
  
  
  func configureShadow(_ view: NSView) {
    if let layer = view.layer {
      layer.shadowColor = NSColor.black.cgColor
      layer.shadowOpacity = Appearance.shadowOpacity
      layer.shadowOffset = CGSize(width: Appearance.shadowOffset, height: -Appearance.shadowOffset)
      layer.masksToBounds = false
    }
  }
  
  
  @IBAction func saveAction(_ sender: AnyObject) {
    if let tiffdata = targetLayer.snapshot().tiffRepresentation,
      let bitmaprep = NSBitmapImageRep(data: tiffdata) {
      
      let props = [NSBitmapImageRep.PropertyKey.compressionFactor: Appearance.imageCompressionFactor]
      if let bitmapData = NSBitmapImageRep.representationOfImageReps(in: [bitmaprep], using: .jpeg, properties: props) {
        
        let path: NSString = "~/Desktop/StickerDrag.jpg"
        let resolvedPath = path.expandingTildeInPath
        
        try! bitmapData.write(to: URL(fileURLWithPath: resolvedPath), options: [])
        
        print("Your image has been saved to \(resolvedPath), why not tweet it to us at @raywenderlich #stickerdrag")
        
      }
    }
  }
  
  
}

// MARK: - DestinationViewDelegate
extension StickerBoardViewController: DestinationViewDelegate {
  
  func processImageURLs(_ urls: [URL], center: NSPoint) {
    for (index,url) in urls.enumerated() {
      
      //1.
      if let image = NSImage(contentsOf:url) {
        
        var newCenter = center
        //2.
        if index > 0 {
          newCenter = center.addRandomNoise(Appearance.randomNoise)
        }
        
        //3.
        processImage(image, center:newCenter)
      }
    }
  }
  
  func processImage(_ image: NSImage, center: NSPoint) {
    
    //1.
    invitationLabel.isHidden = true
    
    //2.
    let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)
    
    //3.
    let subview = NSImageView(frame:NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height))
    subview.image = image
    targetLayer.addSubview(subview)
    
    //4.
    let maxrotation = CGFloat(arc4random_uniform(Appearance.maxRotation)) - Appearance.rotationOffset
    subview.frameCenterRotation = maxrotation
    
  }
  
  func processAction(_ action: String, center: NSPoint) {
    //1.
    if action == SparkleDrag.action  {
      invitationLabel.isHidden = true
      
      //2.
      if let image = NSImage(named:"star") {
        
        //3.
        for _ in 1..<Appearance.numStars {
          
          //A.
          let maxSize:CGFloat = Appearance.maxStarSize
          let sizeChange = CGFloat(arc4random_uniform(Appearance.randonStarSizeChange))
          let finalSize = maxSize - sizeChange
          let newCenter = center.addRandomNoise(Appearance.randomNoiseStar)
          
          //B.
          let imageFrame = NSRect(x: newCenter.x, y: newCenter.y, width: finalSize , height: finalSize)
          let imageView = NSImageView(frame:imageFrame)
          
          //C.
          let newImage = image.tintedImageWithColor(NSColor.randomColor())
          
          //D.
          imageView.image = newImage
          targetLayer.addSubview(imageView)
        }
      }
    }
  }
}

