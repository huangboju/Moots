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


//        let maskView = MaskView()
//        maskView.maskColor = UIColor.white
        let maskView = DrawView()
        maskView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maskView)
        maskView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        maskView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        maskView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true

        let path = UIBezierPath()

        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 700))
        path.addLine(to: CGPoint(x: 150, y: 700))

//        maskView.addTransparentPath(path)
        
    }

    func mask() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.view.frame, cornerRadius: 0)
        shapeLayer.lineWidth = 2
        shapeLayer.fillRule = .evenOdd
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 120))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.move(to: CGPoint(x: 500, y: 200))
        path.addLine(to: CGPoint(x: 550, y: 200))
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
}

// https://stackoverflow.com/questions/35724906/draw-transparent-uibezierpath-line-inside-drawrect
class DrawView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let clippingPath = UIBezierPath()

        let context = UIGraphicsGetCurrentContext() // get your current context

        // draw your background color
        UIColor.green.set();
        context?.fill(bounds)

        context?.saveGState()

        context?.setBlendMode(.destinationOut)


        // do 'transparent' drawing

        UIColor.white.set();
        clippingPath.move(to: CGPoint(x: 10, y: self.bounds.height / 2))
        clippingPath.addLine(to: CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2))
        clippingPath.lineWidth = 6
        clippingPath.lineCapStyle = .round
        clippingPath.stroke()

        context?.restoreGState()

        // do further drawing if needed
    }
}
