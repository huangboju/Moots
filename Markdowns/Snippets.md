# 常用代码

<details>
    <summary>
        <b>UICollectionView highlight</b>
    </summary>

```swift
        // 方法一
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                cell.backgroundColor = .white

                let backgroundView = UIView(frame: cell.frame)
                backgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1)
                cell.selectedBackgroundView = backgroundView
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             collectionView.deselectItem(at: indexPath, animated: true)
        }

        // 方法二(有延时)
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.contentView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }

        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.contentView.backgroundColor = nil
        }
```

</details>



<details>
    <summary>
        <b>泛型约束</b>
    </summary>

```swift
protocol ArrayPresenter {
    associatedtype ViewType: UIScrollView
    var listView: ViewType! { set get }
}

func loadMore<T: UIScrollView>(listView: T, indexPath: NSIndexPath) where T: YourProtocol {

}
```

</details>



<details>
    <summary>
         <b>银行金额验证</b>
    </summary>

```swift
extension String {
    func enteredCorrectly() -> Bool {
        if length == 0 {
            return false
        }
        let scan = NSScanner(string: self)
        let isNotZero = Double(self) > 0
        if isNotZero {
            if containsString(".") {
                if let rangeOfZero = rangeOfString(".", options: .BackwardsSearch) {
                    let suffix = String(characters.suffixFrom(rangeOfZero.endIndex))
                    if suffix.length > 2 {
                        showAlert(controller, message: "您输入的金额有误")
                        return false
                    }
                }
                var float: Float = 0
                guard !(scan.scanFloat(&float) && scan.atEnd) else { return true }
            } else {
                var int: Int64 = 0
                guard !(scan.scanLongLong(&int) && scan.atEnd) else { return true }
            }
        }
        return false
    }
}
```
</details>


<details>
<summary>
    <b>多标志符字符串分割</b>
</summary>

```swift
let text = "abc,vfr.yyuu"
let set = CharacterSet(charactersIn: ",.")
print(text.components(separatedBy: set)) // ["abc", "vfr", "yyuu"]
```
</details>

<details>
<summary>
    <b><a href="http://swift.gg/2016/06/06/pattern-matching-4/">匹配模式</a></b>
</summary>

```swift
let age = 19
if 18...25 ~= age {
    print("条件满足")
}
同
if age >= 18 && age <= 25 {
    print("条件满足")
}
同
if case 18...25 = age {
    print("条件满足")
}
```

</details>

<details>
<summary>
  <b>单行代码</b>
</summary>

```swift
let arr = (1...1024).map{ $0 * 2 }


let n = (1...1024).reduce(0,combine: +)


let words = ["Swift","iOS","cocoa","OSX","tvOS"]
let tweet = "This is an example tweet larking about Swift"
let valid = !words.filter({ tweet.containsString($0) }).isEmpty
valid //true
let valid2 = words.contains(tweet.containsString)
valid2 //true


// 埃拉托斯特尼筛法
var n = 102
var primes = Set(2...n)
var sameprimes = Set(2...n)
let aa = sameprimes.subtract(Set(2...Int(sqrt(Double(n))))
    .flatMap{(2 * $0).stride(through: n, by:$0)})
let bb = aa.sort()
// bb [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]


let arr = [82, 58, 76, 49, 88, 90]
let retulst = data.reduce(([], [])) {
    $1 < 60 ? ($0.0 + [$1], $0.1) : ($0.0, $0.1 + [$1])
}
// retulst ([58, 49], [82, 76, 88, 90])
```
</details>


<details>
<summary>
  <b><a bref="http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html">GCD map函数</a></b>
</summary>

```swift
extension Array {
    public func pmap(transform: (Element -> Element)) -> [Element] {
        guard !self.isEmpty else {
            return []
        }

        var result: [(Int, [Element])] = []

        let group = dispatch_group_create()
        let lock = dispatch_queue_create("pmap queue for result", DISPATCH_QUEUE_SERIAL)

        let step: Int = max(1, self.count / NSProcessInfo.processInfo().activeProcessorCount) // step can never be 0

        for var stepIndex = 0; stepIndex * step < self.count; stepIndex += 1 {
            let capturedStepIndex = stepIndex

            var stepResult: [Element] = []
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for i in (capturedStepIndex * step)..<((capturedStepIndex + 1) * step) {
                    if i < self.count {
                        let mappedElement = transform(self[i])
                        stepResult += [mappedElement]
                    }
                }

                dispatch_group_async(group, lock) {
                    result += [(capturedStepIndex, stepResult)]
                }
            }
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

        return result.sort { $0.0 < $1.0 }.flatMap { $0.1 }
    }
}

extension Array {
    public func pfilter(includeElement: Element -> Bool) -> [Element] {
        guard !self.isEmpty else {
            return []
        }

        var result: [(Int, [Element])] = []

        let group = dispatch_group_create()
        let lock = dispatch_queue_create("pmap queue for result", DISPATCH_QUEUE_SERIAL)

        let step: Int = max(1, self.count / NSProcessInfo.processInfo().activeProcessorCount) // step can never be 0

        for var stepIndex = 0; stepIndex * step < self.count; stepIndex += 1 {
            let capturedStepIndex = stepIndex

            var stepResult: [Element] = []
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for i in (capturedStepIndex * step)..<((capturedStepIndex + 1) * step) {
                    if i < self.count && includeElement(self[i]) {
                        stepResult += [self[i]]
                    }
                }

                dispatch_group_async(group, lock) {
                    result += [(capturedStepIndex, stepResult)]
                }
            }
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

        return result.sort { $0.0 < $1.0 }.flatMap { $0.1 }
    }
}
```
</details>


<details>
<summary>
    <b>导航栏标题设置</b>
