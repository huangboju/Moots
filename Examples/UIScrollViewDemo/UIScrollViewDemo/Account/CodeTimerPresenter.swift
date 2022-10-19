//
//  VerificationCodePresenter.swift
//  DaDaXTStuMo
//
//  Created by 黄伯驹 on 2017/8/12.
//  Copyright © 2017年 dadaabc. All rights reserved.
//

import UIKit

enum CheckCodeError: Error {
    case codeError
}

protocol VerificationCodePresenter: AnyObject {
    var timer: DispatchSourceTimer? { set get }
}

extension VerificationCodePresenter {
    func waitingCode(button: UIButton) {

        button.isEnabled = false
        var _timeOut = 60
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(wallDeadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler {
            if _timeOut > 0 {
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.text = "\(_timeOut == 60 ? 60 : _timeOut % 60)秒后重新获取"
            } else {
                button.titleLabel?.text = "获取验证码"
                button.isSelected = true
                self.timer?.cancel()
            }
            _timeOut -= 1
        }
        // 启动定时器
        timer?.resume()
    }

    func deinitTimer() {
        timer?.cancel()
        timer = nil
    }
}

enum CodeError: Error {
    case codeError
}
