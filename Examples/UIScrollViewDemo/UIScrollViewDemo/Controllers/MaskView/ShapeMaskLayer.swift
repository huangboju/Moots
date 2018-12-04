//
//  ShapeMaskLayer.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2018/12/4.
//  Copyright © 2018 伯驹 黄. All rights reserved.
//

import UIKit

class ShapeMaskLayer: CAShapeLayer {
    private lazy var overlayPath: UIBezierPath = {
        let overlayPath = generateOverlayPath()
        return overlayPath
    }()
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
    }

    convenience init(rect: CGRect) {
        self.init()
        self.frame = rect
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        refreshMask()
    }
    
    private lazy var transparentPaths: [UIBezierPath] = []
    
    public var maskColor: UIColor = UIColor(white: 0, alpha: 0.5) {
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
    
    private func addTransparentPath(_ transparentPath: UIBezierPath) {
        overlayPath.append(transparentPath)
        transparentPaths.append(transparentPath)
        
        path = overlayPath.cgPath
    }
    
    private func setUp() {
        contentsScale = UIScreen.main.scale
        backgroundColor = UIColor.clear.cgColor
        
        path = overlayPath.cgPath
        fillRule = .evenOdd
        fillColor = maskColor.cgColor
        
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
        
        path = overlayPath.cgPath
        fillColor = maskColor.cgColor
    }
}
