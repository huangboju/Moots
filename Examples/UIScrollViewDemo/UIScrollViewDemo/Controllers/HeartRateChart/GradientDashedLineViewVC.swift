//
//  GradientDashedLineViewVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/21.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import Foundation

final class GradientDashedLineViewVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = GradientDashedLineView()
        v.lineWidth = 2
        v.dashLength = 6
        v.dashGap = 4

        view.addSubview(v)
        v.frame = CGRect(x: 100, y: 100, width: 10, height: 200) // 宽度给大一点也行，线会画在中间
    }
}

final class GradientDashedLineView: UIView {
    
    private lazy var dashMask: CAShapeLayer = {
        let dashMask = CAShapeLayer()
        dashMask.fillColor = UIColor.clear.cgColor
        dashMask.strokeColor = UIColor.black.cgColor  // 作为 mask 只看 alpha，颜色无所谓
        dashMask.lineCap = .butt
        dashMask.lineCap = .round
        dashMask.lineWidth = lineWidth
        dashMask.lineDashPattern = [
            NSNumber(value: Float(dashLength)),
            NSNumber(value: Float(dashGap))
        ]
        return dashMask
    }()


    // 可按需调
    var lineWidth: CGFloat = 1.5 {
        didSet {
            dashMask.lineWidth = lineWidth
        }
    }
    
    var dashLength: CGFloat = 4
    var dashGap: CGFloat = 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // 纵向渐变：上 -> 下
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer?.endPoint   = CGPoint(x: 0, y: 1.0)

        // 颜色：#BE38384D, #BE3838, #BE3838, #BE38384D
        gradientLayer?.colors = [
            UIColor(hex: "#BE38384D").cgColor,
            UIColor(hex: "#BE3838").cgColor,
            UIColor(hex: "#BE3838").cgColor,
            UIColor(hex: "#BE38384D").cgColor
        ]

        gradientLayer?.mask = dashMask
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let x = bounds.midX
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: bounds.height))

        dashMask.frame = bounds
        dashMask.path = path.cgPath
    }
    
    var gradientLayer: CAGradientLayer? {
        layer as? CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}

// MARK: - Hex Color
private extension UIColor {
    convenience init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }

        func hex2(_ str: Substring) -> CGFloat {
            CGFloat(Int(str, radix: 16) ?? 0) / 255.0
        }

        switch s.count {
        case 6: // RRGGBB
            let r = hex2(s.prefix(2))
            let g = hex2(s.dropFirst(2).prefix(2))
            let b = hex2(s.dropFirst(4).prefix(2))
            self.init(red: r, green: g, blue: b, alpha: 1)

        case 8: // RRGGBBAA（按你给的 #BE38384D 就是这种）
            let r = hex2(s.prefix(2))
            let g = hex2(s.dropFirst(2).prefix(2))
            let b = hex2(s.dropFirst(4).prefix(2))
            let a = hex2(s.dropFirst(6).prefix(2))
            self.init(red: r, green: g, blue: b, alpha: a)

        default:
            self.init(white: 0, alpha: 0)
        }
    }
}
