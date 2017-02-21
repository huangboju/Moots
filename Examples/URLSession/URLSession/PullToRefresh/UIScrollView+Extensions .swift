//
//  UIScrollView+Extensions .swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension UIScrollView {
    func headerRefresher(handle: @escaping RefreshingBlock) {
        let headerView = CurveRefreshHeaderView(associatedScrollView: self)
        headerView.triggerPulling()
        headerView.refreshingBlock = handle
    }

    func footerRefresher(handle: @escaping RefreshingBlock) {
        let footerView = CurveRefreshFooterView(associatedScrollView: self)
        footerView.refreshingBlock = handle
    }

    func endRefresh() {
        (viewWithTag(12580) as? CurveRefreshHeaderView)?.stopRefreshing()
        (viewWithTag(12581) as? CurveRefreshFooterView)?.stopRefreshing()
    }
}
