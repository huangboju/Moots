//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

// ???: automaticallyAdjustsScrollViewInsets = false 在一个只有这个视图的Controller中加上这句

import UIKit

class BannerView: UIView {
    typealias selectedData = (Int) -> Void
    var pageStepTime = 5 { /// 自动滚动时间间隔
        didSet {
            setTheTimer()
        }
    }
    var bgColor: UIColor?
    var handleBack: selectedData? {
        didSet {
            backClosure = handleBack
        }
    }
    var showPageControl = true {
        willSet {
            if !newValue {
                pageControl?.removeFromSuperview()
            }
        }
    }

    fileprivate let cellIdentifier = "scrollUpCell"

    private var timer: DispatchSourceTimer?
    fileprivate var isFirst = true // 第一次进入时显示第一个cell
    fileprivate var backClosure: selectedData?
    fileprivate var pageControl: UIPageControl?
    fileprivate var collectionView: UICollectionView?

    fileprivate lazy var urlStrs = [String]() /// 图片链接

    fileprivate lazy var storeUrlStrs = [String]() /// 用于和外部数据比较，是否reload

    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
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
        pageControl = UIPageControl(frame: CGRect(x: (frame.width - 60) / 2, y: frame.height - 30, width: 60, height: 20))
        pageControl?.pageIndicatorTintColor = UIColor(white: 0.7, alpha: 0.8)
        addSubview(pageControl!)
    }

    fileprivate func setTheTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.scheduleRepeating(deadline: .now() + .seconds(pageStepTime), interval: .seconds(pageStepTime))
        timer?.setEventHandler {
            self.nextItem()
        }
        // 启动定时器
        timer?.resume()
    }

    fileprivate func deinitTimer() {
        if let time = self.timer {
            time.cancel()
            timer = nil
        }
    }

    func nextItem() {
        if !urlStrs.isEmpty {
            let indexPath = collectionView?.indexPathsForVisibleItems.first ?? IndexPath()
            if indexPath.row + 1 < urlStrs.count {
                collectionView?.scrollToItem(at: IndexPath(item: indexPath.row + 1, section: 0), at: .centeredHorizontally, animated: true)
            } else {
                collectionView?.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }

    func set(content: [String]) {
        urlStrs = content
        pageControl?.numberOfPages = content.count
        if content.count > 1 {
            urlStrs.insert(content.last ?? "", at: 0)
            urlStrs.append(content.first ?? "")
        } else {
            deinitTimer()
        }
        if storeUrlStrs != urlStrs {
            storeUrlStrs = urlStrs
            collectionView?.reloadData()
        }
        setTheTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlStrs.count
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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isFirst && urlStrs.count > 1 {
            isFirst = false
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
        cell.backgroundColor = UIColor(white: CGFloat(indexPath.row) / 10, alpha: 1)
        let bannerCell = (cell as? BannerCell)
        bannerCell?.urlStr = urlStrs[(indexPath).row]
        bannerCell?.text = indexPath.row.description
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let backClosure = self.backClosure {
            backClosure(max((indexPath).row - 1, 0))
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        deinitTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        if page <= 0.0 {
            // 向右拉
            collectionView?.scrollToItem(at: IndexPath(item: urlStrs.count - 2, section: 0), at: .centeredHorizontally, animated: false)
            pageControl?.currentPage = urlStrs.count - 3
        } else if page >= CGFloat(urlStrs.count - 1) {
            // 向左
            pageControl?.currentPage = 0
            collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            let value = page.truncatingRemainder(dividingBy: 1) < 0.5
            if value { // cell过半才改变pageControl
                pageControl?.currentPage = Int(page) - 1
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTheTimer()
    }
}

class BannerCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: self.bounds.insetBy(dx: 15, dy: 15))
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 66)
        return textLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)

        contentView.addSubview(textLabel)
    }
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    var urlStr: String! {
        didSet {
//            if let url = URL(string: urlStr) {
//                imageView.kf.setImage(with: url)
//            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
