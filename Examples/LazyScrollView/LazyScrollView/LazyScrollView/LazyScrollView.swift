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

protocol LazyScrollViewDelegate {
    func scrollView(_ scrollView: LazyScrollView, didSelectItemAt index: Int)
}

class LazyScrollView: UIScrollView {
    
    var dataSource: LazyScrollViewDataSource? {
        didSet {
            if dataSource != nil {
                reloadData()
            }
        }
    }
    
    /// 重用池
    private var reuseViews: [String: Set<UIView>] = [:]
    
    /// 当前屏幕已经显示的Views
    private var visibleViews: [UIView] = []
    
    /// 所有的View的RectModel
    private var allModels: [RectModel] = []
    
    private var numberOfItems = 0

    /// 注册的View的Classes类型
    private var registerClass: [String: UIView.Type] = [:]

    private let kBufferSize: CGFloat = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let newVisibleViews = visiableViewModels
        let newVisiblelazyIDs = newVisibleViews.flatMap { $0.lazyID }
        let removeViews: [UIView]
        for view in visibleViews {
            if !newVisiblelazyIDs.contains(view.lazyID) {
               removeViews.append(view)
            }
        }
        for view in removeViews {
            visibleViews.remove(view)
            enqueueReusableView(view)
            view.removeFromSuperview()
        }
        
        let alreadyVisibles = visibleViews.flatMap { $0.lazyID }
        
        for model in newVisibleViews {
            if alreadyVisibles.contains(model.lazyID) {
                continue
            }
            let view = dataSource!.scrollView(self, itemBy: model.lazyID)
            view.frame = model.absRect
            view.lazyID = model.lazyID

            visibleViews.append(view)
            addSubview(view)
        }
    }

    func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        visibleViews.removeAll()
        
        updateAllRects()
    }

    func enqueueReusableView(_ view: UIView) {
        guard let identifier = view.reuseIdentifier else { return }
        var reuseSet = self.reuseViews[identifier]
        if reuseSet == nil {
            reuseSet = Set<UIView>()
            reuseViews[identifier] = reuseSet
        }
        reuseSet?.insert(view)
    }
    
    func dequeueReusableItem(with identifier: String) -> UIView {
        var reuseSet = reuseViews[identifier]
        if let view = reuseSet?.first {
            _ = reuseSet?.remove(view)
            return view
        } else {
            let viewClass = registerClass[identifier]
            let view = viewClass?.init()
            view?.reuseIdentifier = identifier
            return view!
        }
    }
    
    func register(viewClass: UIView.Type, forViewReuse identifier: String) {
        registerClass[identifier] = viewClass
    }
    
    var minEdgeOffset: CGFloat {
        return max(contentOffset.y - kBufferSize, 0)
    }
    
    var maxEdgeOffset: CGFloat {
        let max = contentOffset.y + bounds.height
        return min(max + kBufferSize, contentSize.height)
    }
    
    func findSet(with minEdge: CGFloat) -> Set<RectModel> {
        let ascendingEdgeArray = allModels.sorted {  $0.0.absRect.maxY > $0.1.absRect.maxY }
        
        var minIndex = 0
        var maxIndex = ascendingEdgeArray.count - 1
        var midIndex = (minIndex + maxIndex) / 2
        var model = ascendingEdgeArray[midIndex]
        while minIndex < maxIndex - 1 {
            if model.absRect.maxY < CGFloat(minEdge) {
                maxIndex = midIndex
            } else {
                minIndex = midIndex
            }
            midIndex = (minIndex + maxIndex) / 2
            model = ascendingEdgeArray[midIndex]
        }
        midIndex = max(midIndex - 1, 0)
        let array = ascendingEdgeArray[midIndex...ascendingEdgeArray.count - midIndex]

        return Set(arrayLiteral: array)
    }
    
    func findSet(with maxEdge: CGFloat) -> NSMutableSet {
        let descendingEdgeArray = allModels.sorted {  $0.0.absRect.maxY < $0.1.absRect.maxY }
        
        var minIndex = 0
        var maxIndex = descendingEdgeArray.count - 1
        var midIndex = (minIndex + maxIndex) / 2
        var model = descendingEdgeArray[midIndex]
        while minIndex < maxIndex - 1 {
            if model.absRect.maxY < CGFloat(maxEdge) {
                maxIndex = midIndex
            } else {
                minIndex = midIndex
            }
            midIndex = (minIndex + maxIndex) / 2
            model = descendingEdgeArray[midIndex]
        }
        midIndex = max(midIndex - 1, 0)
        let array = descendingEdgeArray[midIndex...descendingEdgeArray.count - midIndex]
        
        return NSMutableSet(array: array)
    }
    
    var visiableViewModels: [RectModel] {
        let ascendSet =
        return [RectModel]()
    }
    
    func updateAllRects() {
        
    }
    
    /// 获取所有的RectModel
    func allModelCount() {
        
        allModels.removeAll(keepingCapacity: true)
        
        let count = dataSource!.numberOfItem(in: self)
        
        for i in 0..<count {
            
            let model = dataSource.scrollView(self, rectModelAt: i)
            allModels.append(model)
        }
        
        if let model = allModels.last {
            let absRect = model.absRect
            contentSize = CGSize(width: bounds.width, height: absRect.minY + model.absRect.height + 15)
        }
    }
    
    var visibleRectModelInScreen: [RectModel] {
        
        let ascendSet = ascendYAndFindGreaterThanTop
        
        let descendSet = descendYAppendHeightAndFindLessThanBottom
        
        
        ascendSet.intersects(descendSet)
        
        return
    }
    
    /**
     将所有的RectModel按顶边(y)升序排序
     
     @return 所有底边y大于top的model
     */
    var ascendYAndFindGreaterThanTop: NSSet {
        
        // 根据顶边(y)升序排序
        
        var ascendY = allModels
        
        
        // 找到所有底边y大于top的model
        
        let top = contentOffset.y - 20
        
        var array: [RectModel]
        
        
        for i in 0..<ascendY.count {
            let model = ascendY[i]
            
            if model.absRect.minY + model.absRect.height > top {
                array = ascendY[0...3]
                break
            }
        }
        
        
        let ascendSet = NSSet(array: array)
        
        return ascendSet
    }
    
    var descendYAppendHeightAndFindLessThanBottom: NSMutableSet {
        // 根据底边(y+height)降序排序
        
        return NSMutableSet()
    }

    func dequeueReusableItem(with identifier: String) -> UIView {
        
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
