//
//  VerifyCoInfoController.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class VerifyCoInfoNotNeededCell: UITableViewCell, Updatable {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .groupTableViewBackground

        let button = HZUIHelper.generateNormalButton(title: "搞错了，不需要", target: self, action: #selector(notNeededAction))
        button.setTitleColor(UIColor(hex: 0x4A4A4A), for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFontMake(12)
        contentView.addSubview(button)

        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func notNeededAction() {
        
    }
}

class VerifyCoInfoController: GroupTableController, CoVerifyActionable {
    override func initSubviews() {
        tableView.tableHeaderView = VerifyCoInfoHeaderView()
        tableView.separatorStyle = .none

        rows = [
            [
                Row<CompanyInfoCell>(viewData: NoneItem()),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入您的企业邮箱", title: "工作邮箱")),
                Row<VerifyCoInfoFieldCell>(viewData: VerifyCoInfoFieldItem(placeholder: "请输入公司名称", title: "公司名称")),
                Row<CoInfoVerifyCell>(viewData: NoneItem()),
                Row<VerifyCoInfoNotNeededCell>(viewData: NoneItem())
            ]
        ]
    }

    @objc
    func verifyAction() {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let headerView: VerifyCoInfoHeaderView? = tableHeaderView()
        headerView?.model = "华住金会员权益"
    }
}

