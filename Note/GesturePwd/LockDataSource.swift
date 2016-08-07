//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol LockDataSource {
    
    /// 选中圆大小比例
    var scale: CGFloat { get }
    
    /// 选中圆大小的线宽
    var arcLineWidht: CGFloat { get }
    
    /// 密码后缀
    var passwordKeySuffix: String { get }
    
    
    // MARK: - 设置密码
    
    /// 最低设置密码数目
    var settingTittle: String { get }
    
    var passwordMinCount: Int { get }
    
    /// 密码错误次数
    var errorTimes: Int { get }
    
    /// 设置密码提示文字
    var setPassword: String { get }
    
    /// 重绘密码提示文字
    var secondPassword: String { get }
    
    /// 设置密码提示文字：确认
    var confirmPassword: String { get }
    
    /// 设置密码提示文字：再次密码不一致
    var differentPassword: String { get }
    
    /// 设置密码提示文字：设置成功
    var setSuccess: String { get }
    
    // MARK: - 验证密码
    
    var verifyTittle: String { get }
    
    /// 验证密码：普通提示文字
    var enterPassword: String { get }
    
    /// 验证密码：密码错误
    var enterPasswordWrong: String { get }
    
    
    /// 验证密码：验证成功
    var passwordCorrect: String { get }
    
    
    //MARK: - 修改密码
    
    var modifyTittle: String { get }
    
    /// 修改密码：普通提示文字
    var enterOldPassword: String { get }
    
    
    //MARK: - 颜色
    
    /// 背景色
    var backgroundColor: UIColor { get }
    
    /// 外环线条颜色：默认
    var circleLineNormalColor: UIColor { get }
    
    /// 外环线条颜色：选中
    var circleLineSelectedColor: UIColor { get }
    
    /// 实心圆
    var circleLineSelectedCircleColor: UIColor { get }
    
    /// 连线颜色
    var lockLineColor: UIColor { get }
    
    /// 警示文字颜色
    var warningTitleColor: UIColor { get }
    
    /// 普通文字颜色
    var normalTitleColor: UIColor { get }
}
