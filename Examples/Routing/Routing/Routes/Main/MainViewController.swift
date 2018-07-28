//
//  ViewController.swift
//  Routing
//
//  Created by 黄伯驹 on 2018/7/28.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    let viewModel: MainViewModel
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["push", "modal", "modal(custom)", "push(custom)"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.backgroundColor = .green
        return segmentedControl
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Settings", for: .normal)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(settingsButton)
        view.addSubview(segmentedControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedControl.frame = CGRect(x: 0, y: 60, width: 320, height: 50)
        
        settingsButton.frame.size = CGSize(width: 100, height: 50)
        settingsButton.center = view.center
    }
    
    // MARK: - Actions
    
    @objc private func settingsButtonPressed(_ sender: UIButton) {
        viewModel.didTriggerSettingsEvent()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.setValue(sender.selectedSegmentIndex, forKey: "index")
    }
}

