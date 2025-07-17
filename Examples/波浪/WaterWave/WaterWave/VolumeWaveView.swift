//
//  VolumeWaveView.swift
//  WaterWave
//
//  Created by bula on 2025/7/16.
//  Copyright © 2025 xiAo_Ju. All rights reserved.
//

import UIKit

class VolumeWaveView: UIView {
    
    // MARK: - 属性
    private var phase: CGFloat = 0
    private var amplitude: CGFloat = 0.01
    
    /// 空闲时的最小振幅
    var idleAmplitude: CGFloat = 0.01
    
    /// 波形频率
    var frequency: CGFloat = 1.2
    
    /// 相位偏移速度
    var phaseShift: CGFloat = -0.12
    
    /// 密度 - 控制绘制精度
    var density: CGFloat = 3
    
    /// 主波形颜色
    var primaryWaveColor = UIColor.white.withAlphaComponent(0.8)
    
    /// 次要波形颜色
    var secondaryWaveColor = UIColor.white.withAlphaComponent(0.6)
    
    /// 中心光亮线颜色
    var centerLineColor = UIColor.white
    
    /// 阴影颜色
    var shadowColor = UIColor(white: 0.8, alpha: 0.3)
    
    /// 主波形线宽
    var primaryLineWidth: CGFloat = 2.5
    
    /// 次要波形线宽
    var secondaryLineWidth: CGFloat = 1.5
    
