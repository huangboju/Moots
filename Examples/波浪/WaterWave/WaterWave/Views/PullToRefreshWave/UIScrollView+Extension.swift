//
//  UIScrollView+Extension.swift
//  WaterWave
//
//  Created by 伯驹 黄 on 2016/10/15.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

var hh_associatePullToRefreshViewKey = "hh_associatePullToRefreshViewKey"

extension UIScrollView {
    var pullToRefreshView: PullToRefreshWaveView? {
        set {
            objc_setAssociatedObject(self, &hh_associatePullToRefreshViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &hh_associatePullToRefreshViewKey) as? PullToRefreshWaveView
        }
    }
    
    
    func hh_addRefreshViewWithAction(handler: (() -> Void)?) {
        let refreshWaveView = PullToRefreshWaveView()
        addSubview(refreshWaveView)
        pullToRefreshView = refreshWaveView
        
        refreshWaveView.actionHandler = handler
        refreshWaveView.observe(scrollView: self)
    }

    func hh_removeRefreshView() {
        if pullToRefreshView == nil {
            return;
        }
        pullToRefreshView?.invalidateWave()
        pullToRefreshView?.removeObserver(scrollView: self)
        pullToRefreshView?.removeFromSuperview()
    }

    func hh_setRefreshViewTopWaveFill(color: UIColor) {
        pullToRefreshView?.topWaveColor = color
    }

    func hh_setRefreshViewBottomWaveFill(color: UIColor) {
        pullToRefreshView?.bottomWaveColor = color
    }
}
