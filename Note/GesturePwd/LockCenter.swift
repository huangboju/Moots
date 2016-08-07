//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LockCenter {
    var options = LockOptions()
    
    static let sharedInstance = LockCenter()
    // 私有化构造方法，阻止其他对象使用这个类的默认的'()'构造方法
    private init () {
        
    }
    
    func hasPassword() -> Bool {
        return CoreArchive.strFor(PASSWORD_KEY + options.passwordKeySuffix) != nil
    }
    
    func removePassword(key: String) {
        CoreArchive.removeValueFor(PASSWORD_KEY + options.passwordKeySuffix)
    }
    
    func showSettingLockControllerIn(controller: UIViewController, success: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = options.settingTittle
        lockVC.type = .Set
        lockVC.success = success
        return lockVC
    }
    
    func showVerifyLockControllerIn(controller: UIViewController, forget: controllerHandle, success: controllerHandle, overrunTimes: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = options.verifyTittle
        lockVC.type = .Verify
        lockVC.success = success
        lockVC.forget = forget
        lockVC.overrunTimes = overrunTimes
        return lockVC
    }
    
    func showModifyLockControllerIn(controller: UIViewController, success: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = options.modifyTittle
        lockVC.type = .Modify
        lockVC.success = success
        return lockVC
    }
    
    private func lockVC(controller: UIViewController) -> LockController {
        let lockVC = LockController()
        lockVC.controller = controller
        controller.presentViewController(LockMainNav(rootViewController: lockVC), animated: true, completion: nil)
        return lockVC
    }
}
