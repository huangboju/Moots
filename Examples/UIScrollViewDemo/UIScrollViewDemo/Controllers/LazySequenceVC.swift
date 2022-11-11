//
//  LazySequenceVC.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2021/10/17.
//  Copyright © 2021 伯驹 黄. All rights reserved.
//

import Foundation

// https://swiftrocks.com/lazy-sequences-in-swift-and-how-they-work

class LazySequenceVC: UIViewController {

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

//        let allNumbers = Array(1...1000)
//        let normalMap = allNumbers.map {
//            print($0)
//            n * 2
//        }
//        let lazyMap = allNumbers.lazy.map {
//            print($0)
//            $0 * 2
//        }
//        print(lazyMap[0])

        scrollView.backgroundColor = .systemGray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(scrollView)
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        for i in 0 ..< 10 {
            stackView.addArrangedSubview(LabelStackCell(title: "\(i)"))
        }
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
}
