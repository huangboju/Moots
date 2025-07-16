//
//  ButtonVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2025/7/16.
//  Copyright © 2025 伯驹 黄. All rights reserved.
//

import Foundation

final class ButtonVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(button)
        button.backgroundColor = .systemBlue
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
            make.width.height.equalTo(100)
        }
    }

    @objc
    func touchDown() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDownRepeat() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDragInside() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDragOutside() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDragEnter() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDragExit() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchUpInside() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchUpOutside() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchCancel() {
        print("🍀👹👹 \(#function)")
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
        button.addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        button.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        button.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
        button.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        button.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        button.addTarget(self, action: #selector(touchCancel), for: .touchCancel)
        return button
    }()
}
