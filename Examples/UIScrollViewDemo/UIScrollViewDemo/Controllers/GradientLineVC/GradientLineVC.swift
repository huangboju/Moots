//
//  GradientLineVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/15.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import UIKit

// MARK: - 渐变折线图（平滑曲线）
final class GradientLineChartView: UIView {

    /// 0...1 归一化的 y 数据（越大越靠上）
    var values: [CGFloat] = [] {
        didSet { setNeedsLayout() }
    }

    /// 线宽（对应你图里的“线宽 2”）
    var lineWidth: CGFloat = 2 {
        didSet { shapeLayer.lineWidth = lineWidth }
    }

    /// 画布内边距
    var contentInset = UIEdgeInsets(top: 24, left: 32, bottom: 32, right: 32) {
        didSet { setNeedsLayout() }
    }

    // 背景容器（做圆角+阴影更像图里的卡片）
    private let cardView = UIView()

    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor(white: 0.15, alpha: 1)

        // 卡片背景
        addSubview(cardView)
        cardView.backgroundColor = UIColor(white: 0.06, alpha: 1)
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.35
        cardView.layer.shadowRadius = 18
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)

        // 多色横向渐变（从左到右）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.locations = [0.00, 0.10, 0.18, 0.30, 0.70, 0.82, 0.92, 1.00] as [NSNumber]

        // 曲线（用来当 mask）
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor // 实际不显示（被渐变遮罩），但要有
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round

        // 关键：让渐变只沿曲线显示
        gradientLayer.mask = shapeLayer
        cardView.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 卡片占满（你也可以改成固定大小）
        cardView.frame = bounds.insetBy(dx: 16, dy: 16)
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 10).cgPath

        gradientLayer.frame = cardView.bounds

        let plotRect = cardView.bounds.inset(by: contentInset)
        shapeLayer.frame = cardView.bounds
        shapeLayer.path = makeSmoothPath(in: plotRect).cgPath
    }

    private func makeSmoothPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        guard values.count >= 2 else { return path }

        // 把 values(0...1) 映射到 rect
        let pts: [CGPoint] = values.enumerated().map { (i, v) in
            let t = CGFloat(i) / CGFloat(values.count - 1)
            let x = rect.minX + t * rect.width
            let y = rect.maxY - clamp01(v) * rect.height
            return CGPoint(x: x, y: y)
        }

        // Catmull-Rom 平滑成三次贝塞尔
        path.move(to: pts[0])
        for i in 0..<(pts.count - 1) {
            let p0 = pts[safe: i - 1] ?? pts[i]
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let p3 = pts[safe: i + 2] ?? pts[i + 1]

            let c1 = CGPoint(
                x: p1.x + (p2.x - p0.x) / 6.0,
                y: p1.y + (p2.y - p0.y) / 6.0
            )
            let c2 = CGPoint(
                x: p2.x - (p3.x - p1.x) / 6.0,
                y: p2.y - (p3.y - p1.y) / 6.0
            )
            path.addCurve(to: p2, controlPoint1: c1, controlPoint2: c2)
        }

        return path
    }

    private func clamp01(_ x: CGFloat) -> CGFloat { min(max(x, 0), 1) }
}

// MARK: - 小工具
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}

// MARK: - 示例用法（放到你的 VC 里）
final class DemoChartViewController: UIViewController {
    private let chart = GradientLineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.12, alpha: 1)

        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chart.heightAnchor.constraint(equalToConstant: 360)
        ])

        chart.lineWidth = 2

        // 这组数据会画出“中间高、左右下”的走势（接近你图）
        chart.values = [
            0.25, 0.48, 0.52, 0.50, 0.57, 0.53, 0.55, 0.54,
            0.58, 0.60, 0.56, 0.62, 0.54, 0.57, 0.60, 0.58,
            0.61, 0.59, 0.56, 0.28, 0.10
        ]
    }
}
