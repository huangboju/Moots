//
//  DecorationView.swift
//  DynamicsCatalog
//
//  Created by 黄伯驹 on 2019/2/16.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class DecorationView: UIView {
    
    private var attachmentDecorationLayers: [CALayer]?
    
    private var attachmentPointView: UIView?
    private var attachedView: UIView?
    private var attachmentOffset: CGPoint?
    
    private weak var arrowView: UIImageView?
    
    private weak var centerPointView: UIImageView?
    
    deinit {
        attachmentPointView?.removeObserver(self, forKeyPath: "center")
        attachedView?.removeObserver(self, forKeyPath: "center")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundTile")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //| ----------------------------------------------------------------------------
    //! Draws a dashed line between @a attachmentPointView and @a attachedView
    //! that is updated as either view moves.
    //
    func trackAndDrawAttachmentFromView(_ attachmentPointView: UIView,
                                        toView attachedView: UIView,
                                        withAttachmentOffset attachmentOffset: CGPoint) {
        if attachmentDecorationLayers == nil {
            attachmentDecorationLayers = []
            for i in 0 ..< 4 {

                let dashImage = UIImage(named: "DashStyle\((i % 3) + 1)")
                
                let dashLayer = CALayer()
                dashLayer.contents = dashImage?.cgImage
                dashLayer.bounds = CGRect(origin: .zero, size: dashImage!.size)
                dashLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
                layer.insertSublayer(dashLayer, at: 0)
                attachmentDecorationLayers?.append(dashLayer)
            }
        }
        
        // A word about performance.
        // Tracking changes to the properties of any id<UIDynamicItem> involved in
        // a simulation incurs a performance cost.  You will receive a callback
        // during each step in the simulation in which the tracked item is not at
        // rest.  You should therefore strive to make your callback code as
        // efficient as possible.
        self.attachmentPointView?.removeObserver(self, forKeyPath: "center")
        self.attachedView?.removeObserver(self, forKeyPath: "center")
        
        self.attachmentPointView = attachmentPointView
        self.attachedView = attachedView
        self.attachmentOffset = attachmentOffset
        
        // Observe the 'center' property of both views to know when they move.
        attachmentPointView.addObserver(self, forKeyPath: "center", options: .new, context: nil)
        attachedView.addObserver(self, forKeyPath: "center", options: .new, context: nil)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arrowView?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        centerPointView?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        guard let attachmentDecorationLayers = attachmentDecorationLayers else {
            return
        }
        
        // Here we adjust the line dash pattern visualizing the attachement
        // between attachmentPointView and attachedView to account for a change
        // in the position of either.
        
        let MaxDashes = attachmentDecorationLayers.count
        
        var attachmentPointViewCenter = CGPoint(x: attachmentPointView!.bounds.width/2, y: attachmentPointView!.bounds.height/2)
        
        attachmentPointViewCenter = attachmentPointView?.convert(attachmentPointViewCenter, to: self) ?? .zero
        var attachedViewAttachmentPoint = CGPoint(x: attachedView!.bounds.width/2 + attachmentOffset!.x, y: attachedView!.bounds.height/2 + attachmentOffset!.y)

        attachedViewAttachmentPoint = attachedView?.convert(attachedViewAttachmentPoint, to: self) ?? .zero
        
        let distance = sqrt(pow(attachedViewAttachmentPoint.x-attachmentPointViewCenter.x, 2.0) +
            pow(attachedViewAttachmentPoint.y-attachmentPointViewCenter.y, 2.0) )
        let angle = atan2(attachedViewAttachmentPoint.y-attachmentPointViewCenter.y,
                               attachedViewAttachmentPoint.x-attachmentPointViewCenter.x )
        
        var requiredDashes = 0
        var d: CGFloat = 0.0
        
        // Depending on the distance between the two views, a smaller number of
        // dashes may be needed to adequately visualize the attachment.  Starting
        // with a distance of 0, we add the length of each dash until we exceed
        // 'distance' computed previously or we use the maximum number of allowed
        // dashes, 'MaxDashes'.
        while (requiredDashes < MaxDashes)
        {
            let dashLayer = attachmentDecorationLayers[requiredDashes];
            
            if (d + dashLayer.bounds.height < distance) {
                d += dashLayer.bounds.height
                dashLayer.isHidden = false
                requiredDashes += 1
            } else {
                break
            }
        }
        
        // Based on the total length of the dashes we previously determined were
        // necessary to visualize the attachment, determine the spacing between
        // each dash.
        let dashSpacing = (distance - d) / CGFloat(requiredDashes + 1)
        
        // Hide the excess dashes.
        for i in requiredDashes ..< MaxDashes {
            attachmentDecorationLayers[i].isHidden = true
        }
        
        // Disable any animations.  The changes must take full effect immediately.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        
        // Each dash layer is positioned by altering its affineTransform.  We
        // combine the position of rotation into an affine transformation matrix
        // that is assigned to each dash.
        var transform = CGAffineTransform(translationX: attachmentPointViewCenter.x, y: attachmentPointViewCenter.y)
        transform = transform.rotated(by: angle - .pi/2)
        
        for drawnDashes in 0 ..< requiredDashes {
            let dashLayer = attachmentDecorationLayers[drawnDashes]

            transform = transform.translatedBy(x: 0, y: dashSpacing)
            
            dashLayer.setAffineTransform(transform)

            transform = transform.translatedBy(x: 0, y: dashLayer.bounds.height)
        }
        
        CATransaction.commit()
    }
    
    //| ----------------------------------------------------------------------------
    //! Draws an arrow with a given @a length anchored at the center of the receiver,
    //! that points in the direction given by @a angle.
    //
    func drawMagnitudeVector(with length: CGFloat, angle: CGFloat, color: UIColor, forLimitedTime: Bool) {
        if (arrowView == nil) {
            let arrowImage = UIImage(named: "Arrow")?.withRenderingMode(.alwaysTemplate)
            
            let arrowImageView = UIImageView(image: arrowImage)
            arrowImageView.bounds = CGRect(origin: .zero, size: arrowImage?.size ?? .zero)
            arrowImageView.contentMode = .right
            arrowImageView.clipsToBounds = true
            arrowImageView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            
            addSubview(arrowImageView)
            sendSubviewToBack(arrowImageView)
            self.arrowView = arrowImageView
        }

        self.arrowView?.bounds = CGRect(x: 0, y: 0, width:  length, height:  arrowView?.bounds.height ?? 0)
        self.arrowView?.transform = CGAffineTransform(rotationAngle: angle)
        self.arrowView?.tintColor = color
        self.arrowView?.alpha = 1
        
        if (forLimitedTime) {
            UIView.animate(withDuration: 1) {
                self.arrowView?.alpha = 0
            }
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? UIView) == attachmentPointView || (object as? UIView) == attachedView {
            setNeedsLayout()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
