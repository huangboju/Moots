//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

typealias selectedData = (NSIndexPath) -> Void

class Banner: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    private let cellIdentifier = "scrollUpCell"
    private var timer = dispatch_source_t?()
    private var lastContentOffset: CGFloat!
    private var isLeft = false /// 滑动方向
    private var isFirst = true // 第一次进入时显示第一个cell
    private var urlStrs: [String]? /// 图片链接

    var pageStepTime: UInt64 = 3 /// 自动滚动时间间隔
    var bgColor: UIColor?
    private var backClosure: selectedData?

    init(frame: CGRect, content: [String]) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        collectionViewLayout = layout
        backgroundColor = .whiteColor()
        dataSource = self
        delegate = self
        registerClass(BannerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        setTheTimer()
        setContent(content)
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView _: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if let count = urlStrs?.count {
            return count
        } else {
            assert(urlStrs?.count == 0, "titles is nil")
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        if let color = bgColor {
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = .whiteColor()
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView _: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if isFirst {
            isFirst = false
            scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
        }
        (cell as? BannerCell)?.setData(urlStrs![indexPath.row])
    }

    func collectionView(collectionView _: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let backClosure = self.backClosure {
            backClosure(indexPath)
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView _: UIScrollView) {
        // 取消定时器
        if let time = self.timer {
            dispatch_source_cancel(time)
            timer = nil
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        if page <= 0.0 {
            scrollToItemAtIndexPath(NSIndexPath(forItem: urlStrs!.count - 2, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
        } else if page >= CGFloat(urlStrs!.count - 1) {
            scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
        }
    }

    func scrollViewDidEndDragging(scrollView _: UIScrollView, willDecelerate _: Bool) {
        setTheTimer()
    }

    private func setTheTimer() {
        // http://www.jianshu.com/p/74a713cb5025
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        let start = dispatch_time(DISPATCH_TIME_NOW, Int64(pageStepTime * NSEC_PER_SEC))
        let interval = (pageStepTime * NSEC_PER_SEC)
        dispatch_source_set_timer(timer!, start, interval, 0)
        dispatch_source_set_event_handler(timer!) {
            self.nextItem()
        }

        // 启动定时器
        dispatch_resume(timer!)
    }

    func nextItem() {
        let indexPath = indexPathsForVisibleItems().first ?? NSIndexPath()
        scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.row + 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }

    func setContent(content: [String]) {
        urlStrs = content
        urlStrs?.insert(content.last ?? "", atIndex: 0)
        urlStrs?.append(content.first ?? "")
    }

    func selectedItem(tempItem: selectedData) {
        backClosure = tempItem
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
