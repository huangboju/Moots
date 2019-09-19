//
//  Created by 伯驹 黄 on 16/9/29.
//

import UIKit

class WaterWaveView: UIView {
    var frontWaveColor = UIColor(red: 88 / 255, green: 202 / 255, blue: 139 / 255, alpha: 1)
    var backWaveColor = UIColor.orange
    var waterLineY: CGFloat = 120
    var waveAmplitude: CGFloat = 3
    var waveCycle: CGFloat = 1
    var increase = false
    var waveDisplayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(runWave))
        waveDisplayLink?.add(to: .main, forMode: .common)
    }
    
    @objc func runWave() {
        increase ? (waveAmplitude += 0.02) : (waveAmplitude -= 0.02)
        increase = waveAmplitude <= 1
        increase = waveAmplitude < 1.5
        waveCycle += 0.1
        setNeedsDisplay()
    }
    
    func formatBatteryLevel(percent: Int) -> NSMutableAttributedString {
        let textColor = UIColor.red
        let percentText = "\(percent)%"
        let paragrahStyle = NSMutableParagraphStyle()
        paragrahStyle.alignment = .center
        let attrText = NSMutableAttributedString(string: percentText)
        let capacityNumberFont = UIFont(name: "HelveticaNeue-Thin", size: 80)!
        let capacityPercentFont = UIFont(name: "HelveticaNeue-Thin", size: 40)!
        if percent < 10 {
            attrText.addAttribute(.font, value: capacityNumberFont, range: NSRange(location: 0, length: 1))
            attrText.addAttribute(.font, value: capacityPercentFont, range: NSRange(location: 1, length: 1))
            attrText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: 2))
            attrText.addAttribute(.paragraphStyle, value: paragrahStyle, range: NSRange(location: 0, length: 2))
        } else {
            if percent >= 100 {
                attrText.addAttribute(.font, value: capacityNumberFont, range: NSRange(location: 0, length: 3))
                attrText.addAttribute(.font, value: capacityPercentFont, range: NSRange(location: 3, length: 1))
                attrText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: 4))
                attrText.addAttribute(.paragraphStyle, value: paragrahStyle, range: NSRange(location: 0, length: 4))
            } else {
                attrText.addAttribute(.font, value: capacityNumberFont, range: NSRange(location: 0, length: 2))
                attrText.addAttribute(.font, value: capacityPercentFont, range: NSRange(location: 2, length: 1))
                attrText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: 3))
                attrText.addAttribute(.paragraphStyle, value: paragrahStyle, range: NSRange(location: 0, length: 3))
            }
        }
        return attrText
        
    }
    
    override func draw(_ rect: CGRect) {
        //初始化画布
        if let context = UIGraphicsGetCurrentContext() {
            let attriButedText = formatBatteryLevel(percent: 50)
            let textSize = attriButedText.boundingRect(with: CGSize(width: 400, height: CGFloat.infinity), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            let textPoint = CGPoint(x: 160 - textSize.width / 2, y: 70)
            attriButedText.draw(at: textPoint)
            context.saveGState()
            
            //定义前波浪path
            let frontPath = CGMutablePath()
            
            //定义后波浪path
            let backPath = CGMutablePath()
            
            //定义前波浪反色path
            let frontReversePath = CGMutablePath()
            
            //定义后波浪反色path
            let  backReversePath = CGMutablePath()
            
            //画水
            context.setLineWidth(1)
            
            //前波浪位置初始化
            var frontY = waterLineY
            frontPath.move(to: CGPoint(x: 0, y: frontY))
            
            //前波浪反色位置初始化
            var frontReverseY = waterLineY
            frontReversePath.move(to: CGPoint(x: 0, y: frontReverseY))
            
            //后波浪位置初始化
            var backY = waterLineY
            backPath.move(to: CGPoint(x: 0, y: backY))
            
            //后波浪反色位置初始化
            var backReverseY = waterLineY
            backReversePath.move(to: CGPoint(x: 0, y: backReverseY))
            
            for x in 0...320 {
                //前波浪绘制
                let cgX = CGFloat(x)
                frontY = waveAmplitude * sin(cgX / 180 * .pi + 4 * waveCycle / .pi ) * 5 + waterLineY
                
                frontPath.addLine(to: CGPoint(x: cgX, y: frontY))
                
                //后波浪绘制
                backY = waveAmplitude * cos(cgX / 180 * .pi + 3 * waveCycle / .pi) * 5 + waterLineY
                backPath.addLine(to: CGPoint(x: cgX, y: backY))
                if  x >= 100 {
                    //后波浪反色绘制
                    backReverseY = waveAmplitude * cos( cgX / 180 * .pi + 3 * waveCycle / .pi) * 5 + waterLineY
                    backReversePath.addLine(to: CGPoint(x: cgX, y: backReverseY))
                    
                    //前波浪反色绘制
                    frontReverseY = waveAmplitude * sin( cgX / 180 * .pi + 4 * waveCycle / .pi) * 5 + waterLineY
                    frontReversePath.addLine(to: CGPoint(x: cgX, y: frontReverseY))
                    context.setFillColor(backWaveColor.cgColor)
                }
            }
            
            //后波浪绘制
            backPath.addLine(to: CGPoint(x: 320, y: rect.height))
            backPath.addLine(to: CGPoint(x: 0, y: rect.height))
            backPath.addLine(to: CGPoint(x: 0, y: waterLineY))
            backPath.closeSubpath()
            context.addPath(backPath)
            context.fillPath()

            //推入
            context.saveGState()
            //后波浪反色绘制
            backReversePath.addLine(to: CGPoint(x: 320, y: rect.height))
            backReversePath.addLine(to: CGPoint(x: 320, y: rect.height))
            backReversePath.addLine(to: CGPoint(x: 100, y: rect.height))
            backReversePath.addLine(to: CGPoint(x: 100, y: waterLineY))
            context.addPath(backReversePath)
            context.clip()
            attriButedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attriButedText.length))
            attriButedText.draw(at: textPoint)
            //弹出
            context.restoreGState()
            
            //前波浪绘制
            context.setFillColor(frontWaveColor.cgColor)
            frontPath.addLine(to: CGPoint(x: 320, y: rect.height))
            frontPath.addLine(to: CGPoint(x: 0, y: rect.height))
            frontPath.addLine(to: CGPoint(x: 0, y: waterLineY))
            frontPath.closeSubpath()
            context.addPath(frontPath)
            context.fillPath()
            
            context.saveGState()
            
            //前波浪反色绘制
            frontReversePath.addLine(to: CGPoint(x: 320, y: rect.height))
            frontReversePath.addLine(to: CGPoint(x: 100, y: rect.height))
            frontReversePath.addLine(to: CGPoint(x: 100, y: waterLineY))
            
            context.addPath(frontReversePath)
            context.clip()
            
            attriButedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attriButedText.length))
            
            attriButedText.draw(at: textPoint)
            
            context.saveGState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
