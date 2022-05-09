//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

private let kAYVibrantButtonDefaultAnimationDuration: TimeInterval = 0.15
private let kAYVibrantButtonDefaultAlpha: CGFloat = 1.0
private let kAYVibrantButtonDefaultInvertAlphaHighlighted: CGFloat = 1.0
private let kAYVibrantButtonDefaultTranslucencyAlphaNormal: CGFloat = 1.0
private let kAYVibrantButtonDefaultTranslucencyAlphaHighlighted: CGFloat = 0.5
private let kAYVibrantButtonDefaultCornerRadius: CGFloat = 4.0
private let kAYVibrantButtonDefaultRoundingCorners = UIRectCorner.allCorners
private let kAYVibrantButtonDefaultBorderWidth: CGFloat = 0.6
private let kAYVibrantButtonDefaultFontSize = 14.0
private let kAYVibrantButtonDefaultTintColor = UIColor.white

import UIKit

enum AYVibrantButtonStyle {
    case invert, translucent, fill
}


class AYVibrantButton: UIControl {
    var animated = true
    var animationDuration: TimeInterval?
    var invertAlphaHighlighted: CGFloat? {
        didSet {
            updateOverlayAlpha()
        }
    }
    override var alpha: CGFloat {
        didSet {
            updateOverlayAlpha()
        }
    }
    var translucencyAlphaNormal: CGFloat? {
        didSet {
            updateOverlayAlpha()
        }
    }
    var translucencyAlphaHighlighted: CGFloat? {
        didSet {
            updateOverlayAlpha()
        }
    }
    var cornerRadius: CGFloat? {
        willSet {
            normalOverlay?.cornerRadius = newValue
            highlightedOverlay?.cornerRadius = newValue
        }
    }
    var roundingCorners: UIRectCorner? {
        willSet {
            normalOverlay?.roundingCorners = newValue
            highlightedOverlay?.roundingCorners = newValue
        }
    }
    var borderWidth: CGFloat? {
        willSet {
            normalOverlay?.borderWidth = newValue
            highlightedOverlay?.borderWidth = newValue
        }
    }
    var icon: UIImage? {
        willSet {
            normalOverlay?.icon = newValue
            highlightedOverlay?.icon = newValue
        }
    }
    var text: String? {
        willSet {
            normalOverlay?.text = newValue
            highlightedOverlay?.text = newValue
        }
    }
    var font: UIFont? {
        willSet {
            normalOverlay?.font = newValue
            highlightedOverlay?.font = newValue
        }
    }
    var vibrancyEffect: UIVibrancyEffect?

    override var tintColor: UIColor! {
        willSet {
            normalOverlay?.tintColor = newValue
            highlightedOverlay?.tintColor = newValue
        }
    }
    
    private var _tintColor: UIColor?
    private var style: AYVibrantButtonStyle?
    private var visualEffectView: UIVisualEffectView?
    private var normalOverlay: AYVibrantButtonOverlay?
    private var highlightedOverlay: AYVibrantButtonOverlay?
    private var activeTouch = false
    fileprivate var hideRightBorder = false {
        willSet {
            normalOverlay?.hideRightBorder = newValue
            highlightedOverlay?.hideRightBorder = newValue
        }
    }
    
