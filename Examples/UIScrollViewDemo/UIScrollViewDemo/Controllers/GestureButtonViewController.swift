//
//  GestureButtonViewController.swift
//  UIScrollViewDemo
//
//  Created by jourhuang on 2020/9/12.
//  Copyright © 2020 伯驹 黄. All rights reserved.
//

import UIKit

class HitTestView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        print(view, event?.allTouches?.first)
        return view
    }
}

class HitTestButton: UIButton {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        print(view, event?.allTouches?.first)
        return view
    }
}


class GestureButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let pannelView = HitTestView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        pannelView.addGestureRecognizer(tap)
        view.addSubview(pannelView)
        pannelView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.bottom.equalTo(-38)
            make.leading.trailing.equalToSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: "square_flowers"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        pannelView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
        }

        let button = HitTestButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        pannelView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(imageView)
            make.width.height.equalTo(44)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = .gray
        pannelView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(44)
            make.width.leading.equalTo(imageView)
        }
        
        let control = UIControl()
        control.backgroundColor = .yellow
        control.addTarget(self, action: #selector(controlClicked), for: .touchUpInside)
        bottomView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    @objc
    func didTap(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
    
    @objc
    func buttonClicked(_ sender: UIButton) {
        print(#function)
    }
    
    @objc
    func controlClicked(_ sender: UIButton, forEvent event: UIEvent) {
        print(#function)
    }
}