    /// 中心线宽度
    var centerLineWidth: CGFloat = 1.0
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
    }
    
    // MARK: - 公共方法
    /// 更新音量强度
    /// - Parameter level: 音量强度值 (0.0 - 1.0)
    func updateVolume(_ level: CGFloat) {
        phase += phaseShift
        amplitude = max(level, idleAmplitude)
        setNeedsDisplay()
    }
    
    // MARK: - 绘制
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 清除背景
        context.clear(bounds)
        backgroundColor?.set()
        context.fill(bounds)
        
        let halfHeight = bounds.height / 2.0
        let width = bounds.width
        let maxAmplitude = halfHeight * 0.8
        
        // 绘制阴影效果
        drawShadow(context: context, halfHeight: halfHeight, width: width, maxAmplitude: maxAmplitude)
        
        // 绘制两条正弦波
        drawWave(context: context, 
                waveIndex: 0, 
                color: primaryWaveColor,
                lineWidth: primaryLineWidth,
                halfHeight: halfHeight,
                width: width,
                maxAmplitude: maxAmplitude)
        
        drawWave(context: context,
                waveIndex: 1,
                color: secondaryWaveColor,
                lineWidth: secondaryLineWidth,
                halfHeight: halfHeight,
                width: width,
                maxAmplitude: maxAmplitude)
        
        // 绘制中心光亮线
        drawCenterLine(context: context, halfHeight: halfHeight, width: width)
    }
    
    /// 绘制阴影效果
    private func drawShadow(context: CGContext, halfHeight: CGFloat, width: CGFloat, maxAmplitude: CGFloat) {
        context.saveGState()
        
        // 设置阴影
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 6.0, color: shadowColor.cgColor)
        
        // 绘制主波形的阴影轮廓
        context.setLineWidth(primaryLineWidth + 1)
        context.setStrokeColor(UIColor.clear.cgColor)
        
        let shadowPath = createWavePath(waveIndex: 0, halfHeight: halfHeight, width: width, maxAmplitude: maxAmplitude)
        context.addPath(shadowPath)
        context.strokePath()
        
        context.restoreGState()
    }
    
    /// 绘制波形
    private func drawWave(context: CGContext, waveIndex: Int, color: UIColor, lineWidth: CGFloat, halfHeight: CGFloat, width: CGFloat, maxAmplitude: CGFloat) {
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        let path = createWavePath(waveIndex: waveIndex, halfHeight: halfHeight, width: width, maxAmplitude: maxAmplitude)
        context.addPath(path)
        context.strokePath()
    }
    
    /// 创建波形路径
    private func createWavePath(waveIndex: Int, halfHeight: CGFloat, width: CGFloat, maxAmplitude: CGFloat) -> CGPath {
        let path = CGMutablePath()
        var firstPoint = true
        
        // 波形参数调整
        let waveAmplitude = amplitude * (waveIndex == 0 ? 1.0 : 0.7) // 主波形振幅更大
        let phaseOffset = CGFloat(waveIndex) * 0.5 // 相位偏移使两条波形不完全重叠
        let frequencyMultiplier = 1.0 + CGFloat(waveIndex) * 0.3 // 频率略有不同
        
        for x in stride(from: 0.0, to: width + density, by: density) {
            // 使用抛物线函数调制振幅，使中间部分振幅最大
            let mid = width / 2.0
            let scaling = -pow((x - mid) / mid, 2) + 1
            
            // 计算 Y 坐标
            let y = scaling * maxAmplitude * waveAmplitude * sin(2 * .pi * (x / width) * frequency * frequencyMultiplier + phase + phaseOffset) + halfHeight
            
            if firstPoint {
                path.move(to: CGPoint(x: x, y: y))
                firstPoint = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    /// 绘制中心光亮线
    private func drawCenterLine(context: CGContext, halfHeight: CGFloat, width: CGFloat) {
        context.saveGState()
        
        let glowIntensity = amplitude * 0.8 + 0.2
        
        // 先绘制阴影效果
        drawCenterLineShadow(context: context, halfHeight: halfHeight, width: width, glowIntensity: glowIntensity)
        
        // 再绘制纺锤型高度的水平光亮线
        drawSpindleHeightLine(context: context, halfHeight: halfHeight, width: width, glowIntensity: glowIntensity)
        
        context.restoreGState()
    }
    
    /// 绘制中心线阴影效果
    private func drawCenterLineShadow(context: CGContext, halfHeight: CGFloat, width: CGFloat, glowIntensity: CGFloat) {
        context.saveGState()
        
        // 计算基础线宽
        let shadowBaseLineWidth = centerLineWidth * (amplitude * 4 + 1.0)
        
        // 绘制深层阴影（最远的阴影）
        context.setShadow(offset: CGSize(width: 0, height: 8 + amplitude * 6), 
                         blur: 20 + amplitude * 12, 
                         color: UIColor.black.withAlphaComponent(0.6 + amplitude * 0.2).cgColor)
        
        drawSpindleLayer(context: context, 
                       halfHeight: halfHeight, 
                       width: width, 
                       baseLineWidth: shadowBaseLineWidth, 
                       widthMultiplier: 10.0, 
                       alpha: 0.3 * glowIntensity)
        
        // 绘制中层阴影
        context.setShadow(offset: CGSize(width: 0, height: 5 + amplitude * 4), 
                         blur: 15 + amplitude * 8, 
                         color: shadowColor.withAlphaComponent(0.5 + amplitude * 0.3).cgColor)
        
        drawSpindleLayer(context: context, 
                       halfHeight: halfHeight, 
                       width: width, 
                       baseLineWidth: shadowBaseLineWidth, 
                       widthMultiplier: 8.0, 
                       alpha: 0.4 * glowIntensity)
        
        // 绘制近层阴影
        context.setShadow(offset: CGSize(width: 0, height: 3 + amplitude * 2), 
                         blur: 10 + amplitude * 6, 
                         color: shadowColor.withAlphaComponent(0.4 + amplitude * 0.3).cgColor)
        
        let shadowLayers: [(widthMultiplier: CGFloat, alpha: CGFloat)] = [
            (7.0, 0.3 * glowIntensity),  // 最外层阴影 - 更淡
            (5.5, 0.4 * glowIntensity),  // 外层阴影 - 更淡
            (4.0, 0.5 * glowIntensity),  // 中层阴影 - 调淡
            (3.0, 0.6 * glowIntensity),  // 内层阴影 - 略微调淡
        ]
        
        // 为阴影绘制纺锤型形状
        for layer in shadowLayers {
            drawSpindleLayer(context: context, 
                           halfHeight: halfHeight, 
                           width: width, 
                           baseLineWidth: shadowBaseLineWidth, 
                           widthMultiplier: layer.widthMultiplier, 
                           alpha: layer.alpha)
        }
        
        context.restoreGState()
    }
    
    /// 绘制纺锤型高度的水平线
    private func drawSpindleHeightLine(context: CGContext, halfHeight: CGFloat, width: CGFloat, glowIntensity: CGFloat) {
        // 计算基础线宽
        let baseLineWidth = centerLineWidth * (amplitude * 4 + 1.0)
        
        // 绘制平滑的纺锤型渐变效果
        drawSmoothSpindleGradient(context: context, 
                                halfHeight: halfHeight, 
                                width: width, 
                                baseLineWidth: baseLineWidth, 
                                glowIntensity: glowIntensity)
    }
    
    /// 绘制平滑的纺锤型渐变
    private func drawSmoothSpindleGradient(context: CGContext, halfHeight: CGFloat, width: CGFloat, baseLineWidth: CGFloat, glowIntensity: CGFloat) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let mid = width / 2.0
        
        // 创建垂直方向的渐变色 - 从透明到实体再到透明
        let gradientColors = [
            UIColor.clear.cgColor,
            centerLineColor.withAlphaComponent(0.1 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.3 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.6 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.9 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.6 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.3 * glowIntensity).cgColor,
            centerLineColor.withAlphaComponent(0.1 * glowIntensity).cgColor,
            UIColor.clear.cgColor
        ]
        
        let gradientLocations: [CGFloat] = [0.0, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                      colors: gradientColors as CFArray,
                                      locations: gradientLocations) else { return }
        
        // 绘制纺锤形状的遮罩路径
        let maskPath = CGMutablePath()
        
        // 上边界
        maskPath.move(to: CGPoint(x: 0, y: halfHeight))
        for x in stride(from: 0.0, to: width + 1, by: 2.0) {
            let spindleScaling = -pow((x - mid) / mid, 2) + 1
            let currentHalfHeight = (baseLineWidth * 3.0 * spindleScaling) / 2.0
            let y = halfHeight - currentHalfHeight
            maskPath.addLine(to: CGPoint(x: min(x, width), y: y))
        }
        
        // 下边界
        for x in stride(from: width, to: -1, by: -2.0) {
            let spindleScaling = -pow((x - mid) / mid, 2) + 1
            let currentHalfHeight = (baseLineWidth * 3.0 * spindleScaling) / 2.0
            let y = halfHeight + currentHalfHeight
            maskPath.addLine(to: CGPoint(x: max(x, 0), y: y))
        }
        
        maskPath.closeSubpath()
        
        // 使用裁剪路径
        context.saveGState()
        context.addPath(maskPath)
        context.clip()
        
        // 计算纺锤的最大高度来定义渐变范围
        let maxSpindleHeight = baseLineWidth * 3.0
        let gradientStartY = halfHeight - maxSpindleHeight / 2.0
        let gradientEndY = halfHeight + maxSpindleHeight / 2.0
        
        // 绘制垂直渐变
        context.drawLinearGradient(gradient,
                                 start: CGPoint(x: 0, y: gradientStartY),
                                 end: CGPoint(x: 0, y: gradientEndY),
                                 options: [])
        
        context.restoreGState()
    }
    
    /// 绘制单层纺锤型直线
    private func drawSpindleLayer(context: CGContext, halfHeight: CGFloat, width: CGFloat, baseLineWidth: CGFloat, widthMultiplier: CGFloat, alpha: CGFloat) {
        // 创建纺锤型路径
        let path = CGMutablePath()
        let mid = width / 2.0
        
        // 上边界路径
        path.move(to: CGPoint(x: 0, y: halfHeight))
        for x in stride(from: 0.0, to: width + 1, by: 1.0) {
            let spindleScaling = -pow((x - mid) / mid, 2) + 1
            let currentHalfHeight = (baseLineWidth * widthMultiplier * spindleScaling) / 2.0
            let y = halfHeight - currentHalfHeight
            path.addLine(to: CGPoint(x: min(x, width), y: y))
        }
        
        // 下边界路径（反向）
        for x in stride(from: width, to: -1, by: -1.0) {
            let spindleScaling = -pow((x - mid) / mid, 2) + 1
            let currentHalfHeight = (baseLineWidth * widthMultiplier * spindleScaling) / 2.0
            let y = halfHeight + currentHalfHeight
            path.addLine(to: CGPoint(x: max(x, 0), y: y))
        }
        
        path.closeSubpath()
        
        // 填充纺锤形状
        context.setFillColor(centerLineColor.withAlphaComponent(alpha).cgColor)
        context.addPath(path)
        context.fillPath()
    }

} 