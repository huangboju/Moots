//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

enum CoreLockType: Int {
    case Set
    case Veryfy
    case Modify
}

class LockController : UIViewController, BackBarButtonItemDelegate {
    
    private var forget: controllerHandle?
    private var success: controllerHandle?
    private var overrunTimes: controllerHandle?
    private let options = LockManager.sharedInstance.options
    
    private var errorTimes = 1
    private var message: String?
    private var modifyCurrentTitle: String?
    private var controller: UIViewController?
    private var isDirectModify = false
    private var lockView: LockView! {
        didSet {
            if type != .Set {
                let forgetButton = UIButton()
                forgetButton.backgroundColor = options.backgroundColor
                forgetButton.setTitleColor(options.circleLineNormalColor, forState: .Normal)
                forgetButton.setTitleColor(options.circleLineSelectedColor, forState: .Highlighted)
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
        return LockLabel(frame: CGRect(x: 0, y: TOP_MARGIN, width: self.view.frame.width, height: LABEL_HEIGHT), options: self.options)
    }()
    
    private lazy var resetItem: UIBarButtonItem = {
        let resetItem = UIBarButtonItem(title: "重绘", style: .Plain, target: self, action: #selector(redraw))
        return resetItem
    }()
    
    private var type: CoreLockType? {
        didSet {
            if type == .Set {
                message = options.setPassword
            } else if type == .Veryfy {
                message = options.enterPassword
            } else if type == .Modify {
                message = options.enterOldPassword
            }
        }
    }
    
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
            let infoView = LockInfoView(frame: CGRect(x: (view.frame.width - INFO_VIEW_WIDTH) / 2, y: label.frame.minY - 50, width: INFO_VIEW_WIDTH, height: INFO_VIEW_WIDTH), options: options)
            view.addSubview(infoView)
        }
        lockView = LockView(frame: CGRect(x: 0, y: label.frame.minY, width: view.frame.width, height: view.frame.width), options: options)
        //添加顺序不要反 因为lockView的背景颜色不为透明
        view.addSubview(lockView)
        view.addSubview(label)
    }
    
    func event() {
        lockView.passwordTooShortHandle = { [unowned self] in
            self.label.showWarn("请连接至少\(self.options.passwordMinCount)个点")
        }
        
        lockView.passwordTwiceDifferentHandle = { [weak self] (pwd1, pwdNow) in
            self?.label.showWarn(self?.options.differentPassword)
            self?.resetItem.enabled = true
        }
        
        lockView.passwordFirstRightHandle = { [weak self] in
            // 在这里绘制infoView路径
            self?.label.showNormal(self?.options.confirmPassword)
        }
        
        lockView.setSuccessHandle = { [weak self] (password) in
            self?.label.showNormal(self?.options.setSuccess)
            CoreArchive.setStr(password, key: PASSWORD_KEY + self!.options.passwordKeySuffix)
            self?.view.userInteractionEnabled = false
            if let success = self?.success {
                success(self!)
            }
        }
        
       
        lockView.verifyHandle = { [unowned self] (flag) in
            if flag {
                self.label.showNormal(self.options.passwordCorrect)
                if let success = self.success {
                    success(self)
                }
                self.view.userInteractionEnabled = false
                self.dismiss()
            } else {
                if self.errorTimes < self.options.errorTimes {
                    self.label.showWarn("您还可以尝试\(self.options.errorTimes - self.errorTimes)次")
                    self.errorTimes += 1
                } else {
                    self.label.showWarn("错误次数已达上限")
                    if let overrunTimes = self.overrunTimes {
                        overrunTimes(self)
                    }
                }
            }
        }
        
        lockView.modifyHandle = { [unowned self] flag in
            if flag {
                self.label.showNormal(self.options.passwordCorrect)
                let lockVC = LockController()
                lockVC.isDirectModify = true
                lockVC.type = .Set
                self.navigationController?.pushViewController(lockVC, animated: true)
            } else {
                self.label.showWarn(self.options.enterPasswordWrong)
            }
        }
    }
    
    func dataTransfer() {
        label.showNormal(message)
        lockView.type = type
    }
    
    func controllerPrepare() {
        view.backgroundColor = options.backgroundColor
        navigationItem.rightBarButtonItem = nil
        modifyCurrentTitle = options.enterOldPassword
        if type == .Modify {
            if isDirectModify { return }
            navigationItem.leftBarButtonItem = getBarButton("关闭")
        } else if type == .Set {
            if isDirectModify {
                return
            }
            navigationItem.leftBarButtonItem = getBarButton("取消")
            resetItem.enabled = false
            navigationItem.rightBarButtonItem = resetItem
        }
    }
    
    ///展示设置密码控制器
    class func showSettingLockControllerIn(controller: UIViewController, success: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = "设置密码"
        lockVC.type = .Set
        lockVC.success = success
        return lockVC
    }
    
    class func showVerifyLockControllerIn(controller: UIViewController, forget: controllerHandle, success: controllerHandle, overrunTimes: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = "手势解锁"
        lockVC.type = .Veryfy
        lockVC.success = success
        lockVC.forget = forget
        lockVC.overrunTimes = overrunTimes
        return lockVC
    }
    
    class func showModifyLockControllerIn(controller: UIViewController, success: controllerHandle) -> LockController {
        let lockVC = self.lockVC(controller)
        lockVC.title = "修改密码"
        lockVC.type = .Modify
        lockVC.success = success
        return lockVC
    }
    
    class func lockVC(controller: UIViewController) -> LockController {
        let lockVC = LockController()
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
        if let forget = forget {
            forget(self)
        }
    }
    
    func dismissAction() {
        dismiss()
    }
    
    func redraw(sender: UIBarButtonItem) {
        sender.enabled = false
        label.showNormal(options.confirmPassword)
    }
    
    func getBarButton(title: String?) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(dismissAction))
    }
    
    func viewControllerShouldPopOnBackBarButtonItem() -> Bool {
        navigationController?.viewControllers.first?.dismissViewControllerAnimated(true, completion: nil)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
