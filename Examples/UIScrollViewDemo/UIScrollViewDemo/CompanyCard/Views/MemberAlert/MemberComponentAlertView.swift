//
//  MemberComponentAlertView.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class MemberComponentAlertView: UIView {
    private let formView: FormView = {
        let formView = FormView()
        formView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        formView.separatorStyle = .none
        formView.isScrollEnabled = false
        formView.allowsSelection = false
        formView.backgroundColor = .white
        formView.layer.cornerRadius = 8
        return formView
    }()

    private lazy var coRightsFrameView: CoRightsFrameView = {
        let coRightsFrameView = CoRightsFrameView()
        return coRightsFrameView
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = HZUIHelper.generateNormalButton(imageName: "ic_btn_close", target: self, action: #selector(closeAction))
        closeButton.frame = CGRect(x: self.frame.width - 78, y: 85, width: 25, height: 25)
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        return closeButton
    }()

    static let size = UIScreen.main.bounds.size

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -type(of: self).size.height, width: type(of: self).size.width, height: 0))
        
        let topMargin: CGFloat = 136

        let maxY = closeButton.frame.maxY
        let height = topMargin - maxY
        let vLine = CALayer(frame: CGRect(x: closeButton.center.x - 0.5, y: closeButton.frame.maxY, width: 1, height: height))
        vLine.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(vLine)
        
        addSubview(closeButton)
        
        addSubview(formView)
        formView.snp.makeConstraints { (make) in
            make.width.equalTo(294)
            make.height.equalTo(400)
            make.centerX.equalToSuperview()
            make.top.equalTo(topMargin)
        }
    }

    func show() {
        
        let buttonItem = MemberComponentBtnItem(
            isShowDescLabel: true,
            buttonTitle: "立即激活",
            buttonTarget: target,
            buttonAction: #selector(MemberAlertViewController.testAction)
        )
        
        guard superview == nil else {
            return
        }

        formView.rows = [
            [
                Row<MemberAlertTitleCell>(viewData: NoneItem()),
                Row<MemberComponentFrameCell>(viewData: NoneItem()),
                Row<MemberComponentBtnCell>(viewData: buttonItem)
            ]
        ]

        UIApplication.shared.keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = 0
            self.frame.size.height = type(of: self).size.height
        }, completion: { _ in
            self.backgroundColor = UIColor(white: 0, alpha: 0.6)
        })
    }
    
    func dissmiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundColor = .clear
            self.subviews.forEach { $0.removeFromSuperview() }
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    @objc
    private func closeAction() {
        dissmiss()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
