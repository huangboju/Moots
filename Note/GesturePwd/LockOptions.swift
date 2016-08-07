//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct LockOptions: LockDataSource {
    
    /// 选中圆大小比例
    var scale: CGFloat = 0.3
    
    /// 选中圆大小的线宽
    var arcLineWidht: CGFloat = 1
    
    /// 密码后缀
    var passwordKeySuffix = ""
    
    
    // MARK: - 设置密码
    
    /// 最低设置密码数目
    var settingTittle = "设置密码"
    
    var passwordMinCount = 4
    
    /// 密码错误次数
    var errorTimes = 5
    
    /// 设置密码提示文字
    var setPassword = "请滑动设置新密码"
    
    /// 重绘密码提示文字
    var secondPassword = "请重新绘制新密码"
    
    /// 设置密码提示文字：确认
    var confirmPassword = "请再次输入确认密码"
    
    /// 设置密码提示文字：再次密码不一致
    var differentPassword = "再次密码输入不一致"
    
    /// 设置密码提示文字：设置成功
    var setSuccess = "密码设置成功!"
    
    // MARK: - 验证密码
    
    var verifyTittle = "验证密码"
    
    /// 验证密码：普通提示文字
    var enterPassword = "请滑动输入密码"
    
    /// 验证密码：密码错误
    var enterPasswordWrong = "输入密码错误"
    
    
    /// 验证密码：验证成功
    var passwordCorrect = "密码正确"
    
    
    //MARK: - 修改密码
    
    var modifyTittle = "修改密码"
    
    /// 修改密码：普通提示文字
    var enterOldPassword = "请输入旧密码"
    
    
    //MARK: - 颜色
    
    /// 背景色
    var backgroundColor = rgba(255, g: 255, b: 255, a: 1)
    
    /// 外环线条颜色：默认
    var circleLineNormalColor = rgba(173, g: 216, b: 230, a: 1)
    
    /// 外环线条颜色：选中
    var circleLineSelectedColor = rgba(0, g: 191, b: 255, a: 1)
    
    /// 实心圆
    var circleLineSelectedCircleColor = rgba(0, g: 191, b: 255, a: 1)
    
    /// 连线颜色
    var lockLineColor = rgba(0, g: 191, b: 255, a: 1)
    
    /// 警示文字颜色
    var warningTitleColor = rgba(254, g: 82, b: 92, a: 1)
    
    /// 普通文字颜色
    var normalTitleColor = rgba(192, g: 192, b: 192, a: 1)
}

extension LockOptions: LockDelegate {
    var barTittleColor: UIColor {
        return UIColor.blackColor()
    }
}
