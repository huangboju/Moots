//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

// 参考支付宝
let LABEL_HEIGHT: CGFloat = 20
let INFO_VIEW_WIDTH: CGFloat = 30
let BUTTON_SPACE: CGFloat = 50
let TOP_MARGIN: CGFloat =  (UIScreen.mainScreen().bounds.height - UIScreen.mainScreen().bounds.width) / 2 + 30
let ITEM_MARGIN: CGFloat = 36

typealias handle = () -> Void
typealias strHandle = (String) -> Void

/// 选中圆大小比例
let ARC_WHR: CGFloat = 0.3

/// 选中圆大小的线宽
let ARC_LINE_WIDTH: CGFloat = 1

/// 密码存储Key
let PASSWORD_KEY = "password_key"

// MARK: - 设置密码

/// 最低设置密码数目
let MIN_ITEM_COUNT = 4

/// 密码错误次数
let PASSWORD_ERROR_COUNT = 5

/// 设置密码提示文字
let SET_PASSWORD = "请滑动设置新密码"

/// 重绘密码提示文字
let CONFIRM_PASSWORD = "请重新绘制新密码"

/// 设置密码提示文字：确认
let CONFIRM_PASSWORD_AGAIN = "请再次输入确认密码"


/// 设置密码提示文字：再次密码不一致
let DIFFERENT_PASSWORD = "再次密码输入不一致"

/// 设置密码提示文字：设置成功
let PASSWORD_SUCCESS = "密码设置成功!"


// MARK: - 验证密码

/// 验证密码：普通提示文字
let ENTER_PASSWORD = "请滑动输入密码"


/// 验证密码：密码错误
let ENTER_PASSWORD_WRONG = "输入密码错误"


/// 验证密码：验证成功
let PASSWORD_CORRECT = "密码正确"

//MARK: - 修改密码

/// 修改密码：普通提示文字
let ENTER_OLD_PASSWORD = "请输入旧密码"

/// 背景色
let BACKGROUND_COLOR = rgba(255, g: 255, b: 255, a: 1)

/// 外环线条颜色：默认
let CoreLockCircleLineNormalColor = rgba(255,g: 150,b: 0,a: 1)

/// 外环线条颜色：选中
let CoreLockCircleLineSelectedColor = rgba(255,g: 150,b: 0,a: 1)

/// 实心圆
let CoreLockCircleLineSelectedCircleColor = rgba(255,g: 150,b: 0,a: 1)

/// 实心圆
let CoreLockLockLineColor = rgba(255,g: 150,b: 0,a: 1)

/// 警示文字颜色
let CoreLockWarnColor = rgba(254,g: 82,b: 92,a: 1)

let RedrawNotification = "RedrawNotification"

/// 普通文字颜色
let CoreLockNormalColor = rgba(192,g: 192,b: 192,a: 1)

func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}

let iphone4x_3_5 = (UIScreen.mainScreen().bounds.height == 480)
let iphone5x_4_0 = (UIScreen.mainScreen().bounds.height == 568)
let iphone6_4_7 = (UIScreen.mainScreen().bounds.height == 667)
let iphone6Plus_5_5 = (UIScreen.mainScreen().bounds.height == 736) || (UIScreen.mainScreen().bounds.width == 414)

