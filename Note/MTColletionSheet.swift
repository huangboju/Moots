//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

//! !!: 添加长按删除
let buttonHight: CGFloat = 44

import Kingfisher

class MTColletionSheet: UIView {
    var showCancelAction = false
    var longPress = false

    private var collection: UICollectionView!
    private var cancelLabel: UILabel!
    private let cusomerView = UIView()
    private var listData: [(icon: String, title: String)]!
    private let SCREEN_SIZE = UIScreen.mainScreen().bounds.size

    private let offset = UIOffset(horizontal: 5, vertical: 5)
    private var width: CGFloat = 0
    private var currentIndexPath: NSIndexPath?
    private var snapedImageView: UIView!
    private var deltaSize: CGSize!

    private var selectedIndex: ((Int) -> Void)?
    private var cancelAction: (() -> Void)?

    init(list: [(icon: String, title: String)], selectedIndex: ((Int) -> Void)? = nil, cancelHandle: (() -> Void)? = nil) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: SCREEN_SIZE))
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        width = SCREEN_SIZE.width / CGFloat(list.count > 4 ? 5 : list.count)
        let n = (list.count + 5 - 1) / 5
        layout.itemSize = CGSize(width: width, height: 2 * buttonHight)
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_SIZE.width, height: layout.itemSize.height * CGFloat(n)), collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.scrollEnabled = false
        collection.backgroundColor = .whiteColor()
        collection.registerClass(CollectionSheetCell.self, forCellWithReuseIdentifier: "cellId")
        cusomerView.addSubview(collection)

        cusomerView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        addSubview(cusomerView)
        listData = list

        self.selectedIndex = selectedIndex
        cancelAction = cancelHandle
    }

    func animeData() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.delegate = self
        addGestureRecognizer(tap)

        UIView.animateWithDuration(0.25) {
            self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
            self.cusomerView.frame.origin.y = self.SCREEN_SIZE.height - self.cusomerView.frame.height
        }
    }

    func show() {
        if showCancelAction {
            cancelLabel = UILabel(frame: CGRect(x: 0, y: collection.frame.height + offset.vertical, width: collection.frame.width, height: buttonHight))
            cancelLabel.layer.backgroundColor = UIColor.whiteColor().CGColor

            cancelLabel.text = "取消"
            cancelLabel.textAlignment = .Center
            cancelLabel.textColor = .blueColor()
            let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
            cancelLabel.userInteractionEnabled = true
            cancelLabel.addGestureRecognizer(tap)
            cusomerView.addSubview(cancelLabel)
        }

        if !longPress {
            collection.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture)))
        }

        cusomerView.frame = CGRect(x: 0, y: SCREEN_SIZE.height, width: SCREEN_SIZE.width, height: showCancelAction ? cancelLabel.frame.maxY : collection.frame.height)
        UIApplication.sharedApplication().keyWindow?.addSubview(self)

        animeData()
    }

    func tapped() {
        UIView.animateWithDuration(0.25, animations: {
            self.alpha = 0
            self.cusomerView.frame.origin.y = self.SCREEN_SIZE.height
        }) { finished in
            if finished {
                for subview in self.cusomerView.subviews {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    func hide() {
        if let cancelAction = self.cancelAction {
            cancelAction()
        }
        tapped()
    }

    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let location = gesture.locationInView(collection)
        print("✈️✈️✈️✈️✈️✈️✈️✈️✈️✈️", location.y)
        let offsetY = SCREEN_SIZE.height - collection.frame.height
        guard let selectedIndexPath = collection.indexPathForItemAtPoint(location) else {
            return
        }
        if let collection = collection {
            switch gesture.state {
            case .Began:
                if let cell = collection.cellForItemAtIndexPath(selectedIndexPath) {
                    snapedImageView = getTheCellSnap(cell)
                    deltaSize = CGSize(width: location.x - cell.frame.minX, height: location.y - cell.frame.minY)
                    snapedImageView.frame.origin = CGPoint(x: cell.frame.minX, y: offsetY + location.y - deltaSize.height)
                    snapedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    cell.alpha = 0.0
                    addSubview(snapedImageView)
                    currentIndexPath = selectedIndexPath
                }
            case .Changed:
                if snapedImageView == nil { return }
                snapedImageView.frame.origin.x = location.x - deltaSize.width
                snapedImageView.frame.origin.y = offsetY + location.y - deltaSize.height
                print("🚗🚗🚗🚗🚗🚗🚗", location.y)
                if let indexPath = currentIndexPath {
                    if selectedIndexPath != currentIndexPath {
                        swap(&listData[selectedIndexPath.row], &listData[indexPath.row])
                        collection.moveItemAtIndexPath(indexPath, toIndexPath: selectedIndexPath)
                        let cell = collection.cellForItemAtIndexPath(selectedIndexPath)
                        cell?.alpha = 0.0
                        currentIndexPath = selectedIndexPath
                    }
                }
            case .Ended:
                if let currentIndexPath = currentIndexPath {
                    if let cell = collection.cellForItemAtIndexPath(currentIndexPath) {
                        UIView.animateWithDuration(0.25, animations: { [unowned self] in
                            self.snapedImageView.transform = CGAffineTransformIdentity
                            self.snapedImageView.frame.origin = CGPoint(x: cell.frame.minX, y: offsetY + location.y - self.deltaSize.height)
                        }, completion: { [unowned self] _ in
                            self.snapedImageView.removeFromSuperview()
                            self.snapedImageView = nil
                            self.currentIndexPath = nil
                            cell.alpha = 1.0
                        })
                    }
                }
            default:
                break
            }
        }
    }

    func getTheCellSnap(targetView: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0)
        targetView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MTColletionSheet: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(collectionView _: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return listData.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath)
    }

    func collectionView(collectionView _: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? CollectionSheetCell)?.setData(listData[indexPath.row])
        let backgroundView = UIView(frame: cell.frame)
        backgroundView.backgroundColor = .colorWithHex(0xDDDCDF)
        cell.selectedBackgroundView = backgroundView
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        tapped()
        if let selectedIndex = selectedIndex {
            selectedIndex(indexPath.row)
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    // 手势和UI控件之间冲突的解决方法
    func gestureRecognizer(gestureRecognizer _: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view is MTColletionSheet
    }
}

class CollectionSheetCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: (frame.width - buttonHight) / 2, y: 8, width: buttonHight, height: buttonHight)
        contentView.addSubview(imageView)
        titleLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 8, width: frame.width, height: 20)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .lightGrayColor()
        contentView.addSubview(titleLabel)
    }

    func setData(item: (icon: String, title: String)) {
        if item.icon.isEmpty {
            imageView.image = R.image.ic_logo()
        } else {
            imageView.kf_setImageWithURL(NSURL(string: item.icon)!)
        }
        if item.title.characters.count == 11 {
            titleLabel.text = item.title.substringWithRange(Range(item.title.endIndex.advancedBy(-4) ..< item.title.endIndex))
        } else {
            titleLabel.text = item.title
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
