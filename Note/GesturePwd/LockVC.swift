//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

enum CoreLockType: Int {
    case Set
    case Veryfy
    case Modify
}

class LockVC: UIViewController {
    
    var type: CoreLockType? {
        didSet {
            if type == .Set {
                message = SET_PASSWORD
            } else if type == .Veryfy {
                message = ENTER_PASSWORD
            } else if type == .Modify {
                message = ENTER_OLD_PASSWORD
            }
        }
    }
    
    private var success: ((LockVC, String) -> Void)?
    private var forget: handle?
//    private var overrunTimes: ((LockVC) -> Void)?
    private var message: String?
    private var controller: UIViewController?
    private var modifyCurrentTitle: String?
    private var key: String!
    private var rightBarButtonItem: UIBarButtonItem?
    private var isDirectModify = false
    private var errorTime = 1
    private var lockView: LockView! {
        didSet {
            if type != .Set {
                let forgetButton = UIButton()
                forgetButton.backgroundColor = BACKGROUND_COLOR
                forgetButton.setTitleColor(CoreLockCircleLineNormalColor, forState: .Normal)
                forgetButton.setTitle("忘记密码", forState: .Normal)
                forgetButton.sizeToFit()
                forgetButton.addTarget(self, action: #selector(forgetPwdAction), forControlEvents: .TouchUpInside)
                forgetButton.center.x = view.center.x
                forgetButton.frame.origin.y = lockView.frame.maxY
                view.addSubview(forgetButton)
            }
        }
    }
    private lazy var label: LockLabel = {
        return LockLabel(frame: CGRect(x: 0, y: TOP_MARGIN, width: self.view.frame.width, height: LABEL_HEIGHT))
    }()
    
    private lazy var resetItem: UIBarButtonItem = {
        let resetItem = UIBarButtonItem(title: "重设", style: .Plain, target: self, action: #selector(passwordReset))
        return resetItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onPrepare()
        controllerPrepare()
        dataTransfer()
        event()
    }
    
    private func onPrepare() {
        if type == .Set {
            label.frame.origin.y = label.frame.minY + 30
            let infoView = LockInfoView(frame: CGRect(x: (view.frame.width - INFO_VIEW_WIDTH) / 2, y: label.frame.minY - 50, width: INFO_VIEW_WIDTH, height: INFO_VIEW_WIDTH))
            view.addSubview(infoView)
        }
        lockView = LockView(frame: CGRect(x: 0, y: label.frame.minY, width: view.frame.width, height: view.frame.width))
        //添加顺序不要反 因为lockView的背景颜色不为透明
        view.addSubview(lockView)
        view.addSubview(label)
    }
    
    func event() {
        lockView.setPasswordHandle = { [unowned self] in
            self.label.showNormal(SET_PASSWORD)
        }
        
        lockView.confirmPasswordHandle = { [unowned self] in
            self.label.showNormal(CONFIRM_PASSWORD_AGAIN)
        }
        
        lockView.passwordTooShortHandle = { [unowned self] (count) in
            self.label.showWarn("请连接至少\(count)个点")
        }
        
        lockView.passwordTwiceDifferentHandle = { [unowned self] (pwd1, pwdNow) in
            self.label.showWarn(DIFFERENT_PASSWORD)
            self.navigationItem.rightBarButtonItem = self.resetItem
        }
        
        lockView.passwordFirstRightHandle = { [unowned self] in
            // 在这里是路径
            self.label.showNormal(CONFIRM_PASSWORD_AGAIN)
        }
        
        lockView.setSuccessHandle = { [unowned self] (password) in
            self.label.showNormal(PASSWORD_SUCCESS)
            CoreArchive.setStr(password, key: PASSWORD_KEY)
            self.view.userInteractionEnabled = false
            if let success = self.success {
                success(self, password)
            }
        }
        
        lockView.verifyPasswordHandle = { [unowned self] in
            self.label.showNormal(ENTER_PASSWORD)
        }
        
       
        lockView.verifySuccessHandle = { [unowned self] (password) in
            let pwdLocal = CoreArchive.strFor(PASSWORD_KEY)
            let result = (pwdLocal == password)
            
            if result {
                self.label.showNormal(PASSWORD_CORRECT)
                if self.type == .Veryfy {
                    if let success = self.success {
                        success(self, password)
                    }
                    self.view.userInteractionEnabled = false
                    self.dismiss(0)
                } else if self.type == .Modify {
                    let lockVC = LockVC()
                    lockVC.isDirectModify = true
                    lockVC.type = .Set
                    self.navigationController?.pushViewController(lockVC, animated: true)
                }
            } else {
                self.label.showWarn(ENTER_PASSWORD_WRONG)
            }
            return result
        }
        
        lockView.modifyPasswordHandle = { [unowned self] in
            self.label.showNormal(self.modifyCurrentTitle)
        }
    }
    
    func dataTransfer() {
        label.showNormal(message)
        lockView.type = type
    }
    
    func controllerPrepare() {
        view.backgroundColor = BACKGROUND_COLOR
        navigationItem.rightBarButtonItem = nil
        modifyCurrentTitle = ENTER_OLD_PASSWORD
        if type == .Modify {
            if isDirectModify { return }
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(dismissAction))
        } else if type == .Set {
            if isDirectModify {
                return
            }
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(dismissAction))
            rightBarButtonItem = UIBarButtonItem(title: "重绘", style: .Plain, target: self, action: #selector(redraw))
            rightBarButtonItem?.enabled = false
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    func passwordReset() {
        label.showNormal(SET_PASSWORD)
        navigationItem.rightBarButtonItem = nil
        lockView.resetPassword()
    }
    
    class func hasPassword() -> Bool {
        return CoreArchive.strFor(PASSWORD_KEY) != nil
    }
    
    class func removePassword(key: String) {
        CoreArchive.removeValueFor(PASSWORD_KEY + key)
    }
    
    ///展示设置密码控制器
    class func showSettingLockVCIn(controller: UIViewController, success: (LockVC, pwd: String) -> Void) -> LockVC {
        let lockVC = self.lockVC(controller)
        lockVC.title = "设置密码"
        lockVC.type = .Set
        lockVC.success = success
        
        return lockVC
    }
    
    class func showVerifyLockVCIn(controller: UIViewController, forget: () -> Void, success: (LockVC, pwd: String) -> Void) -> LockVC {
        let lockVC = self.lockVC(controller)
        lockVC.title = "手势解锁"
        lockVC.type = .Veryfy
        lockVC.success = success
        lockVC.forget = forget
        return lockVC
    }
    
    class func showModifyLockVCIn(controller: UIViewController, success: (LockVC, pwd: String) -> Void) -> LockVC {
        let lockVC = self.lockVC(controller)
        lockVC.title = "修改密码"
        lockVC.type = .Modify
        lockVC.success = success
        
        return lockVC
    }
    
    class func lockVC(controller: UIViewController) -> LockVC {
        let lockVC = LockVC()
        lockVC.controller = controller
        controller.presentViewController(LockNavVC(rootViewController: lockVC), animated: true, completion: nil)
        return lockVC
    }
    
    func dismiss(interval: NSTimeInterval = 0, conmpletion: (() -> Void)? = nil) {
        delay(interval) {
            self.dismissViewControllerAnimated(true, completion: conmpletion)
        }
    }
    
    func forgetPwdAction() {
        dismiss()
        if let forget = forget {
            forget()
        }
    }
    
    func dismissAction() {
        dismiss()
    }
    
    func redraw() {
        rightBarButtonItem?.enabled = false
        label.showNormal(CONFIRM_PASSWORD)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