    init(frame: CGRect, style: AYVibrantButtonStyle) {
        super.init(frame: frame)
        self.style = style
        isOpaque = false
        
        animationDuration = kAYVibrantButtonDefaultAnimationDuration
        cornerRadius = kAYVibrantButtonDefaultCornerRadius
        roundingCorners = kAYVibrantButtonDefaultRoundingCorners
        borderWidth = kAYVibrantButtonDefaultBorderWidth
        invertAlphaHighlighted = kAYVibrantButtonDefaultInvertAlphaHighlighted
        translucencyAlphaNormal = kAYVibrantButtonDefaultTranslucencyAlphaNormal
        translucencyAlphaHighlighted = kAYVibrantButtonDefaultTranslucencyAlphaHighlighted
        alpha = kAYVibrantButtonDefaultAlpha
        
        createOverlays()
        
        vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragInside])
        addTarget(self, action: #selector(touchUp), for: [.touchDragOutside, .touchCancel])
    }
    
    override func layoutSubviews() {
        normalOverlay?.frame = bounds
        highlightedOverlay?.frame = bounds
    }
    
    func createOverlays() {
        if style == .fill {
            normalOverlay = AYVibrantButtonOverlay(style: .invert)
        } else {
            normalOverlay = AYVibrantButtonOverlay(style: .normal)
        }
        
        if style == .invert {
            highlightedOverlay = AYVibrantButtonOverlay(style: .invert)
            highlightedOverlay?.alpha = 0
        } else if style == .translucent || style == .fill {
            if let translucencyAlphaNormal = translucencyAlphaNormal {
                normalOverlay?.alpha = translucencyAlphaNormal * alpha
            }
        }
    }
    
    func updateOverlayAlpha() {
        if activeTouch {
            if style == .invert {
                normalOverlay?.alpha = 0
                if let invertAlphaHighlighted = invertAlphaHighlighted {
                    highlightedOverlay?.alpha = invertAlphaHighlighted * alpha
                }
            } else if style == .translucent || style == .fill {
                if let invertAlphaHighlighted = invertAlphaHighlighted {
                    highlightedOverlay?.alpha = invertAlphaHighlighted * alpha
                }
            }
        } else {
            if style == .invert {
                normalOverlay?.alpha = alpha
                highlightedOverlay?.alpha = 0
            } else if style == .translucent || style == .fill {
                if let translucencyAlphaNormal = translucencyAlphaNormal {
                    highlightedOverlay?.alpha = translucencyAlphaNormal * alpha
                }
            }
        }
    }
    
    func touchDown() {
        activeTouch = true
        animating(0, highlightedOverlayAlpha: alpha)
    }
    
    func touchUp() {
        activeTouch = false
        animating(alpha, highlightedOverlayAlpha: 0)
    }
    
    func animating(_ normalOverlayAlpha: CGFloat, highlightedOverlayAlpha: CGFloat) {
        let update = {
            if self.style == .invert {
                self.normalOverlay?.alpha = normalOverlayAlpha
                self.highlightedOverlay?.alpha = highlightedOverlayAlpha
            } else if self.style == .translucent || self.style == .fill {
                if let translucencyAlphaNormal = self.translucencyAlphaNormal {
                    self.highlightedOverlay?.alpha = translucencyAlphaNormal * self.alpha
                }
            }
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration!, animations: update)
        } else {
            update()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum AYVibrantButtonOverlayStyle {
    case normal, invert
}

class AYVibrantButtonOverlay: UIView {
    var cornerRadius: CGFloat? {
        willSet {
            setNeedsDisplay()
        }
    }
    var roundingCorners: UIRectCorner? {
        willSet {
            setNeedsDisplay()
        }
    }
    var borderWidth: CGFloat? {
        willSet {
            setNeedsDisplay()
        }
    }
    var icon: UIImage? {
        willSet {
            text = nil
            setNeedsDisplay()
        }
    }
    var text: String? {
        willSet {
//            icon = nil
            setNeedsDisplay()
        }
    }
    var font: UIFont? {
        willSet {
            updateTextHeight()
            setNeedsDisplay()
        }
    }
    
    override var tintColor: UIColor! {
        willSet {
            setNeedsDisplay()
        }
    }
    
    private var _font: UIFont?
    private var _tintColor: UIColor?
    private var style: AYVibrantButtonOverlayStyle?
    private var textHeight: CGFloat?
    fileprivate var hideRightBorder = false {
        willSet {
            setNeedsDisplay()
        }
    }
    
    init(style: AYVibrantButtonOverlayStyle) {
        super.init(frame: .zero)
        self.style = style
    }
    
    init() {
        super.init(frame: .zero)
        cornerRadius = kAYVibrantButtonDefaultCornerRadius
        roundingCorners = kAYVibrantButtonDefaultRoundingCorners
        borderWidth = kAYVibrantButtonDefaultBorderWidth
        
        isOpaque = false
        isUserInteractionEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let size = bounds.size
        if size.width == 0 || size.height == 0 { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(bounds)
        tintColor.setStroke()
        tintColor.setFill()
        
        var boxRect = bounds.insetBy(dx: borderWidth! / 2, dy: borderWidth! / 2)
        if hideRightBorder {
            boxRect.size.width += borderWidth! * 2
        }
        
        let path = UIBezierPath(roundedRect: boxRect, byRoundingCorners: roundingCorners!, cornerRadii: CGSize(width: cornerRadius!, height: cornerRadius!))
        path.lineWidth = borderWidth!
        path.stroke()
        
        if style == .invert {
            path.fill()
        }
        
        context.clip(to: boxRect)
        
         if let icon = icon {
            let iconSize = icon.size
            let iconRect = CGRect(origin: CGPoint(x: (size.width - iconSize.width) / 2, y: (size.height - iconSize.height) / 2), size: icon.size)
            if style == .normal {
                context.setBlendMode(.normal)
                context.fill(iconRect)
                context.setBlendMode(.destinationIn)
            } else if style == .invert {
                context.setBlendMode(.destinationOut)
            }
            
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            // for some reason, drawInRect does not work here
            context.draw((self.icon?.cgImage)!, in: iconRect)
        }
        
        if let text = text {
            let paragraphstyle = NSMutableParagraphStyle()
            paragraphstyle.lineBreakMode = .byTruncatingTail
            paragraphstyle.alignment = .center
            
            if style == .invert {
                context.setBlendMode(.clear)
            }
            (text as NSString).draw(in: CGRect(x: 0, y: (size.height - self.textHeight!) / 2, width: size.width, height: self.textHeight!), withAttributes: [NSFontAttributeName : font!, NSForegroundColorAttributeName : tintColor, NSParagraphStyleAttributeName : paragraphstyle])
        }
    }
    
    func updateTextHeight() {
        textHeight = ((text ?? "") as NSString).boundingRect(with: CGSize(width: DBL_MAX, height: DBL_MAX), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font ?? UIFont.systemFont(ofSize: UIFont.buttonFontSize)], context: nil).height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AYVibrantButtonGroup: UIView {
    var buttons = [AYVibrantButton]()
    var buttonCount = 0
    var animated = false {
        willSet {
            buttons.forEach {
                $0.animated = newValue
            }
        }
    }
    var animationDuration: TimeInterval? {
        willSet {
            buttons.forEach {
                $0.animationDuration = newValue
            }
        }
    }
    var invertAlphaHighlighted: CGFloat? {
        willSet {
            buttons.forEach {
                $0.invertAlphaHighlighted = newValue
            }
        }
    }
    var translucencyAlphaNormal: CGFloat? {
        willSet {
            buttons.forEach {
                $0.translucencyAlphaNormal = newValue
            }
        }
    }
    var translucencyAlphaHighlighted: CGFloat? {
        willSet {
            buttons.forEach {
                $0.translucencyAlphaHighlighted = newValue
            }
        }
    }
    var cornerRadius: CGFloat = kAYVibrantButtonDefaultCornerRadius {
        willSet {
            buttons.first?.cornerRadius = newValue
            buttons.last?.cornerRadius = newValue
        }
    }
    var borderWidth: CGFloat = kAYVibrantButtonDefaultBorderWidth {
        willSet {
            buttons.forEach {
                $0.borderWidth = newValue
            }
        }
    }
    var font: UIFont? {
        willSet {
            buttons.forEach {
                $0.font = newValue
            }
        }
    }
    var vibrancyEffect: UIVibrancyEffect? {
        willSet {
            buttons.forEach {
                $0.vibrancyEffect = newValue
            }
        }
    }

    override var tintColor: UIColor! {
        willSet {
            buttons.forEach {
                $0.tintColor = newValue
            }
        }
    }
    
    init(frame: CGRect, buttonTitles: [String], style: AYVibrantButtonStyle) {
        super.init(frame: frame)
        buttonGrounp(with: #selector(setText), objects: buttonTitles, style: style)
    }
    
    init(frame: CGRect, buttonIcons: [String], style: AYVibrantButtonStyle) {
        super.init(frame: frame)
    }
    
    func setText() {
        
    }
    
    override func layoutSubviews() {
        if buttonCount == 0 {
            return
        }
        
        let size = bounds.size
        let buttonWidth = size.width / CGFloat(buttonCount)
        let buttonHeight = size.height
        for (i, button) in buttons.enumerated() {
            button.frame = CGRect(x: buttonWidth * CGFloat(i), y: 0, width: buttonWidth, height: buttonHeight)
        }
    }
    
    func buttonAt(index: Int) -> AYVibrantButton {
        return buttons[index]
    }
    
    private func buttonGrounp(with selector: Selector, objects: [String], style: AYVibrantButtonStyle) {
        isOpaque = false
        
        let count = objects.count
        (0..<count).forEach {
            let button = AYVibrantButton(frame: .zero, style: style)
            if count == 1 {
                button.roundingCorners = .allCorners
            } else if $0 == 0 {
                button.roundingCorners = [.topLeft, .bottomLeft]
                button.hideRightBorder = true
            } else if $0 == count - 1{
                button.roundingCorners = [.topRight, .bottomRight]
            } else {
                button.roundingCorners = .topLeft
                button.cornerRadius = 0
                button.hideRightBorder = true
            }
            addSubview(button)
            buttons.append(button)
        }
        buttonCount = count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


