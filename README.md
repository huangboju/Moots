# Moots
everything is the best arrangement

## 常用代码

<details>
<summary>
  **UICollectionView highlight**
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
  **泛型约束**
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
**银行金额验证**
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
  **多标志符字符串分割**
</summary>

```swift
let text = "abc,vfr.yyuu"
let set = CharacterSet(charactersIn: ",.")
print(text.components(separatedBy: set)) // ["abc", "vfr", "yyuu"]
```
</details>

<details>
<summary>
  **[匹配模式](http://swift.gg/2016/06/06/pattern-matching-4/)**
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
  **单行代码**
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
  **[GCD map函数](http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html)**
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
  **导航栏标题设置**
</summary>
    
```swift
// 需要tabBarItem的title与导航栏title不一致,如下设置navigationbar的titile
navigationItem.title = "示例"
注意: 直接 title = "示例" 在tabbar切换时tabBarItem的title会变成设置
```
</details>


<details>
<summary>
  **tabbar隐藏动画(同知乎)**
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
  **导航栏标返回图片**
</summary>
```swift
navigationBar.backIndicatorTransitionMaskImage = R.image.ic_nav_back()
navigationBar.backIndicatorImage = R.image.ic_nav_back()
```
</details>


<details>
<summary>
  **tableView分割线左边到头(_UITableViewCellSeparatorView)**
</summary>
```swift
//写在viewDidLoad
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
  **虚线**
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
  **部分圆角图片**
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
  **圆角图片([AlamofireImage](https://github.com/Alamofire/AlamofireImage)里面有切圆角的方法)**
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
  **通过字符串构建类**
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
  **修改状态栏背景颜色**
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
  **裁剪图片**
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
  **UIButton响应区域太小**
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


---------------------------------------------------------------------------------------------------------------------



## 笔记

[项目图片PDF](http://get.ftqq.com/1370.get)

* [https抓包](http://simcai.com/2016/01/31/ios-http-https%E6%8A%93%E5%8C%85%E6%95%99%E7%A8%8B/)


* IAP(内购)

 * [开始](https://gold.xitu.io/entry/57e90645da2f600060dde55e)

 * [参考](http://yimouleng.com/2015/12/17/ios-AppStore/)

 * [二次验证流程](http://openfibers.github.io/blog/2015/02/28/in-app-purchase-walk-through/)

* NSURLCache（缓存）（http://nshipster.cn/nsurlcache/）
```
Alamofire零行代码实现离线缓存http://stackoverflow.com/questions/27785693/alamofire-nsurlcache-is-not-working
```


* UIImage
```
UIImage(named: "imageName")// caching 
UIImage(contentsOfFile: "imageName")// no caching 
如果你要加载一个大图片而且是一次性使用，那么就没必要缓存这个图片，用contentsOfFile足矣，这样不会浪费内存来缓存它。
然而，在图片反复重用的情况下named是一个好得多的选择。
```


* UITableView
```
在UITableViewCell实例上添加子视图，有两种方式：[cell  addSubview:view]或[cell.contentView addSubview:view],一般情况下，两种方式没有区别。但是在多选编辑状态，直接添加到cell上的子视图将不会移动，而添加在contentView上的子视图会随着整体右移。所以，推荐使用[cell.contentView addSubview:view]方式添加子视图。

cell.backgroundColor = [UIColor grayColor];或cell.contentView.backgroudColor = [UIColor grayColor];一般情况下，两种方式效果一样。但是在多选编辑状态，直接设置cell的背景色可以保证左侧多选框部分的背景色与cell背景色一致，而设置contentView背景色，左侧多选框的背景色会是UITableView的背景色或UITableView父视图背景色，如果需要保证颜色一致，必须设置cell的背景色而不是cell.contentView的。
```


* [iOS事件响应链中Hit-Test View的应用](http://www.jianshu.com/p/d8512dff2b3e)


* UIButton setImage setBackgroundImage
```
首先setBackgroundImage，image会随着button的大小而改变，图片自动会拉伸来适应button的大小，这个时候任然可以设置button的title，image不会挡住title；相反的的setImage，图片不会进行拉伸，原比例的显示在button上，此时再设置title，title将无法显示，因此可以根据需求选中方法
```


* NSLayoutConstraint Leading left
```
NSLayoutAttributeLeading/NSLayoutAttributeTrailing的区别是left/right永远是指左右，
leading/trailing在某些从右至左习惯的地区（希伯来语等）会变成，leading是右边，trailing是左边
```


* Protocol
```
delegate一般得用weak标识符，这样当delegate指向的controller被销毁时，delegate会跟着被置为nil，可以有效防止这种问题。
若是使用assign标识的delegate，则注意在delegate指向的对象被销毁时，将delegate 置为nil。
也有不将delegate置为nil，没有问题的情况。如常见的tableView，其delegate和datasource，一般不会在其他controller中使用该tableView，所以不会有这种问题。
```


* Struct
```
实例方法中修改值类型
结构体和枚举是值类型。默认情况下，值类型的属性不可以在他的实例方法中修改
可以用mutating（变异行为）
注意：不能在结构体类型常量上调用变异方法，因为常量的属性不能被改变，即使想改变的是常量的变量属性也不行
```

* 杂
 * Self 表示引用当前实例的类型

 * AnyObject可以代表任何class类型的实例

 * Any可以表示任何类型。除了方法类型（function types）

 * 对于生命周期中会变为nil的实例使用弱引用。相反地，对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用。

---------------------------------------------------------------------------------------------------------------------



## 优化
* [UIKit性能调优实战讲解](http://www.jianshu.com/p/619cf14640f3)

* [UITableView](http://www.cocoachina.com/ios/20160115/15001.html)

* [AsyncDisplayKit教程](https://github.com/nixzhu/dev-blog/blob/master/2014-11-22-asyncdisplaykit-tutorial-achieving-60-fps-scrolling.md)

* [使用 ASDK 性能调优 - 提升 iOS 界面的渲染性能](https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/AsyncDisplayKit/%E6%8F%90%E5%8D%87%20iOS%20%E7%95%8C%E9%9D%A2%E7%9A%84%E6%B8%B2%E6%9F%93%E6%80%A7%E8%83%BD%20.md)



---------------------------------------------------------------------------------------------------------------------



## 常用配置

<details>
<summary>
  **Cocoapods([原理](https://objccn.io/issue-6-4/))**
</summary>
```ruby
卸载当前版本
sudo gem uninstall cocoapods

下载旧版本
sudo gem install cocoapods -v 0.25.0
```
</details> 


<details>
<summary>
  **修改Xcode自动生成的文件注释来导出API文档**
</summary>
```
http://www.jianshu.com/p/d0c7d9040c93
open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File\ Templates/Source
```
</details>


<details>
<summary>
  **删除多余模拟器**
</summary>
```
open /Library/Developer/CoreSimulator/Profiles/Runtimes
open /Users/你电脑的名字/Library/Developer/Xcode/iOS\ DeviceSupport
```
</details>


<details>
<summary>
  **修改swift文件**
</summary>
```
open /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/Swift\ File.xctemplate

open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File\ Templates/Source/Cocoa\ Touch\ Class.xctemplate/UIViewControllerSwift
```
</details>



---------------------------------------------------------------------------------------------------------------------



## 错误处理
1.The certificate used to sign "XXX" has either expired or has been revoked

* [解决方法](http://www.cnblogs.com/zzugyl/p/5555695.html)

* [然后](http://stackoverflow.com/questions/32730312/reason-no-suitable-image-found/32730393#32730393)



2.解决cocoapods diff: /../Podfile.lock: No such file or directory

* [解决方法1](http://www.jianshu.com/p/774d782a610b)

* [解决方法2](http://www.jianshu.com/p/4c3164fe552a)

## 其他
#### [markdown语法](http://www.jianshu.com/p/f3fd881548ad)
#### [public podspec](http://www.jianshu.com/p/98407f0c175b)
#### [private podspec](http://www.cocoachina.com/ios/20150228/11206.html)
#### [podfile 锁定版本](http://blog.csdn.net/openglnewbee/article/details/25032843)
#### [Swift runtime](http://www.infoq.com/cn/articles/dynamic-analysis-of-runtime-swift)
#### [Xcode快捷键](http://www.cocoachina.com/ios/20160708/16989.html)
#### [理解UIView的绘制](http://vizlabxt.github.io/blog/2012/10/22/UIView-Rendering/)
#### [切换淘宝源](https://ruby.taobao.org/)
#### [卸载cocoapods](http://www.jianshu.com/p/8b61b421dd76)



---------------------------------------------------------------------------------------------------------------------



#常用库
按字母排序，点击展开为该库的描述

### UI
<details>
<summary>
  **[swift-style-guide](https://github.com/raywenderlich/swift-style-guide)**
  **[SwiftFormat](https://github.com/nicklockwood/SwiftFormat)**
</summary>
Swift代码格式和自动格式化库
</details>


<details>
  <summary>**控件库(里面有你所需要的各种控件)**</summary>
    <ul>
    <li>[MaterialComponents](https://github.com/material-components/material-components-ios)(OC)</li>
    <li>[Material-Controls-For-iOS](https://github.com/fpt-software/Material-Controls-For-iOS)(OC)</li>
    <li>[QMUI_iOS](https://github.com/QMUI/QMUI_iOS)(OC)</li>
    <li>[FlatUIKit](https://github.com/Grouper/FlatUIKit)(OC)</li>
    <li>[Material](https://github.com/CosmicMind/Material)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**各种图表库（chart）**</summary>
    <ul>
    <li>[awesome-ios-chart](https://github.com/ameizi/awesome-ios-chart)</li>
    </ul>
</details>


<details>
  <summary>**颜色**</summary>
    <ul>
    <li>[DynamicColor](https://github.com/yannickl/DynamicColor)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**视频播放器**</summary>
    <ul>
    <li>[BMPlayer](https://github.com/BrikerMan/BMPlayer)(Swift)</li>
    <li>[MobilePlayer](https://github.com/mobileplayer/mobileplayer-ios)(Swift)</li>
    <li>[KRVideoPlayer](https://github.com/36Kr-Mobile/KRVideoPlayer)(OC)</li>
    </ul>
</details>


<details>
  <summary>**加载动画（loading）**</summary>
    <ul>
    <li>[FeSpinner](https://github.com/NghiaTranUIT/FeSpinner)(OC)</li>
    <li>https://github.com/poolqf/FillableLoaders(Swift)</li>
    <li>[NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**TableView展开cell**</summary>
    <ul>
    <li>[SKSTableView](https://github.com/sakkaras/SKSTableView)(OC)</li>
    <li>[ios-swift-collapsible-table-section-in-grouped-section](https://github.com/jeantimex/ios-swift-collapsible-table-section-in-grouped-section)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**日历**</summary>
    <ul>
      <li>[GLCalendarView](https://github.com/Glow-Inc/GLCalendarView)(OC)</li>
      <li>[JTCalendar](https://github.com/jonathantribouharet/JTCalendar)(OC)</li>
      <li>[FSCalendar](https://github.com/WenchaoD/FSCalendar)(Swift)</li>
      <li>[JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**日期处理**</summary>
    <ul>
      <li>[Timepiece](https://github.com/naoty/Timepiece)(Swift)</li>
      <li>[SwiftMoment](https://github.com/akosma/SwiftMoment)(Swift)</li>
      <li>[DateTools](https://github.com/MatthewYork/DateTools)(OC/Swift)</li>
      <li>[SwiftDate](https://github.com/malcommac/SwiftDate)</li>
    </ul>
</details>


<details>
  <summary>**约束**</summary>
    <ul>
      <li>[SnapKit](https://github.com/SnapKit/SnapKit)(Swift)</li>
      <li>[Relayout](https://github.com/stevestreza/Relayout)(Swift)</li>
      <li>[PureLayout](https://github.com/PureLayout/PureLayout)(OC)</li>
    </ul>
</details>


<details>
  <summary>**滚动导航栏**</summary>
    <ul>
    <li>[TLYShyNavBar](https://github.com/telly/TLYShyNavBar)(OC)</li>
    <li>[AMScrollingNavbar](https://github.com/andreamazz/AMScrollingNavbar)(Swift)</li>
    <li>[BLKFlexibleHeightBar](https://github.com/bryankeller/BLKFlexibleHeightBar)(OC)</li>
    <li>[BLKFlexibleHeightBar](https://github.com/bryankeller/BLKFlexibleHeightBar)(OC)</li>
    </ul>
</details>


<details>
  <summary>**类似微信支付弹出一个UIViewController**</summary>
    <ul>
    <li>[MZFormSheetController](https://github.com/layerhq/Atlas-iOS)(OC)</li>
    <li>[MZFormSheetPresentationController](https://github.com/m1entus)(OC)</li>
    <li>[STPopup.swift](https://github.com/huangboju/STPopup.swift)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**转场动画**</summary>
    <ul>
    <li>[TransitionTreasury](https://github.com/DianQK/TransitionTreasury)(Swift)</li>
    <li>[ADTransitionController](https://github.com/applidium/ADTransitionController)(OC)</li>
    <li>[VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary)(OC)</li>
    </ul>
</details>


<details>
  <summary>**陌陌卡片的喜欢和不喜欢**</summary>
    <ul>
    <li>[TinderSimpleSwipeCards](https://github.com/cwRichardKim/TinderSimpleSwipeCards)(OC)</li>
    <li>[MDCSwipeToChoose](https://github.com/modocache/MDCSwipeToChoose)(OC)</li>
    </ul>
</details>


<details>
  <summary>**气泡弹框**</summary>
    <ul>
    <li>[DXPopover](https://github.com/xiekw2010/DXPopover)(OC)</li>
    <li>[Popover](https://github.com/corin8823/Popover)(OC)</li>
    <li>[AMPopTip](https://github.com/andreamazz/AMPopTip)(OC)</li>
    </ul>
</details>


<details>
  <summary>**Swift的扩展**</summary>
    <ul>
    <li>[SwifterSwift](https://github.com/omaralbeik/SwifterSwift)(Swift)</li>
    <li>[EZSwiftExtensions](https://github.com/goktugyil/EZSwiftExtensions)(Swift)</li>
    </ul>
</details>


<details>
<summary>
  **[10Clock](https://github.com/joedaniels29/10Clock)(Swift)**
</summary>
这个控件是一个美丽的时间选择器大量启发的iOS 10“睡前”定时器。
</details>


<details>
<summary>
  **[AImage](https://github.com/wangjwchn/AImage)**
</summary>
Swift中的iOS的动画gif＆apng引擎。 针对多图像情况进行了优化。
</details>


<details>
  <summary>**Alert**</summary>
    <ul>
      <li>[CDAlertView](https://github.com/candostdagdeviren/CDAlertView)(Swift)</li>
      <li>[Presentr](https://github.com/IcaliaLabs/Presentr)(Swift)</li>
      <li>[SDCAlertView](https://github.com/sberrevoets/SDCAlertView)(Swift)</li>
    </ul>
</details>


<details>
<summary>
  **[AKPickerView](https://github.com/Akkyie/AKPickerView-Swift)(Swift)**
</summary>
一个简单但可自定义的水平选择器视图。
</details>


<details>
<summary>
  **[ASProgressPopUpView](https://github.com/alskipp/ASProgressPopUpView)(OC)**
</summary>
显示弹出式视图中完成百分比的进度视图
</details>


<details>
<summary>
  **[ALCameraViewController](https://github.com/AlexLittlejohn/ALCameraViewController)(Swift)**
</summary>
具有自定义图像选择器和图像裁剪的摄像机视图控制器。
</details>


<details>
<summary>
  **[BabyBluetooth](https://github.com/coolnameismy/BabyBluetooth)(OC)**
</summary>
蓝牙
</details>


<details>
<summary>
  **[BouncyPageViewController](https://github.com/BohdanOrlov/BouncyPageViewController)(Swift)**
</summary>
具有跳动效果的页面视图控制器
</details>


<details>
<summary>
  **[BubbleTransition](https://github.com/andreamazz/BubbleTransition)(Swift)**
</summary>
一种自定义转换，用于展开和消除具有膨胀的气泡效应的控制器。
</details>


<details>
<summary>
  **[CardAnimation](https://github.com/seedante/CardAnimation)(Swift)**
</summary>
卡片动画
</details>


<details>
<summary>
  **[CountdownLabel](https://github.com/suzuki-0000/CountdownLabel)(Swift)**
</summary>
简单倒计时UILabel与变形动画，以及一些有用的功能。
</details>


<details>
<summary>
  **[ConfettiView](https://github.com/OrRon/ConfettiView)(Swift)**
</summary>
ConfettiView可以在您的应用程序中创建一个炫酷的五彩纸屑视图
</details>


<details>
<summary>
  **[DateTimePicker](https://github.com/itsmeichigo/DateTimePicker)(Swift)**
</summary>
日期和时间选择组件
</details>


<details>
<summary>
  **[DGElasticPullToRefresh](https://github.com/gontovnik/DGElasticPullToRefresh)(Swift)**
</summary>
带皮筋效果的下拉刷新
</details>


<details>
<summary>
  **[DisplaySwitcher](https://github.com/Yalantis/DisplaySwitcher)(Swift)**
</summary>
两个集合视图布局之间的自定义转换
</details>


<details>
<summary>
  **[DOFavoriteButton](https://github.com/okmr-d/DOFavoriteButton)(Swift)**
</summary>
点赞按钮
</details>


<details>
<summary>
  **[DKImagePickerController](https://github.com/zhangao0086/DKImagePickerController)(Swift)**
</summary>
图片选择器
</details>


<details>
<summary>
  **[DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)(OC)**
</summary>
用于在视图没有要显示的内容时显示空数据集的UITableView / UICollectionView超类类别
</details>


<details>
<summary>
  **[ElasticTransition](https://github.com/lkzhao/ElasticTransition)(Swift)**
</summary>
模拟弹性拖动的UIKit自定义转场。 
</details>


<details>
<summary>
  **[ESTMusicIndicator](https://github.com/Aufree/ESTMusicIndicator)(Swift)**
</summary>
音乐播放指示器
</details>


<details>
<summary>
  **[FaceAware](https://github.com/BeauNouvelle/FaceAware)(Swift)**
</summary>
头像裁剪，使人脸居中
</details>


<details>
<summary>
  **[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)(OC)**
</summary>
全屏返回
</details>


<details>
<summary>
  **[FloatLabelFields](https://github.com/FahimF/FloatLabelFields)(Swift)**
</summary>
placeholder会上浮的field
</details>


<details>
<summary>
  **[FontAwesomeKit](https://github.com/PrideChung/FontAwesomeKit)(OC)**
</summary>
各种icon 
</details>


<details>
<summary>
  **[ForceBlur](https://github.com/Yalantis/ForceBlur)(Swift)**
</summary>
ForceBlur动画iOS消息应用程序
</details>


<details>
<summary>
  **[GPUImage2](https://github.com/BradLarson/GPUImage2)**
</summary>
GPUImage 2是一个BSD授权的Swift框架，用于GPU加速的视频和图像处理。
</details>


<details>
<summary>
  **[GSMessages](https://github.com/wxxsw/GSMessages)(Swift)**
</summary>
navigationbar下面出来的提示框
</details>


<details>
<summary>
  **[HamburgerButton](https://github.com/fastred/HamburgerButton)(Swift)**
</summary>
有转场动画的按钮
</details>


<details>
<summary>
  **[HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider)(Swift)**
</summary>
iOS应用程序的自定义可重复使用的圆形滑块控件。
</details>


<details>
<summary>
  **[iOS-Core-Animation-Advanced-Techniques](https://github.com/kevinzhow/iOS-Core-Animation-Advanced-Techniques)**
</summary>
CAlayer子类及动画的介绍
</details>


<details>
<summary>
  **[IGListKit](https://github.com/Instagram/IGListKit)(OC)**
</summary>
一个数据驱动的UICollectionView框架，用于构建快速灵活的列表
</details>


<details>
<summary>
  **[JDStatusBarNotification](https://github.com/calimarkus/JDStatusBarNotification)(OC)**
</summary>
状态栏通知
</details>


<details>
<summary>
  **[Jelly](https://github.com/SebastianBoldt/Jelly)(Swift)**
</summary>
Jelly在iOS中提供了自定义视图控制器转换，只需几行代码
</details>


<details>
<summary>
  **[JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController)(OC)**
</summary>
一个优雅的消息UI库的iOS
</details>


<details>
<summary>
  **[JVFloatLabeledTextField](https://github.com/Grouper/FlatUIKit)(OC)**
</summary>
上浮Field
</details>


<details>
<summary>
  **[JZNavigationExtension](https://github.com/JazysYu/JZNavigationExtension)(OC)**
</summary>
网页导航栏过度效果
</details>


<details>
<summary>
  **[KMCGeigerCounter](https://github.com/kconner/KMCGeigerCounter)(OC)**
</summary>
FPS显示
</details>


<details>
<summary>
  **[KMNavigationBarTransition](https://github.com/MoZhouqi/KMNavigationBarTransition)(OC)**
</summary>
美团首页，微信红包页面NavigationBar过度处理
</details>


<details>
<summary>
  **[KVOController](https://github.com/coolnameismy/BabyBluetooth)(OC)**
</summary>
简单，现代，线程安全的键值观察iOS和OS X.
</details>


<details>
<summary>
  **[KYDrawerController](https://github.com/ykyouhei/KYDrawerController)(Swift)**
</summary>
侧滑
</details>


<details>
<summary>
  **[LTHRadioButton](https://github.com/rolandleth/LTHRadioButton)(Swift)**
</summary>
一个有漂亮动画的单选按钮
</details>


<details>
<summary>
  **[LiquidFloatingActionButton](https://github.com/yoavlt/LiquidFloatingActionButton)(Swift)**
</summary>
浮动按钮
</details>


<details>
<summary>
  **[MLEmojiLabel](https://github.com/molon/MLEmojiLabel)(OC)**
</summary>
自动识别网址、号码、邮箱、@、#话题#和表情的label。 可以自定义自己的表情识别正则，和对应的表情图像。(默认是识别微信的表情符号)
</details>


<details>
<summary>
  **[PageControls](https://github.com/popwarsweet/PageControls)**
</summary>
各种PageControl
</details>


<details>
<summary>
  **[Panoramic](https://github.com/iSame7/Panoramic)(Swift)**
</summary>
重力感应控制图片
</details>


<details>
<summary>
  **[PermissionScope](https://github.com/nickoneill/PermissionScope)(Swift)**
</summary>
各种权限设置
</details>


<details>
<summary>
  **[Persei](https://github.com/Yalantis/Persei)(Swift)**
</summary>
用Swift编写的UITableView / UICollectionView / UIScrollView的动画顶层菜单
</details>


<details>
<summary>
  **[M13ProgressSuite](https://github.com/Marxon13/M13ProgressSuite)(OC)**
</summary>
进度指示器
</details>


<details>
<summary>
  **[MediumScrollFullScreen](https://github.com/pixyzehn/MediumScrollFullScreen)(Swift)**
</summary>
滚动隐藏NavigationBar和ToolBar
</details>


<details>
<summary>
  **[MotionBlur](https://github.com/fastred/MotionBlur)**
</summary>
MotionBlur允许您为iOS动画添加运动模糊效果。
</details>


<details>
<summary>
  **[MXScrollView](https://github.com/cwxatlm/MXScrollView)(OC)**
</summary>
一款易用的可拉伸的自动循环滚动视图 集成简单易懂 自定义性强
</details>


<details>
<summary>
  **[NextGrowingTextView](https://github.com/muukii/NextGrowingTextView)(Swift)**
</summary>
自适应高度的TextView
</details>


<details>
<summary>
  **[PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit)(Swift)**
</summary>
用于解析，格式化和验证国际电话号码的Swift框架。 灵感来自Google的libphonenumber。
</details>


<details>
<summary>
  **[PySwiftyRegex](https://github.com/cezheng/PySwiftyRegex)(Swift)**
</summary>
轻松地以一种Pythonic方式处理Swift中的Regex
</details>


<details>
<summary>
  **[Reactions](https://github.com/yannickl/Reactions)(Swift)**
</summary>
可定制的Facebook反应控件
</details>


<details>
<summary>
  **[RHPreviewCell](https://github.com/robertherdzik/RHPreviewCell)(Swift)**
</summary>
长按显示隐藏图片
</details>


<details>
<summary>
  **[Ruler](https://github.com/nixzhu/Ruler)(Swift)**
</summary>
尺寸很重要，你需要一把尺子。
</details>


<details>
<summary>
  **[RazzleDazzle](https://github.com/IFTTT/RazzleDazzle)(Swift)**
</summary>
一个简单的基于关键帧的动画框架的iOS，用Swift编写。 完美的滚动应用程序介绍。
</details>


<details>
<summary>
  **[ReadabilityKit](https://github.com/exyte/ReadabilityKit)**
</summary>
Swift中的新闻，文章和全文的预览提取器
</details>


<details>
<summary>
  **[SFFocusViewLayout](https://github.com/fdzsergio/SFFocusViewLayout)(Swift)**
</summary>
UICollectionViewLayout炫酷的布局
</details>


<details>
<summary>
  **[Siren](https://github.com/ArtSabintsev/Siren)(Swift)**
</summary>
当有新版本的应用程式可用时通知使用者，并提示他们升级
</details>


<details>
<summary>
  **[SKPhotoBrowser](https://github.com/suzuki-0000/SKPhotoBrowser)(Swift)**
</summary>
照片浏览器
</details>


<details>
<summary>
  **[Sonar](https://github.com/thefuntasty/Sonar)(Swift)**
</summary>
雷达扫码视图
</details>


<details>
<summary>
  **[StarWars.iOS](https://github.com/Yalantis/StarWars.iOS)(Swift)**
</summary>
这个组件实现过渡动画，将视图控制器破碎成小块
</details>


<details>
<summary>
  **[StatefulViewController](https://github.com/aschuch/StatefulViewController)(Swift)**
</summary>
基于内容，加载，错误或空状态的占位符视图
</details>

<details>
<summary>
  **[SwiftIconFont](https://github.com/0x73/SwiftIconFont)(Swift)**
</summary>
像设置字体一样设置图片的大小
</details>


<details>
<summary>
  **[SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages)**
</summary>
一个非常灵活的消息栏为iOS写的Swift。
</details>


<details>
<summary>
  **[SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults)**
</summary>
NSUserDefaults的现代Swift API
</details>


<details>
<summary>
  **[SwipeTableView](https://github.com/Roylee-ML/SwipeTableView)(OC)**
</summary>
类似半糖、美丽说主页与QQ音乐歌曲列表布局效果，实现不同菜单的左右滑动切换，同时支持类似tableview的顶部工具栏悬停（既可以左右滑动，又可以上下滑动）。兼容下拉刷新，自定义 collectionview实现自适应 contentSize 还可实现瀑布流功能
</details>


<details>
<summary>
  **[TableFlip](https://github.com/mergesort/TableFlip)(Swift)**
</summary>
一个更简单的方法来做酷UITableView动画！
</details>


<details>
<summary>
  **[TDBadgedCell](https://github.com/tmdvs/TDBadgedCell)(Swift)**
</summary>
带小红点的cell
</details>


<details>
<summary>
  **[TextFieldEffects](https://github.com/raulriera/TextFieldEffects)(Swift)**
</summary>
自定义UITextFields效果
</details>


<details>
<summary>
  **[TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding)(OC)**
</summary>
键盘弹出事件处理
</details>


<details>
<summary>
  **[TimelineTableViewCell](https://github.com/kf99916/TimelineTableViewCell)(Swift)**
</summary>
时间轴
</details>


<details>
<summary>
  **[TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)(OC)**
</summary>
带连接可点击的label
</details>


<details>
<summary>
  **[UploadImage](https://github.com/MillmanY/UploadImage)(Swift)**
</summary>
UIImageView的图片上传指示
</details>


<details>
<summary>
  **[Whisper](https://github.com/hyperoslo/Whisper)(Swift)**
</summary>
Whisper是一个组件，它将使显示消息和应用程序内通知的任务变得简单。 它里面有三个不同的视图
</details>


<details>
<summary>
  **[XFAssistiveTouch](https://github.com/xiaofei86/XFAssistiveTouch)(Swift)**
</summary>
仿系统的小白点
</details>


<details>
<summary>
  **[XLActionController](https://github.com/xmartlabs/XLActionController)(Swift)**
</summary>
完全可定制和可扩展的action sheet controller
</details>


<details>
<summary>
  **[ZFRippleButton](https://github.com/zoonooz/ZFRippleButton)(Swift)**
</summary>
自定义UIButton效果灵感来自Google Material Design
</details>



---------------------------------------------------------------------------------------------------------------------
<details>
  <summary>**动画**</summary>

<details>
<summary>
  **[Hero](https://github.com/lkzhao/Hero)(Swift)**
</summary>
动画库
</details>

<details>
<summary>
  **[Spring](https://github.com/MengTo/Spring)**
</summary>
在Swift中简化iOS动画的库。
</details>

</details>



---------------------------------------------------------------------------------------------------------------------
### 其他

<details>
  <summary>**Timer(定时器)**</summary>
    <ul>
    <li>[Each](https://github.com/IcaliaLabs/Presentr)(Swift)</li>
    <li>[SwiftTimer](https://github.com/100mango/SwiftTimer)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**引导页**</summary>
    <ul>
    <li>[EAIntroView](https://github.com/ealeksandrov/EAIntroView)(OC)</li>
    <li>[BWWalkthrough](https://github.com/ariok/BWWalkthrough)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**OCR（图像识别）**</summary>
    <ul>
      <li>[SwiftOCR](https://github.com/garnele007/SwiftOCR)(Swift)</li>
      <li>[OCR](https://github.com/iosWellLin/OCR)(OC)</li>
    </ul>
</details>


<details>
  <summary>**界面跳转路由**</summary>
    <ul>
      <li>[DCURLRouter](https://github.com/DarielChen/DCURLRouter)(OC)</li>
      <li>[FNUrlRoute](https://github.com/Fnoz/FNUrlRoute)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**Swift代码生成器**</summary>
    <ul>
      <li>[SwiftGen](https://github.com/johnil/VVeboTableViewDemo)(Swift)</li>
      <li>[R.swift](https://github.com/mac-cain13/R.swift)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**SVG**</summary>
    <ul>
      <li>[Snowflake](https://github.com/onmyway133/Snowflake)(Swift)</li>
      <li>[Macaw](https://github.com/exyte/Macaw)(Swift)</li>
      <li>[SwiftSVG](https://github.com/mchoe/SwiftSVG)(Swift)</li>
    </ul>
</details>


<details>
<summary>
  **[Argo](https://github.com/thoughtbot/Argo)(Swift)**
</summary>
Swift的JSON转换
</details>


<details>
<summary>
  **[Async](https://github.com/duemunk/Async)(Swift)**
</summary>
对GCD的封装
</details>


<details>
<summary>
  **[BluetoothKit](https://github.com/rhummelmose/BluetoothKit)(Swift)**
</summary>
使用BLE在iOS / OSX设备之间轻松通信
</details>


<details>
<summary>
  **[BeeHive](https://github.com/alibaba/BeeHive)(OC)**
</summary>
阿里开源的解耦库
</details>


<details>
<summary>
  **[DeepLinkKit](https://github.com/button/DeepLinkKit)(OC)**
</summary>
精湛的路由匹配，基于块的方式来处理你的深层链接。
</details>


<details>
<summary>
  **[Design-Patterns-In-Swift](https://github.com/ochococo/Design-Patterns-In-Swift)(Swift)**
</summary>
设计模式
</details>


<details>
<summary>
  **[FBMemoryProfiler](https://github.com/facebook/FBMemoryProfiler)(OC)**
</summary>
facebook开源的内存分析器
</details>


<details>
<summary>
  **[FileBrowser](https://github.com/marmelroy/FileBrowser)(Swift)**
</summary>
文件浏览器
</details>


<details>
<summary>
  **[Google VR](https://github.com/googlevr/gvr-ios-sdk)**
</summary>
谷歌VR
</details>


<details>
<summary>
  **[Kakapo](https://github.com/devlucky/Kakapo)(Swift)**
</summary>
在Swift中动态模拟服务器行为和响应
</details>


<details>
<summary>
  **[LayerPlayer](https://github.com/singro/v2ex)**
</summary>
探索Apple的Core Animation API的功能
</details>


<details>
<summary>
  **[Live](https://github.com/ltebean/Live)(Swift)**
</summary>
直播
</details>


<details>
<summary>
  **[MLeaksFinder](https://github.com/Zepo/MLeaksFinder)(Swift)**
</summary>
在开发时查找iOS应用中的内存泄漏。
</details>


<details>
<summary>
  **[NetworkEye](https://github.com/coderyi/NetworkEye)(OC)**
</summary>
一个iOS网络调试库，它可以监控应用程序中的HTTP请求，并显示与请求相关的信息
</details>


<details>
<summary>
  **[Nuke](https://github.com/kean/Nuke)(Swift)**
</summary>
强大的图像加载和缓存框架
</details>


<details>
<summary>
  **[Password-keyboard](https://github.com/liuchunlao/Password-keyboard)(OC)**
</summary>
动态密码键盘
</details>


<details>
<summary>
  **[Peek](https://github.com/shaps80/Peek)(Swift)**
</summary>
Peek是一个开源库，允许您根据用户界面的规范指南轻松检查您的应用程序。 Peek可以被工程师，设计师和测试人员使用，允许开发人员花更多的时间在代码和更少的时间检查字体，颜色和布局是像素完美。
</details>


<details>
<summary>
  **[PNChart-Swift](https://github.com/kevinzhow/PNChart-Swift)**
</summary>
一个简单而美丽的图表库用
</details>


<details>
<summary>
  **[SQLite.swift](https://github.com/stars)(Swift)**
</summary>
数据库
</details>


<details>
<summary>
  **[socket.io-client-swift](https://github.com/socketio/socket.io-client-swift)(Swift)**
</summary>
socket连接
</details>


<details>
<summary>
  **[SwiftyAttributes](https://github.com/eddiekaiger/SwiftyAttributes)(Swift)**
</summary>
富文本字符串处理
</details>


<details>
<summary>
  **[SwiftPlate](https://github.com/mergesort/TableFlip)(Swift)**
</summary>
用命令行轻松生成跨平台Swift框架项目
</details>


<details>
<summary>
  **[XLPagerTabStrip](https://github.com/xmartlabs/XLPagerTabStrip)**
</summary>
网易那种侧滑页面
</details>


<details>
<summary>
  **[ZLSwipeableViewSwift](https://github.com/zhxnlai/ZLSwipeableViewSwift)(Swift)**
</summary>
一个简单的视图构建卡像界面灵感来自Tinder和Potluck。
</details>



---------------------------------------------------------------------------------------------------------------------
### 框架

<details>
<summary>
  **[AsyncDisplayKit](https://github.com/facebook/AsyncDisplayKit)**
</summary>
facebook开源的界面优化框架
</details>


<details>
  <summary>**及时通讯框架**</summary>
    <ul>
    <li>[Atlas-iOS](https://github.com/layerhq/Atlas-iOS)(OC)</li>
    <li>[NMessenger](https://github.com/eBay/NMessenger)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**测试框架**</summary>
    <ul>
    <li>[Quick](https://github.com/Quick/Quick)(Swift)</li>
      <li>[SwiftCheck](https://github.com/typelift/SwiftCheck)(Swift)</li>
    </ul>
</details>


<details>
  <summary>**跨平台框架**</summary>
    <ul>
      <li>[weex](https://github.com/alibaba/weex)</li>
      <li>[react-native](https://github.com/facebook/react-native)(Swift)</li>
    </ul>
</details>


<details>
<summary>
  **[katana-swift](https://github.com/BendingSpoons/katana-swift)(Swift)**
</summary>
跟ReSwift类似
</details>


<details>
<summary>
  **[ReSwift](https://github.com/ReSwift/ReSwift)**
</summary>
似乎有点牛B，待仔细研究
</details>

<details>
<summary>
  **[RxSwift](https://github.com/ReactiveX/RxSwift)(Swift)**
</summary>
响应式编程
</details>


<details>
<summary>
  **[StyleKit](https://github.com/146BC/StyleKit)(Swift)**
</summary>
一个用Swift编写的强大的，易于使用的样式框架
</details>



---------------------------------------------------------------------------------------------------------------------
### APP源码**

<details>
<summary>
  **[ifanr](https://github.com/iCodeForever/ifanr)**
</summary>
高仿 爱范儿
</details>


<details>
<summary>
  **[kickstarter](https://github.com/kickstarter/ios-oss)(Swift)**
</summary>
一个众筹平台的源码
</details>


<details>
<summary>
  **[RaceMe](https://github.com/enochng1/RaceMe)(Swift)**
</summary>
关于跑步的
</details>


<details>
<summary>
  **[SelectionOfZhihu](https://github.com/sheepy1/SelectionOfZhihu)(Swift)**
</summary>
知乎
</details>


<details>
<summary>
  **[v2ex](https://github.com/singro/v2ex)**
</summary>
v2ex客户端
</details>


<details>
<summary>
  **[Yep](https://github.com/CatchChat/Yep)**
</summary>
一个社交软件，遇见天才
</details>




------------------------------------------------------------------------------------------------
### Demo
  
<details>
<summary>
  **[VVeboTableViewDemo](https://github.com/johnil/VVeboTableViewDemo)(OC)**
</summary>
微博优化demo
</details>


<details>
<summary>
  **[SmileWeather](https://github.com/liu044100/SmileWeather)(OC)**
</summary>
天气Demo
</details>


<details>
<summary>
  **[youtube-iOS](https://github.com/aslanyanhaik/youtube-iOS)(Swift)**
</summary>
youtube
</details>


<details>
<summary>
  **[MaskLayerDemo](https://github.com/huangboju?page=6&tab=stars)(Swift)**
</summary>
各种遮罩使用
</details>


<details>
<summary>
  **[nuomi](https://github.com/lookingstars/nuomi)(OC)**
</summary>
仿糯米
</details>
