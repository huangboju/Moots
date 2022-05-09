//
//  LazyScrollView.swift
//  LazyScrollView
//
//  Created by 伯驹 黄 on 2016/12/9.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

protocol LazyScrollViewDataSource: class {
    /// ScrollView一共展示多少个item
    func numberOfItems(in scrollView: LazyScrollView) -> Int
    
    /// 要求根据index直接返回RectModel
    func scrollView(_ scrollView: LazyScrollView, rectModelAt index: Int) -> RectModel

    /// 返回下标所对应的view
    func scrollView(_ scrollView: LazyScrollView, itemBy lazyID: String) -> UIView
}

protocol LazyScrollViewDelegate: class {
    func scrollView(_ scrollView: LazyScrollView, didSelectItemAt index: String)
}

class LazyScrollView: UIScrollView {
    
    weak var dataSource: LazyScrollViewDataSource? {
        didSet {
            if dataSource != nil {
                reloadData()
            }
        }
    }
    weak var lazyDelegate: LazyScrollViewDelegate?

    /// 重用池
    private lazy var reuseViews: [String: Set<UIView>] = [:]
    
    /// 当前屏幕已经显示的Views
    private lazy var visibleViews: [UIView] = []
    
    /// 所有的View的RectModel
    private lazy var allModels: [RectModel] = []
    
    private var numberOfItems = 0

    /// 注册的View的Classes类型
    private lazy var registerClass: [String: UIView.Type] = [:]

    private let kBufferSize: CGFloat = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let newVisibleViews = visiableViewModels
        
        let newVisiblelazyIDs = newVisibleViews.compactMap { $0.lazyID }
        var removeViews: [UIView] = []
        for view in visibleViews {
            if !newVisiblelazyIDs.contains(view.lazyID ?? "") {
               removeViews.append(view)
            }
        }
        for view in removeViews {
            visibleViews.remove(view)
            enqueueReusableView(view)
            view.removeFromSuperview()
        }

        let alreadyVisibles = visibleViews.compactMap { $0.lazyID }

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
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapItem)))
            view?.isUserInteractionEnabled = true
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
        
        let ascendingEdgeArray = allModels.sorted {  $0.absRect.maxY > $1.absRect.maxY }
        
        var minIndex = 0
        var maxIndex = ascendingEdgeArray.count - 1
        var midIndex = (minIndex + maxIndex) / 2
        var model = ascendingEdgeArray[midIndex]
        while minIndex < maxIndex - 1 {
            if model.absRect.minY > CGFloat(minEdge) {
                maxIndex = midIndex
            } else {
                minIndex = midIndex
            }
            midIndex = (minIndex + maxIndex) / 2
            model = ascendingEdgeArray[midIndex]
        }
        midIndex = max(midIndex - 1, 0)
        let array = ascendingEdgeArray[midIndex..<ascendingEdgeArray.count]

        return Set(array)
    }

    func findSet(withMaxEdge maxEdge: CGFloat) -> Set<RectModel> {
        let descendingEdgeArray = allModels.sorted {  $0.absRect.maxY < $1.absRect.maxY }
        
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
        let array = descendingEdgeArray[midIndex..<descendingEdgeArray.count]

        return Set(array)
    }
    
    var visiableViewModels: [RectModel] {
        let ascendSet = findSet(with: minEdgeOffset)
        let descendSet = findSet(withMaxEdge: maxEdgeOffset)

        return Array(ascendSet.union(descendSet))
    }
    
    func updateAllRects() {
        allModels.removeAll(keepingCapacity: true)
        numberOfItems = dataSource!.numberOfItems(in: self)

        for i in 0..<numberOfItems {
            if let model = dataSource?.scrollView(self, rectModelAt: i) {
                allModels.append(model)
            }
        }

        let model = allModels.last
        contentSize = CGSize(width: bounds.width, height: model?.absRect.maxY ?? 0)
    }
    
    /// 获取所有的RectModel
    func allModelCount() {
        
        allModels.removeAll(keepingCapacity: true)
        
        let count = dataSource!.numberOfItems(in: self)
        
        for i in 0..<count {
            
            let model = dataSource!.scrollView(self, rectModelAt: i)
            allModels.append(model)
        }

        if let model = allModels.last {
            let absRect = model.absRect
            contentSize = CGSize(width: bounds.width, height: absRect.minY + model.absRect.height + 15)
        }
    }
    
    @objc func tapItem(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            lazyDelegate?.scrollView(self, didSelectItemAt: view.lazyID!)
        }
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
