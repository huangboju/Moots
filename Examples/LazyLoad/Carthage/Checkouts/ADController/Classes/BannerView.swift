//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

//!!!: automaticallyAdjustsScrollViewInsets = false 在一个只有这个视图的Controller中加上这句

class BannerView: UIView {
    typealias selectedData = (Int) -> Void
    var pageStepTime = 5 ///自动滚动时间间隔
    var bgColor: UIColor?
    var imageContentMode =  UIViewContentMode.scaleAspectFill
    var isAllowLooping = false {
        willSet {
            newValue ? setTheTimer() : deinitTimer()
        }
    }
    var handleBack: selectedData? {
        didSet {
            backClosure = handleBack
        }
    }
    var showPageControl = true {
        willSet {
            if !newValue {
                pageControl.removeFromSuperview()
            }
        }
    }

    fileprivate let cellIdentifier = "scrollUpCell"

    private var timer: DispatchSourceTimer?
    fileprivate var isFirst = true //第一次进入时显示第一个cell
    fileprivate var isUsingImage = true
    fileprivate var backClosure: selectedData?
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: (self.frame.width - 60) / 2, y: self.frame.height - 30, width: 60, height: 20))
        pageControl.pageIndicatorTintColor = UIColor(white: 0.7, alpha: 0.8)
        return pageControl
    }()
    fileprivate var collectionView: UICollectionView?

    fileprivate lazy var images = [UIImage]()
    private lazy var storeimages = [UIImage]()
    fileprivate lazy var urlStrs = [String]() ///图片链接
    private lazy var storeUrlStrs = [String]() ///用于和外部数据比较，是否reload

    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        backgroundColor = UIColor.white
        layout.itemSize = fixSlit(rect: &bounds, itemCount: 1).size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView?.collectionViewLayout = layout
        backgroundColor = UIColor.white
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(BannerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        addSubview(pageControl)
    }
    
    // 修复宽度为小数是的bug（屏幕最小单位为像素）
    func fixSlit(rect: inout CGRect, itemCount: Int) -> CGRect {
        let offsetWidth = rect.width.truncatingRemainder(dividingBy: CGFloat(itemCount))
        if offsetWidth != 0 {
            let pointX = (CGFloat(itemCount) - offsetWidth) / 2
            rect.origin.x = -pointX
            rect.size.width = rect.width + 2 * pointX
        }
        return CGRect(origin: rect.origin, size: CGSize(width: rect.width / CGFloat(itemCount), height: rect.height))
    }

    fileprivate func setTheTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.scheduleRepeating(deadline: .now() + .seconds(pageStepTime), interval: .seconds(pageStepTime))
        timer?.setEventHandler {
            self.nextItem()
        }
        timer?.resume()
    }
    
    fileprivate func deinitTimer() {
        if let time = self.timer {
            time.cancel()
            timer = nil
        }
    }

    func nextItem() {
        if !images.isEmpty {
            let indexPath = collectionView?.indexPathsForVisibleItems.first ?? IndexPath()
            if indexPath.row + 1 < images.count {
                collectionView?.scrollToItem(at: IndexPath(item: indexPath.row + 1, section: 0), at: .centeredHorizontally, animated: true)
            } else {
                collectionView?.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }

    func set(urls: [String]) {
        assert(images.isEmpty, "不要同时设置图片链接和图片")
        isUsingImage = false
        urlStrs = urls
        pageControl.numberOfPages = urls.count
        if isAllowLooping {
            if urls.count > 1 {
                urlStrs.insert(urls.last ?? "", at: 0)
                urlStrs.append(urls.first ?? "")
            } else {
                deinitTimer()
            }
        }
        if storeUrlStrs != urlStrs {
            storeUrlStrs = urlStrs
            collectionView?.reloadData()
        }
    }
    
    func set(images: [UIImage]) {
        assert(urlStrs.isEmpty, "不要同时设置图片链接和图片")
        self.images = images
        pageControl.numberOfPages = images.count
        if isAllowLooping {
            if images.count > 1 {
                self.images.insert(images.last ?? UIImage(), at: 0)
                self.images.append(images.first ?? UIImage())
            } else {
                deinitTimer()
            }
        }
        if storeimages != images {
            storeimages = images
            collectionView?.reloadData()
        }
    }
    
    deinit {
        deinitTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isUsingImage ? images.count : urlStrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        if let color = bgColor {
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
}

extension BannerView: UICollectionViewDelegate {
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isAllowLooping && isFirst {
            isFirst = false
            isUsingImage ? isFirstUse(datas: images) : isFirstUse(datas: urlStrs)
        }
        let bannerCell = (cell as? BannerCell)
        bannerCell?.imageContentMode = imageContentMode
        if isUsingImage {
            bannerCell?.image = images[indexPath.row]
        } else {
            bannerCell?.urlStr = urlStrs[indexPath.row]
        }
    }
    
    func isFirstUse<T>(datas: [T]) {
        if datas.count > 1 {
            collectionView?.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let backClosure = self.backClosure {
            backClosure(isAllowLooping ? max(indexPath.row - 1, 0) : indexPath.row)
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        deinitTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
        guard isAllowLooping else { return }
        if page <= 0.0 {
            // 向右拉
            collectionView?.scrollToItem(at: IndexPath(item: images.count - 2, section: 0), at: .centeredHorizontally, animated: false)
            pageControl.currentPage = images.count - 3
        } else if page >= CGFloat(images.count - 1) {
            // 向左
            pageControl.currentPage = 0
            collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            pageControl.currentPage = Int(page) - 1
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAllowLooping {
            setTheTimer()
        }
    }
}

class BannerCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    var imageContentMode: UIViewContentMode? {
        didSet {
            if let imageContentMode = imageContentMode {
                imageView.contentMode = imageContentMode
                imageView.clipsToBounds = imageContentMode == .scaleAspectFill
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var urlStr: String! {
        didSet {
            if let url = URL(string: urlStr) {
                print(url)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
