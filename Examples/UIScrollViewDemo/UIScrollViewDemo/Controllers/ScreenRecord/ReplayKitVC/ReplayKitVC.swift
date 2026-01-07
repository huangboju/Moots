//
//  ReplayKitVC.swift
//  UIScrollViewDemo
//
//  Created by bula on 2026/1/7.
//  Copyright © 2026 伯驹 黄. All rights reserved.
//

import UIKit
import SwiftUI

final class ReplayKitVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let host = UIHostingController(rootView: ContentView())
        addChild(host)
        view.addSubview(host.view)

        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        host.didMove(toParent: self)
    }
}
