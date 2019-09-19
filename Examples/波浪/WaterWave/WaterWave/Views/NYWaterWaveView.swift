//
//  NYWaterWaveView.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2017/2/13.
//  Copyright © 2017年 xiAo_Ju. All rights reserved.
//

import UIKit

class NYWaterWaveView: UIView {
    
    lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(getCurrentWave))
        return displayLink
    }()
    
    lazy var firstWaveLayer: CAShapeLayer = {
        let firstWaveLayer = CAShapeLayer()
        firstWaveLayer.fillColor = self.waveColor.cgColor
        return firstWaveLayer
    }()
    lazy var secondeWaveLayer: CAShapeLayer = {
        let secondeWaveLayer = CAShapeLayer()
        secondeWaveLayer.fillColor = self.waveColor.cgColor
        return secondeWaveLayer
    }()
    lazy var thirdWaveLayer: CAShapeLayer = {
        let thirdWaveLayer = CAShapeLayer()
        thirdWaveLayer.fillColor = self.waveColor.cgColor
        return thirdWaveLayer
    }()
    
    var waveAmplitude: CGFloat = 13  //!< 振幅
    var waveCycle: CGFloat = 0  //!< 周期
    var waveSpeed: CGFloat = 0.25 / .pi  //!< 速度
    var waveSpeed2: CGFloat = 0.3 / .pi
    var waterWaveHeight: CGFloat = 200
    var waterWaveWidth: CGFloat = 0
    var wavePointY: CGFloat = 0
    var waveOffsetX: CGFloat  = 0  //!< 波浪x位移
    var waveColor = UIColor(r: 255, g: 255, b: 255, a: 0.1)  //!< 波浪颜色
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 251, g: 91, b: 91)
        layer.masksToBounds = true
        
        waterWaveWidth = frame.width
        wavePointY = waterWaveHeight - 50
        waveCycle =  1.29 * .pi / waterWaveWidth
        
        layer.addSublayer(firstWaveLayer)
        layer.addSublayer(secondeWaveLayer)
        layer.addSublayer(thirdWaveLayer)

        displayLink.add(to: RunLoop.main, forMode: .common)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func getCurrentWave() {
        waveOffsetX += waveSpeed
        
        setFirstWaveLayerPath()
        setSecondWaveLayerPath()
        setThirdWaveLayerPath()
    }

    func setFirstWaveLayerPath() {
        let path = CGMutablePath()
        var y = wavePointY
        path.move(to: CGPoint(x: 0, y: y))
        for x in  0 ... Int(waterWaveWidth) {
            y = waveAmplitude * sin(waveCycle * CGFloat(x) + waveOffsetX - 10) + wavePointY + 10;
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }

        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.closeSubpath()
        
        firstWaveLayer.path = path
    }
    
    func setSecondWaveLayerPath() {
        let path = CGMutablePath()
        var y = wavePointY
        path.move(to: CGPoint(x: 0, y: y))
        for x in  0 ... Int(waterWaveWidth) {
            y = (waveAmplitude - 2) * sin(waveCycle * CGFloat(x) + waveOffsetX) + wavePointY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.closeSubpath()
        
        secondeWaveLayer.path = path
    }
    
    func setThirdWaveLayerPath() {
        let path = CGMutablePath()
        var y = wavePointY
        path.move(to: CGPoint(x: 0, y: y))
        for x in  0 ... Int(waterWaveWidth) {
            y = (waveAmplitude + 2) * sin(waveCycle * CGFloat(x) + waveOffsetX + 20) + wavePointY - 10
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        
        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.closeSubpath()
        
        thirdWaveLayer.path = path
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
