//
//  SecondController.swift
//  SwipeBack
//
//  Created by 伯驹 黄 on 2017/3/9.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    lazy var postButton: AssistiveTouch = {
        let width: CGFloat = 56
        let padding: CGFloat = 25
        let postButton = AssistiveTouch(frame: CGRect(x: (self.view.frame.width - width) - padding, y: self.view.frame.height - width - padding, width: width, height: width))
        postButton.setTitleColor(.white, for: .normal)
        postButton.setTitle("投放", for: .normal)
        postButton.backgroundColor = UIColor.blue
        postButton.alpha = 0
        postButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return postButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground

        UIApplication.shared.keyWindow?.addSubview(postButton)
        UIView.animate(withDuration: 0.4) {
            self.postButton.alpha = 1
        }

        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(action))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postButton.removeFromSuperview()
    }

    func action(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let x = sender.translation(in: view).x
            let progress = 1 - min(1, x / view.frame.width)
            postButton.alpha = progress
        default:
            UIView.animate(withDuration: 0.4) {
                self.postButton.alpha = 1
            }
        }
    }

    func submit() {
        
    }
    
    deinit {
        print(#function)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension SecondController: BackBarButtonItemDelegate {
    public func viewControllerShouldPopOnBackBarButtonItem() -> Bool {
        UIView.animate(withDuration: 0.4) { 
            self.postButton.alpha = 0
        }
        return true
    }
}

// SO: http://stackoverflow.com/questions/1214965/setting-action-for-back-button-in-navigation-controller/19132881#comment34452906_19132881
public protocol BackBarButtonItemDelegate {
    func viewControllerShouldPopOnBackBarButtonItem() -> Bool
}

extension UINavigationController {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        if viewControllers.count < navigationBar.items!.count {
            return true
        }
        var shouldPop = true
        if let viewController = topViewController as? BackBarButtonItemDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackBarButtonItem()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: { () in
                        view.alpha = 1.0
                    })
                }
            }
        }
        return false
    }
}
