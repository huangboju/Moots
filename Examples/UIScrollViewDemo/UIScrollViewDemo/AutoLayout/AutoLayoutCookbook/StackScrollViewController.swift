//
//  StackScrollViewController.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/11/11.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

class StackScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        for i in 0 ..< 10 {
            stackView.addArrangedSubview(LabelStackCell(title: "\(i)"))
        }
        stackView.axis = .vertical
        return stackView
    }()
}

class StackScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // https://nemecek.be/blog/126/how-to-disable-automatic-transparent-navbar-in-ios-15
        // https://stackoverflow.com/questions/69111478/ios-15-navigation-bar-transparent
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            navigationBarAppearance.configureWithDefaultBackground()

            navigationController?.navigationBar.tintColor = .label

            navigationItem.scrollEdgeAppearance = navigationBarAppearance
            navigationItem.standardAppearance = navigationBarAppearance
            navigationItem.compactAppearance = navigationBarAppearance

            navigationController?.setNeedsStatusBarAppearanceUpdate()
        }

        view.backgroundColor = .white

        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private lazy var scrollView: StackScrollView = {
        let scrollView = StackScrollView()
        return scrollView
    }()
}
