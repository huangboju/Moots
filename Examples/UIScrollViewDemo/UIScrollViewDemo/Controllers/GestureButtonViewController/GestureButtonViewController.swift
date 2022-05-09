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

class HitTestControl: UIControl {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        print(view, event?.allTouches?.first)
        return view
    }
}


class GestureButtonViewController: UIViewController {
    
    private lazy var pannelView: HitTestView = {
        let pannelView = HitTestView()
        pannelView.backgroundColor = UIColor(hex: 0x3498DB)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        pannelView.addGestureRecognizer(tap)

        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = "UITapGestureRecognizer"
        pannelView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        return pannelView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xB3B6B7)

        view.addSubview(pannelView)
        pannelView.snp.makeConstraints { (make) in
            make.centerY.leading.trailing.equalToSuperview()
        }

        initCardView()
    }
    
    func initCardView() {
        let imageView = UIImageView(image: UIImage(named: "UIControl"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        pannelView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }

        let button = HitTestButton()
        button.setTitle(" UIButton ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        imageView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(imageView)
            make.height.equalTo(44)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(hex: 0xF1C40F)
        pannelView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(44)
            make.width.leading.equalTo(imageView)
            make.bottom.equalTo(-40)
        }
        
        let control = HitTestControl()
        control.backgroundColor = .white
        control.addTarget(self, action: #selector(controlClicked), for: .touchUpInside)
        bottomView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = " UIControl "
        control.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalToSuperview()
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
