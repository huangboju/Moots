//
//  WaveView.swift
//  波浪效果
//
//  Created by 徐攀 on 16/8/30.
//  Copyright © 2016年 iDustpan. All rights reserved.
//

import UIKit
import QuartzCore

class WaveView: UIView {
    
    // 波浪曲线：y = h * sin(a * x + b); h: 波浪高度， a: 波浪宽度系数， b： 波的移动
    
    // 波浪高度h
    var waveHeight: CGFloat = 15
    // 波浪宽度系数a
    var waveRate: CGFloat = 0.01
    // 波浪移动速度
    var waveSpeed: CGFloat = 0.05
    // 真实波浪颜色
    var realWaveColor: UIColor = UIColor.white
    // 阴影波浪颜色
    var maskWaveColor: UIColor = UIColor(white: 0.8, alpha: 0.3)
    
    var closure: ((_ centerY: CGFloat)->())?
    
    fileprivate var displayLink: CADisplayLink?

    fileprivate var realWaveLayer: CAShapeLayer?
    fileprivate var maskWaveLayer: CAShapeLayer?
    
    fileprivate var offset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWaveParame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWaveParame()
    }
    
    fileprivate func initWaveParame() {
        // 真实波浪配置
        realWaveLayer = CAShapeLayer()
        var frame = bounds
        realWaveLayer?.frame.origin.y = frame.height - waveHeight
        frame.size.height = waveHeight
        realWaveLayer?.frame = frame

        // 阴影波浪配置
        maskWaveLayer = CAShapeLayer()
        maskWaveLayer?.frame.origin.y = frame.height - waveHeight
        frame.size.height = waveHeight
        maskWaveLayer?.frame = frame
        
        layer.addSublayer(maskWaveLayer!)
        layer.addSublayer(realWaveLayer!)
    }
    
    func startWave() {
        displayLink = CADisplayLink(target: self, selector: #selector(wave))
        displayLink!.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func endWave() {
        displayLink!.invalidate()
        displayLink = nil
    }
    
    func wave() {
        // 波浪移动的关键：按照指定的速度偏移
        offset += waveSpeed
        
        // 从左下角开始
        let realPath = UIBezierPath()
        realPath.move(to: CGPoint(x: 0, y: frame.height))
        
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: frame.height))
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        while x <= bounds.width {
            // 波浪曲线
            y = waveHeight * sin(x * waveRate + offset)
            
            realPath.addLine(to: CGPoint(x: x, y: y))
            maskPath.addLine(to: CGPoint(x: x, y: -y))
            
            // 增量越小，曲线越平滑
            x += 0.1
        }
        
        let midX = bounds.width * 0.5
        let midY = waveHeight * sin(midX * waveRate + offset)
        
        if let closureBack = closure {
            closureBack(midY)
        }
        // 回到右下角
        realPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        maskPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        
        // 闭合曲线
        maskPath.close()
        
        // 把封闭图形的路径赋值给CAShapeLayer
        maskWaveLayer?.path = maskPath.cgPath
        maskWaveLayer?.fillColor = maskWaveColor.cgColor
        
        realPath.close()
        realWaveLayer?.path = realPath.cgPath
        realWaveLayer?.fillColor = realWaveColor.cgColor
    }
}
