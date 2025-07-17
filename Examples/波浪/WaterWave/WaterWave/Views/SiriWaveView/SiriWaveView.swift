//
//  SiriWaveView.swift
//  SiriWave
//
//  Created by politom on 08/03/2019.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

public class SiriWaveView: UIView {

    public private(set) var pixelDepth: CGFloat = 0.4
    public private(set) var amplitude: CGFloat = 1
    
    @IBInspectable
    public var idleAmplitude: CGFloat = 0.01
    @IBInspectable
    public var speed: CGFloat = 0.4

    public var colors: [UIColor] = [UIColor(rgb: 0xF66767),
                                    UIColor(rgb: 0xF9D5BB),
                                    UIColor(rgb: 0xD35656)]
    
    private var lines: [SiriWaveLine] = []
    
    private var heightMax: CGFloat {
        return self.frame.height
    }
    private var width: CGFloat {
        return self.frame.width
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func update(_ level: CGFloat) {
        
        self.amplitude = fmax(level,
                              idleAmplitude)
        
        self.setNeedsDisplay()
        
    }
    
    override public func draw(_ rect: CGRect) {
        
        if let ctx: CGContext = UIGraphicsGetCurrentContext() {
            ctx.setAlpha(0.7)
            ctx.setBlendMode(.lighten)

            drawSupportLine(ctx)
            
            for line in lines {
                line.drawLine(ctx,
                              amplitude,
                              speed)
            }
        }
    }
    
    private func commonInit() {
        
        for color in colors {
            
            lines.append(SiriWaveLine(amplitude: amplitude,
                                      speed: speed,
                                      pixelDepth: pixelDepth,
                                      width: width,
                                      heightMax: heightMax,
                                      color: color))
        }
        
    }
    
    private func drawSupportLine(_ ctx: CGContext) {
        
        let colors = [UIColor.clear.cgColor,
                      UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
                      UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
                      UIColor.clear.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 0.1, 1.0, 0.8, 1]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint(x: 0, y: (heightMax/2)-0.5)
        let endPoint = CGPoint(x: 0, y: (heightMax/2)+0.5)
        
        ctx.drawLinearGradient(gradient,
                               start: startPoint,
                               end: endPoint,
                               options: [])
    }
}


