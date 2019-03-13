//
//  GestureVC.swift
//  UIScrollViewDemo
//
//  Created by xiAo_Ju on 2019/3/13.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import UIKit


class GestureView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("GestureView touchesBegan")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("GestureView touchesCancelled")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("GestureView touchesEnded")
    }
}


class GestureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureView = GestureView()
        gestureView.backgroundColor = .red
        view.addSubview(gestureView)
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        gestureView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        gestureView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        gestureView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gestureView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesEnded = false
        tapGesture.numberOfTapsRequired = 2
        gestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        print("tap")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
    }
}
