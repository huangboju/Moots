//
//  ShaperLayerVC.swift
//  UICollectionViewDemo
//
//  Created by 黄伯驹 on 2021/7/27.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import UIKit

class ShaperLayerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let drawingView = UIView()
        drawingView.backgroundColor = UIColor.systemYellow
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView)
        drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drawingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawingView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let drawingView1 = UIView()
        drawingView1.backgroundColor = UIColor.systemGreen
        drawingView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView1)
        drawingView1.topAnchor.constraint(equalTo: drawingView.bottomAnchor).isActive = true
        drawingView1.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drawingView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawingView1.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let drawingView2 = UIView()
        drawingView2.backgroundColor = UIColor.systemBlue
        drawingView2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView2)
        drawingView2.topAnchor.constraint(equalTo: drawingView1.bottomAnchor).isActive = true
        drawingView2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drawingView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawingView2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        drawingView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true

        drawingView.layer.mask = mask()

        drawingView1.layer.mask = mask()

        drawingView2.layer.mask = mask()
    }

    func mask() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 120))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.move(to: CGPoint(x: 500, y: 200))
        path.addLine(to: CGPoint(x: 550, y: 200))
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
}
