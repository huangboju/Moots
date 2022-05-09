# Moots

## 常用代码

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


---------------------------------------------------------------------------------------------------------------------



## 笔记

[项目图片PDF](http://get.ftqq.com/1370.get)

* [https抓包](http://simcai.com/2016/01/31/ios-http-https%E6%8A%93%E5%8C%85%E6%95%99%E7%A8%8B/)


* IAP(内购)

   * [开始](https://gold.xitu.io/entry/57e90645da2f600060dde55e)

   * [参考](http://yimouleng.com/2015/12/17/ios-AppStore/)

   * [二次验证流程](http://openfibers.github.io/blog/2015/02/28/in-app-purchase-walk-through/)

* NSURLCache（[缓存](http://nshipster.cn/nsurlcache/))

    * [Alamofire零行代码实现离线缓存](http://stackoverflow.com/questions/27785693/alamofire-nsurlcache-is-not-working)



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
  <b><a href="http://benjaminwhx.com/2016/04/03/%E5%A6%82%E4%BD%95%E5%AE%9A%E5%88%B6%E4%BD%A0%E7%9A%84Mac%E7%BB%88%E7%AB%AF%E6%8F%90%E7%A4%BA%E5%90%8D/">自定义终端名称</a></b>
</summary>

</details>

<details>
<summary>
  <b>Cocoapods<a href="https://objccn.io/issue-6-4/">原理</a></b>
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
  <b>
    <a href="http://www.jianshu.com/p/d0c7d9040c93">
      修改Xcode自动生成的文件注释来导出API文档
    </a>
  </b>
</summary>

```
open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File\ Templates/Source
```
</details>


<details>
  <summary><b>LLDB（断点调试）</b></summary>
    <ul>
      <li><a href="http://www.jianshu.com/p/8e9fc9a8ab78">iOS开发断点调试高级技巧</a></li>
      <li><a href="https://objccn.io/issue-19-2/">与调试器共舞 - LLDB 的华尔兹</a></li>
      <li>http://www.imlifengfeng.com/blog/?p=622</li>
      <li><a href="https://mp.weixin.qq.com/s?__biz=MzUxMzcxMzE5Ng==&mid=2247488196&amp;idx=1&amp;sn=5b8bb5fe650ddbdff803c7a50f7dbfaf&source=41#wechat_redirect">你知道怎么用LLDB调试Swift吗？</a></li>
    </ul>
</details>


<details>
    <summary>
      <b>删除多余模拟器</b>
    </summary>

```
open /Library/Developer/CoreSimulator/Profiles/Runtimes
open /Users/你电脑的名字/Library/Developer/Xcode/iOS\ DeviceSupport
```
</details>


<details>
    <summary>
       <b>修改swift文件</b>
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



# [常用库](https://github.com/huangboju/Moots/blob/master/LIBRARY.md)
按字母排序，点击展开为该库的描述
