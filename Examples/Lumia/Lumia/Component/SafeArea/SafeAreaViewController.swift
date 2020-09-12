//
//  SafeAreaViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 11/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class SafeAreaViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe navigation bar to increase safe area insets.\nLong press anywhere to hide top and bottom bars"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    private lazy var safeAreaInsetsLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        layer.fillColor = UIColor.green.cgColor
        layer.opacity = 0.5
        return layer
    }()
    
    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewLongPressed))
        return recognizer
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(navigationBarPanned))
        return recognizer
    }()
    
    private var additionalInsetsInitialValue: CGFloat = 0.0
    private var additionalInsetsValue: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleLabel
        view.layer.addSublayer(safeAreaInsetsLayer)
        navigationController?.view.addGestureRecognizer(longPressGestureRecognizer)
        navigationController?.navigationBar.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSafeAreaInsetsLayer()
    }

    func layoutSafeAreaInsetsLayer() {
        let layerPath = UIBezierPath(rect: view.bounds)
        let holePath = UIBezierPath(rect: safeAreaInsetsLayerFrame())
        layerPath.append(holePath)
        layerPath.usesEvenOddFillRule = true
        safeAreaInsetsLayer.path = layerPath.cgPath
    }
    
    // MARK: - Actions
    
    @objc private func viewLongPressed() {
        guard longPressGestureRecognizer.state == .began else {
            return
        }
        longPressed()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func navigationBarPanned() {
        switch panGestureRecognizer.state {
        case .ended, .cancelled, .failed:
            additionalInsetsInitialValue = additionalInsetsValue
        default:
            updateAdditionalSafeAreas()
        }
    }

    // MARK: - Long Press
    
    func longPressed() {
        guard let navigationController = navigationController  else {
            return
        }
        navigationController.setNavigationBarHidden(!navigationController.isNavigationBarHidden, animated: false)
    }
    
    // MARK: - Safe Area
    
    private func updateAdditionalSafeAreas() {
        let translation = panGestureRecognizer.translation(in: view)
        additionalInsetsValue = additionalInsetsInitialValue + translation.x
        if additionalInsetsValue > view.frame.width {
            additionalInsetsValue = view.frame.width
        }
        if additionalInsetsValue < 0.0 {
            additionalInsetsValue = 0.0
        }
        let additionalSafeAreaInsets = UIEdgeInsets(
            top: additionalInsetsValue,
            left: additionalInsetsValue,
            bottom: additionalInsetsValue,
            right: additionalInsetsValue)
        updateAdditionalSafeAreaInsets(additionalSafeAreaInsets)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func safeAreaInsetsLayerFrame() -> CGRect {
        return sa_safeAreaFrame
    }
    
    func updateAdditionalSafeAreaInsets(_ insets: UIEdgeInsets) {
        if #available(iOS 11, *) {
            additionalSafeAreaInsets = insets
        }
    }
}