</summary>

```swift
// 需要tabBarItem的title与导航栏title不一致,如下设置navigationbar的titile
navigationItem.title = "示例"
注意: 直接 title = "示例" 在tabbar切换时tabBarItem的title会变成设置
```
</details>


<details>
<summary>
  <b>tabbar隐藏动画(同知乎)</b>
</summary>

```swift
func setTabBarVisible(visible: Bool, animated: Bool) {

//* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time

// bail if the current state matches the desired state
if tabBarIsVisible == visible { return }

// get a frame calculation ready
let frame = tabBarController?.tabBar.frame
let height = frame?.size.height
let offsetY = (visible ? -height! : height)

// zero duration means no animation
let duration: NSTimeInterval = (animated ? 0.3 : 0.0)

//  animate the tabBar
if let rect = frame {
UIView.animateWithDuration(duration) {
self.tabBarController?.tabBar.frame = CGRectOffset(rect, 0, offsetY!)
return
}
}
}

var tabBarIsVisible: Bool {
return tabBarController?.tabBar.frame.minY < view.frame.maxY
}
```
</details>


<details>
  <summary>
    <b>导航栏标返回图片</b>
  </summary>

```swift
navigationBar.backIndicatorTransitionMaskImage = R.image.ic_nav_back()
navigationBar.backIndicatorImage = R.image.ic_nav_back()
```

</details>



<details>
      <summary>
        <b><a href="http://www.jianshu.com/p/4e9619483035">tableView分割线左边到头</a>(_UITableViewCellSeparatorView)</b>
      </summary>

```swift
//写在viewDidLoad http://www.jianshu.com/p/1274343055a7
if tableView.respondsToSelector(Selector("setSeparatorInset:")) {
    tableView.separatorInset = UIEdgeInsetsZero
}
if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
    tableView.layoutMargins = UIEdgeInsetsZero
}

//写在 willDisplayCell
if cell.respondsToSelector(Selector("setSeparatorInset:")) {
    cell.separatorInset = UIEdgeInsetsZero
}
if cell.respondsToSelector(Selector("setLayoutMargins:")) {
    cell.layoutMargins = UIEdgeInsetsZero
}

override func layoutSubviews() {
super.layoutSubviews()
separatorInset = UIEdgeInsetsZero
preservesSuperviewLayoutMargins = false
layoutMargins = UIEdgeInsetsZero
}
```

</details>


<details>
      <summary>
        <b>虚线</b>
      </summary>

```swift
func drawDottedLine(lineView: UIView, offset: CGPoint) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = lineView.bounds
    shapeLayer.position = lineView.layer.position
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = MOOTS_LINE_GRAY.CGColor
    shapeLayer.lineWidth = 0.5
    shapeLayer.lineJoin = kCALineJoinRound
    // 4=线的宽度 1=每条线的间距
    shapeLayer.lineDashPattern = [NSNumber(int: 4), NSNumber(int: 1)]
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, offset.x, offset.y)
    CGPathAddLineToPoint(path, nil, CGRectGetWidth(lineView.frame) - offset.x, offset.y)
    shapeLayer.path = path
    lineView.layer.addSublayer(shapeLayer)
}
```
</details>



<details>
    <summary>
      <b>部分圆角图片</b>
    </summary>

```swift
func cornerImage(frame: CGRect, image: UIImage, Radii: CGSize) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.frame = frame
    let bezierPath = UIBezierPath(roundedRect: imageView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: Radii)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = bezierPath.CGPath
    imageView.layer.mask = shapeLayer
    return imageView
}
```
</details>



<details>
    <summary>
      <b>圆角图片(<a href="https://github.com/Alamofire/AlamofireImage">AlamofireImage</a>里面有切圆角的方法)</b>
    </summary>

```swift
extension UIImageView {

    func kt_addCorner(radius radius: CGFloat) {
        self.image = self.image?.kt_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}

extension UIImage {
    func kt_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())

        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return output
    }
}
```
</details>


<details>
  <summary>
      <b>通过字符串构建类</b>
  </summary>

```swift
extension String {
    func fromClassName() -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + self
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}

extension NSObject {
    class func fromClassName(className: String) -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}
```
</details>



<details>
<summary>
  <b>修改状态栏背景颜色</b>
</summary>

```swift
func setStatusBarBackgroundColor(color: UIColor) {
    guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
        return
    }
    statusBar.backgroundColor = color
}
swift3.0
    func setStatusBarBackgroundColor(color: UIColor) {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIView
        guard  let statusBar = statusBarWindow?.value(forKey: "statusBar") as? UIView else {
            return
        }
        statusBar.backgroundColor = color
    }
```
</details>



<details>
    <summary>
      <b>裁剪图片</b>
    </summary>

```swift
extension UIImage {
    func cutOutImageWithRect(rect: CGRect) -> UIImage {

        guard let subImageRef = CGImageCreateWithImageInRect(CGImage, rect) else {
            return self
        }
        let smallBounds = CGRect(x: 0, y: 0, width: CGImageGetWidth(subImageRef), height: CGImageGetHeight(subImageRef))
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, smallBounds, subImageRef)
        let smallImage = UIImage(CGImage: subImageRef)
        UIGraphicsEndImageContext()
        return smallImage
    }
}
```
</details>



<details>
    <summary>
      <b>UIButton响应区域太小</b>
    </summary>

```swift
extension UIButton {
    //处理button太小
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = bounds.size
        let widthToAdd = max(44 - buttonSize.width, 0)
        let heightToAdd = max(44 - buttonSize.height, 0)
        let largerFrame = bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        // perform hit test on larger frame
        return largerFrame.contains(point) ? self : nil
    }
}
```
</details>