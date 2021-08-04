//
//  MaskShapeLayerVC.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/10/27.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class MaskShapeLayerVC: UIViewController {

    var draftShapeLayer : CAShapeLayer?
    var squareShapeLayer : CAShapeLayer?
    var lineShapeLayer : CAShapeLayer?
    var shapeLayer : CAShapeLayer?
    
    let width : CGFloat = 240
    let height : CGFloat = 240
    
    lazy var containerLayer : CALayer = { () -> CALayer in
        let containerLayer = CALayer()
        containerLayer.frame =  CGRect(x: self.view.center.x - self.width / 2, y: self.view.center.y - self.height / 2, width: self.width, height: self.height)
        self.view.layer.addSublayer(containerLayer)
        return containerLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //        drawHeader()
        drawMask()
    }
    
    // MARK: - 绘制蒙版
    
    private func drawMask() {
        
        let bgView = UIImageView(image: UIImage(named: "007.jpg"))
        bgView.frame = view.bounds
        view.addSubview(bgView)
        
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        maskView.alpha = 0.8
        //        view.addSubview(maskView)
        
        let bpath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: view.bounds.width - 20, height: view.bounds.height - 20), cornerRadius: 15)
        
//        let circlePath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: .pi * 2, clockwise: false)
//        bpath.append(circlePath)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 100, y: 100))
        linePath.addLine(to: CGPoint(x: 100, y: 200))
        linePath.addLine(to: CGPoint(x: 200, y: 200))
        bpath.append(linePath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.isOpaque = false
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.path = bpath.cgPath
        
        //        view.layer.addSublayer(shapeLayer)
        bgView.layer.mask = shapeLayer
    }
    
    // MARK: - 图形动画
    
    private func drawHeader() {
        
        //        let draftPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 5)
        
        let cornerRadius : CGFloat = 20
        
        let draftPath = UIBezierPath()
        draftPath.move(to: CGPoint(x: width - cornerRadius, y: 0))
        draftPath.addLine(to: CGPoint(x: cornerRadius, y: 0))
        draftPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -.pi/2, endAngle: .pi, clockwise: false)
        draftPath.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
        draftPath.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: .pi/2, clockwise: false)
        draftPath.addLine(to: CGPoint(x: width - cornerRadius, y: height))
        draftPath.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: .pi/2, endAngle: 0, clockwise: false)
        draftPath.addLine(to: CGPoint(x: width, y: cornerRadius))
        draftPath.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: -.pi/2, clockwise: false)
        
        let margin : CGFloat = 24
        let smallSquareWH : CGFloat = 84
        
        let squarePath = UIBezierPath(roundedRect: CGRect(x: margin, y: margin, width: smallSquareWH, height: smallSquareWH), cornerRadius: 2)
        
        let shortLineLeft : CGFloat = margin * 2 + smallSquareWH
        let shortLineRight : CGFloat = width - margin
        let space : CGFloat = smallSquareWH / 2 - 3
        
        let linePath = UIBezierPath()
        
        for i in 0 ..< 3 {
            linePath.move(to: CGPoint(x: shortLineLeft, y: margin + 2 + space * CGFloat(i)))
            linePath.addLine(to: CGPoint(x: shortLineRight, y: margin + 2 + space * CGFloat(i)))
        }
        
        let longLineRight = width - margin
        
        for i in 0 ..< 3 {
            linePath.move(to: CGPoint(x: margin, y: margin * 2 + 2 + smallSquareWH + space * CGFloat(i)))
            linePath.addLine(to: CGPoint(x: longLineRight, y: margin * 2 + 2 + smallSquareWH + space * CGFloat(i)))
        }
        
        self.draftShapeLayer = CAShapeLayer()
        self.draftShapeLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        setupShapeLayer(shapeLayer: self.draftShapeLayer!, path: draftPath.cgPath)
        
        self.squareShapeLayer = CAShapeLayer()
        self.squareShapeLayer!.frame = CGRect(x: 0, y: 0, width: smallSquareWH, height: smallSquareWH)
        setupShapeLayer(shapeLayer: self.squareShapeLayer!, path: squarePath.cgPath)
        
        self.lineShapeLayer = CAShapeLayer()
        self.lineShapeLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        setupShapeLayer(shapeLayer: self.lineShapeLayer!, path: linePath.cgPath)
        
        addSlider()
    }
    
    private func addSlider() {
        let slider = UISlider(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width - 40, height: 10))
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: UIControl.Event.valueChanged)
        view.addSubview(slider)
    }
    
    @objc private func sliderValueChanged(sender: UISlider) {
        guard let draftShapeLayer = self.draftShapeLayer else {
            return
        }
        guard let squareShapeLayer = self.squareShapeLayer else {
            return
        }
        guard let lineShapeLayer = self.lineShapeLayer else {
            return
        }
        draftShapeLayer.strokeEnd = CGFloat(sender.value)
        squareShapeLayer.strokeEnd = CGFloat(sender.value)
        lineShapeLayer.strokeEnd = CGFloat(sender.value)
    }
    
    // MARK: - 辅助方法
    private func setupShapeLayer(shapeLayer : CAShapeLayer, path : CGPath) {
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        containerLayer.addSublayer(shapeLayer)
    }

}
