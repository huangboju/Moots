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

        view.addSubview(beginLabel)
        beginLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(100)
        }

        view.addSubview(endLabel)
        endLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(beginLabel.snp.bottom).offset(8)
        }

        view.addSubview(axisView)
        axisView.snp.makeConstraints { make in
            make.top.equalTo(beginLabel)
            make.leading.equalTo(beginLabel.snp.trailing).offset(10)
        }


        let panelView = UIView()
        panelView.backgroundColor = .lightGray
        view.addSubview(panelView)
        panelView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }


        let dimension: CGFloat = 50
        panelView.addSubview(button)
        button.backgroundColor = .systemBlue
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(dimension)
            make.width.height.equalTo(dimension)
        }
    }

    @objc
    func touchDown() {
        beginLabel.text = "Tracking began"
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDownRepeat() {
        print("🍀👹👹 \(#function)")
    }

    @objc
    func touchDragInside(sender: UIButton, withEvent event: UIEvent) {
        print("🍀👹👹 \(#function)")
        guard let touch = event.touches(for: sender)?.first else {
            return
        }
        let location = touch.location(in: sender)
        axisView.x = "x: \(location.x)"
        axisView.y = "y: \(location.y)"
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
        endLabel.text = "Tracking ended"
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

    private lazy var beginLabel: UILabel = {
        let beginLabel = UILabel()
        return beginLabel
    }()

    private lazy var endLabel: UILabel = {
        let endLabel = UILabel()
        return endLabel
    }()

    private lazy var axisView: AXISView = {
        let axisView = AXISView()
        return axisView
    }()
}

final class AXISView: UIView {

    var x: String? {
        get {
            xLabel.text
        }
        set {
            xLabel.text = newValue
        }
    }

    var y: String? {
        get {
            yLabel.text
        }
        set {
            yLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            xLabel,
            yLabel
        ])
        stackView.spacing = 6
        stackView.axis = .vertical
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var xLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()

    private lazy var yLabel: UILabel = {
        let valueLabel = UILabel()
        return valueLabel
    }()
}
