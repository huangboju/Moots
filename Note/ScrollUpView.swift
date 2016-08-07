//
//  Copyright © 2016 cmcaifu.com. All rights reserved.
//

import Taylor

class ScrollUpView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    private let cellIdentifier = "scrollUpCell"
    private var timer: NSTimer?

    var titles: [String]?
    var bgColor: UIColor?
    var pageStepTime: NSTimeInterval  = 1
    var scrollPosition: UICollectionViewScrollPosition = .Top

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: frame.size.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionViewLayout = layout
        dataSource = self
        delegate = self
        registerClass(ScrollUpCell.self, forCellWithReuseIdentifier: cellIdentifier)
        pagingEnabled = true
        scrollEnabled = false
        showsVerticalScrollIndicator = false
        setTheTimer()
    }

    //MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = titles?.count {
            return count + 1
        } else {
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

    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case (titles?.count)!, 0:
            (cell as? ScrollUpCell)?.setData(titles![0])
        default:
            (cell as? ScrollUpCell)?.setData(titles![indexPath.row])
        }
    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (titles?.count)! - 1 {
            scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        timer?.invalidate()
        timer = nil
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setTheTimer()
    }

    private func setTheTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(pageStepTime, target: self, selector: #selector(nextItem), userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(timer!, forMode: NSRunLoopCommonModes)
    }

    @objc private func nextItem() {
        let indexPath = indexPathsForVisibleItems().first!
        let item = indexPath.row
//        if item == titles!.count - 1 {
//            scrollToItemAtIndexPath(NSIndexPath(forItem: item + 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
//        } else {
//            scrollToItemAtIndexPath(NSIndexPath(forItem: item + 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
//        }
        scrollToItemAtIndexPath(NSIndexPath(forItem: item + 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrollUpCell: UICollectionViewCell {
    private let title = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        title.textAlignment = .Center
        title.snp_makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.left.equalTo(PADDING)
            make.right.equalTo(-PADDING)
        }
    }

    func setData(text: String) {
        title.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
