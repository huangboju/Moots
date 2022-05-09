//
//  ViewController.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/10/18.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[Selector]] = [
        [
            #selector(overCurrentContext),
            #selector(custom),
            #selector(navSub)
        ],
        [
            #selector(modalPresentationStyleCustom)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "dismiss", style: .plain, target: self, action: #selector(dismissAction))
    }
    
    @objc
    func dismissAction() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func navSub() {
        definesPresentationContext = true
        let presentingVC = CustomNav(rootViewController: PresentingViewController())
        presentingVC.modalPresentationStyle = .overCurrentContext
        present(presentingVC, animated: true, completion: nil)
    }
    
    @objc
    func custom() {
        definesPresentationContext = false

        let secondViewController = PresentingViewController()
        secondViewController.modalPresentationStyle = .custom
        let presentationController = PresentationController(presentedViewController: secondViewController, presenting: self)
        withExtendedLifetime(presentationController) {
            secondViewController.transitioningDelegate = presentationController
            
            present(secondViewController, animated: true, completion: nil)
        }
    }

    @objc
    func modalPresentationStyleCustom() {
        show(PresentingVC(), sender: nil)
    }

    @objc
    func overCurrentContext() {
        definesPresentationContext = true

        let secondViewController = PresentingViewController()
        secondViewController.modalPresentationStyle = .overCurrentContext
        let presentationController = PresentationController(presentedViewController: secondViewController, presenting: self)
        withExtendedLifetime(presentationController) {
            secondViewController.transitioningDelegate = presentationController
            
            present(secondViewController, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row])"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        perform(data[indexPath.section][indexPath.row])
    }
}
