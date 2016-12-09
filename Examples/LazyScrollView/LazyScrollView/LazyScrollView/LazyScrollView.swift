//
//  LazyScrollView.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

protocol LazyScrollViewDataSource {
    /// ScrollView一共展示多少个item
    func numberOfItem(in scrollView: LazyScrollView) -> Int

    /// 要求根据index直接返回RectModel
    func scrollView(_ scrollView: LazyScrollView, rectModelAt index: Int) -> RectModel

    /// 返回下标所对应的view
    func scrollView(_ scrollView: LazyScrollView, itemBy lazyID: String) -> UIView
}

class LazyScrollView: UIScrollView {
    
    var dataSource: LazyScrollViewDataSource!

    /// 重用池
    private var reuserDict: [String: Any] = [:]

    /// 所有的View的RectModel
    private var allModels: [RectModel] = []

    /// 注册的View的Classes类型
    private var registerClasses: [String: UIView] = [:]

    /// 当前屏幕已经显示的Views
    private var visibleViews: [UIView] = []
    
    override func willMove(toSuperview newSuperview: UIView?) {
        allModelCount()
    }
    
    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        visibleViews.removeAll()
        
        allModelCount()
    }
    
    /// 获取所有的RectModel
    func allModelCount() {
    
        allModels.removeAll(keepingCapacity: true)
        
        
        let count = dataSource?.numberOfItem(in: self) ?? 0
        
        for i in 0..<count {

            let model = dataSource!.scrollView(self, rectModelAt: i)
            allModels.append(model)
        }
    
        if let model = allModels.last {
            let absRect = model.absRect
            contentSize = CGSize(width: bounds.width, height: absRect.minY + model.absRect.height + 15)
        }
    }

    func register(viewClass: AnyClass, forViewReuse identifier: String) {
    
    }

    func dequeueReusableItem(with identifier: String) -> UIView {

    }
}
