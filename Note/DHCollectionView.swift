//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class DHCollectionView: UICollectionView {
    
    var height: CGFloat = 66 {
        didSet {
            frame.size.height = height
            (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize.height = height
        }
    }
    
    var cellClass: UICollectionViewCell.Type = DHCollectionCell.self {
        willSet {
            registerClass(newValue, forCellWithReuseIdentifier: newValue.cellID)
        }
    }
    
    var handleBack: selectedData? {
        didSet {
            backClosure = handleBack
        }
    }
    
    private var urlStrs: [(String?, UIImage?)]? ///图片链接
    
    private var backClosure: selectedData?
    
    init(origin: CGPoint, content: [(String?, UIImage?)]) {
        super.init(frame: CGRect(origin: origin, size: CGSize(width: SCREEN_WIDTH, height: height)), collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        let width = SCREEN_WIDTH / CGFloat(content.count > 3 ? 4 : content.count)
        layout.itemSize = CGSize(width: width, height: height)
        urlStrs = content
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        collectionViewLayout = layout
        backgroundColor = .whiteColor()
        dataSource = self
        delegate = self
        scrollEnabled = content.count > 4
        registerClass(cellClass, forCellWithReuseIdentifier: cellClass.cellID)
        showsHorizontalScrollIndicator = false
    }
    
    func selectedItem(tempItem: selectedData) {
        self.backClosure = tempItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DHCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = urlStrs?.count {
            return count
        } else {
            assert(urlStrs?.count == 0, "titles is nil")
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellClass.cellID, forIndexPath: indexPath)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.redColor()
        } else {
            cell.backgroundColor = UIColor.blueColor()
        }
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? DHCollectionCell)?.contents = urlStrs?[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let backClosure = self.backClosure {
            backClosure(indexPath)
        }
    }
}

class DHCollectionCell: UICollectionViewCell {
    
    var contents: (String?, UIImage?)? {
        didSet {
            iconView.setButton(contents?.0, image: contents?.1)
        }
    }
    
    private let iconView = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView.bounds = CGRect(origin: CGPoint.zero, size: frame.size)
        iconView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        iconView.enabled = false
        iconView.adjustsImageWhenDisabled = false
        contentView.addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum IconDirection {
    case Left, Right, Bottom, Top
}

extension UIButton {
    func setButton(title: String?, image: UIImage?, direction: IconDirection = .Top, interval: CGFloat = 16.0) {
        setTitle(title, forState: .Normal)
        setImage(image, forState: .Normal)
        adjustsImageWhenHighlighted = false
        titleLabel?.backgroundColor = backgroundColor
        imageView?.backgroundColor = backgroundColor
        guard let titleSize = titleLabel?.bounds.size, imageSize = imageView?.bounds.size else {
            return
        }
        
        let margin = abs(titleSize.width - imageSize.width) / 2
        switch direction {
        case .Left:
            imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + interval, 0, -(titleSize.width + interval))
            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)
        case .Bottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, margin, titleSize.height + interval, 0)
            titleEdgeInsets = UIEdgeInsetsMake(imageSize.height + interval, -imageSize.width, 0, 0)
        case .Right:
            titleEdgeInsets = UIEdgeInsetsMake(0, interval, 0, 0)
        case .Top:
            imageEdgeInsets = UIEdgeInsetsMake(titleSize.height + interval, margin, 0, 0)
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, imageSize.height + interval, 0)
        }
    }
}






