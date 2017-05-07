//
//  ViewController.swift
//  SwipeBack
//
//  Created by 伯驹 黄 on 2017/3/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(push))
    }

    func push() {
        navigationController?.pushViewController(SecondController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

extension UINavigationController {

    static let _onceToken = UUID().uuidString
    
    open override class func initialize(){
        
        if self == UINavigationController.self {
            
            DispatchQueue.once(token: _onceToken) {
                let needSwizzleSelectorArr = [
                    NSSelectorFromString("_updateInteractiveTransition:"),
                ]

                for selector in needSwizzleSelectorArr {
                    
                    let str = ("et_" + selector.description).replacingOccurrences(of: "__", with: "_")
                    let originalMethod = class_getInstanceMethod(self, selector)
                    let swizzledMethod = class_getInstanceMethod(self, Selector(str))
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }

    func et_updateInteractiveTransition(_ percentComplete: CGFloat) {
        print(percentComplete, "😄")
        et_updateInteractiveTransition(percentComplete)
    }
}
