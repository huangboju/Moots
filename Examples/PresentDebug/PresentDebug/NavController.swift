//
//  NavController.swift
//  PresentDebug
//
//  Created by xiAo_Ju on 2018/11/7.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        Mediator.setObject(viewController)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let result = super.popViewController(animated: animated)
        print(Mediator.mapTable)
        return result
    }

}

class Mediator {
    static let mapTable = NSMapTable<NSString, UIViewController>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
    
    class func setObject(_ obj: UIViewController) {
        mapTable.setObject(obj, forKey: NSUUID().uuidString as NSString)
    }
}
