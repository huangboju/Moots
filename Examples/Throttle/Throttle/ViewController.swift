//
//  ViewController.swift
//  Throttle
//
//  Created by xiAo_Ju on 2018/6/7.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var textFiled: UITextField = {
        let width = self.view.frame.width
        let textFiled = UITextField(frame: CGRect(x: 15, y: 100, width: width - 30, height: 44))
        textFiled.addTarget(self, action: #selector(editingChangedAction), for: .editingChanged)
        textFiled.borderStyle = .roundedRect
        return textFiled
    }()
    
    lazy var fn = throttle(delay: 0.05, action: performSearch)
    
    lazy var debounced = debounce(delay: 0.4, action: performSearch)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textFiled)
    }
    
    func bar(bar: String) {
        print("Bar", bar)
    }
    
    func testThrottle() {
        let queue = DispatchQueue.global(qos: .background)
        let fn = throttle1(delay: 1, queue: queue, action: bar)
        for i in 0...9 {
            fn("\(i)")
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
    
    @objc func editingChangedAction(_ sender: UITextField) {

//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
//        perform(#selector(performSearch), with: nil, afterDelay: 0.2)
        
//        🍀🍀🍀 j 🍀🍀🍀
//        🍀🍀🍀 j j 🍀🍀🍀
//        🍀🍀🍀 j j j j 🍀🍀🍀
//        🍀🍀🍀 jj j j jj j 🍀🍀🍀
//        🍀🍀🍀 j j j j j j j j j 🍀🍀🍀

//        fn()
//        dispatch_throttle(0.1) {
//            self.performSearch()
//        }
        
//        debounced()
    }

    @objc func performSearch() {
        print("🍀🍀🍀 \(self.textFiled.text) 🍀🍀🍀")
    }
}
