//
//  MaskView.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/10/27.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class MaskView: UIView {
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private var fillLayer: CAShapeLayer! {
        return layer as? CAShapeLayer
    }
    
    private lazy var overlayPath: UIBezierPath = {
        let overlayPath = generateOverlayPath()
        return overlayPath
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshMask()
    }
    
    private lazy var transparentPaths: [UIBezierPath] = []

    public var maskColor: UIColor? {
        didSet {
            refreshMask()
        }
    }
    
    public func addTransparentRect(_ rect: CGRect) {
        let transparentPath = UIBezierPath(rect: rect)
        
        addTransparentPath(transparentPath)
    }
    
    public func addTransparentRoundedRect(_ rect: CGRect, cornerRadius: CGFloat) {

        let transparentPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        addTransparentPath(transparentPath)
    }
    
    public func addTransparentRoundedRect(_ rect: CGRect, byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize) {
        
        let transparentPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii)
        
        addTransparentPath(transparentPath)
    }
    
    public func addTransparentOvalRect(_ rect: CGRect) {
        let transparentPath = UIBezierPath(ovalIn: rect)
        
        addTransparentPath(transparentPath)
    }
    
    public func reset() {
        transparentPaths.removeAll()
        refreshMask()
    }
    
    public func addTransparentPath(_ transparentPath: UIBezierPath) {
        overlayPath.append(transparentPath)
        transparentPaths.append(transparentPath)

        fillLayer.path = overlayPath.cgPath
    }

    private func setUp() {
        backgroundColor = UIColor.clear
        maskColor = UIColor(white: 0, alpha: 0.5) // 50% transparent black
        
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = maskColor?.cgColor

    }

    private func generateOverlayPath() -> UIBezierPath {
        let overlayPath = UIBezierPath(rect: bounds)
        overlayPath.usesEvenOddFillRule = true
        return overlayPath
    }
    
    private func currentOverlayPath() -> UIBezierPath {
        let overlayPath = generateOverlayPath()
        
        for transparentPath in transparentPaths {
            overlayPath.append(transparentPath)
        }
        
        return overlayPath
    }
    
    private func refreshMask() {
        overlayPath = currentOverlayPath()

        fillLayer.path = overlayPath.cgPath
        fillLayer.fillColor = maskColor?.cgColor
    }
    
}
