# Moots
everything is the best arrangement

## 1、常用代码

#### 单行代码
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

#### [GCD map函数](http://moreindirection.blogspot.it/2015/07/gcd-and-parallel-collections-in-swift.html)
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


#### 导航栏标题设置
```swift
// 需要tabBarItem的title与导航栏title不一致,如下设置navigationbar的titile
navigationItem.title = "示例"
注意: 直接 title = "示例" 在tabbar切换时tabBarItem的title会变成设置
```

#### tabbar隐藏动画
```
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

#### 导航栏标返回图片
```swift
navigationBar.backIndicatorTransitionMaskImage = R.image.ic_nav_back()
navigationBar.backIndicatorImage = R.image.ic_nav_back()
```

#### tableView分割线左边到头(_UITableViewCellSeparatorView)
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

#### 虚线
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

#### 部分圆角图片
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

#### 圆角图片
```
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

#### 通过字符串构建类
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

#### 修改状态栏背景颜色
```swift
func setStatusBarBackgroundColor(color: UIColor) {
    guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
        return
    }
    statusBar.backgroundColor = color
}
```

#### 裁剪图片
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

#### 响应区域太小
```swift
extension UIButton {
    //处理button太小
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.hidden || !self.userInteractionEnabled || self.alpha < 0.01 { return nil }

        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = bounds.size
        let widthToAdd = max(44 - buttonSize.width, 0)
        let heightToAdd = max(44 - buttonSize.height, 0)
        let method = CGRect.insetBy(bounds)
        let largerFrame = method(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        // perform hit test on larger frame
        return largerFrame.contains(point) ? self : nil
    }
}
```

## 2、笔记
##### Class
###### 1. UITableView
>在UITableViewCell实例上添加子视图，有两种方式：[cell  addSubview:view]或[cell.contentView addSubview:view],一般情况下，两种方式没有区别。但是在多选编辑状态，直接添加到cell上的子视图将不会移动，而添加在contentView上的子视图会随着整体右移。所以，推荐使用[cell.contentView addSubview:view]方式添加子视图。

>cell.backgroundColor = [UIColor grayColor];或cell.contentView.backgroudColor = [UIColor grayColor];一般情况下，两种方式效果一样。但是在多选编辑状态，直接设置cell的背景色可以保证左侧多选框部分的背景色与cell背景色一致，而设置contentView背景色，左侧多选框的背景色会是UITableView的背景色或UITableView父视图背景色，如果需要保证颜色一致，必须设置cell的背景色而不是cell.contentView的。

###### 2. [iOS事件响应链中Hit-Test View的应用](http://www.jianshu.com/p/d8512dff2b3e)

##### Protocol
>delegate一般得用weak标识符，这样当delegate指向的controller被销毁时，delegate会跟着被置为nil，可以有效防止这种问题。
若是使用assign标识的delegate，则注意在delegate指向的对象被销毁时，将delegate 置为nil。
也有不将delegate置为nil，没有问题的情况。如常见的tableView，其delegate和datasource，一般不会在其他controller中使用该tableView，所以不会有这种问题。


##### Struct
>实例方法中修改值类型
结构体和枚举是值类型。默认情况下，值类型的属性不可以在他的实例方法中修改
可以用mutating（变异行为）
注意：不能在结构体类型常量上调用变异方法，因为常量的属性不能被改变，即使想改变的是常量的变量属性也不行

##### 优化
>[UIKit性能调优实战讲解](http://www.jianshu.com/p/619cf14640f3)

>[UITableView](http://www.cocoachina.com/ios/20160115/15001.html)

>[AsyncDisplayKit教程](https://github.com/nixzhu/dev-blog/blob/master/2014-11-22-asyncdisplaykit-tutorial-achieving-60-fps-scrolling.md)

>[使用 ASDK 性能调优 - 提升 iOS 界面的渲染性能](https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/AsyncDisplayKit/%E6%8F%90%E5%8D%87%20iOS%20%E7%95%8C%E9%9D%A2%E7%9A%84%E6%B8%B2%E6%9F%93%E6%80%A7%E8%83%BD%20.md)

##### 杂
> Self 表示引用当前实例的类型

>AnyObject可以代表任何class类型的实例

>Any可以表示任何类型。除了方法类型（function types）

>对于生命周期中会变为nil的实例使用弱引用。相反地，对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用。

## 3、常用配置

#### cocoapods
```ruby
卸载当前版本
sudo gem uninstall cocoapods

下载旧版本
sudo gem install cocoapods -v 0.25.0
```

#### 修改Xcode自动生成的文件注释来导出API文档
```
http://www.jianshu.com/p/d0c7d9040c93
open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File\ Templates/Source
```

#### 删除多余模拟器
```
open /Library/Developer/CoreSimulator/Profiles/Runtimes
```

#### 修改swift文件
```
open /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/Swift\ File.xctemplate
```

## 4、错误处理
> The certificate used to sign "XXX" has either expired or has been revoked

>[解决方法](http://www.cnblogs.com/zzugyl/p/5555695.html)

> [然后](http://stackoverflow.com/questions/32730312/reason-no-suitable-image-found/32730393#32730393)

## 5、其他
#### [markdown语法](http://www.jianshu.com/p/f3fd881548ad)
#### [public podspec](http://www.jianshu.com/p/98407f0c175b)
#### [private podspec](http://www.cocoachina.com/ios/20150228/11206.html)
#### [podfile 锁定版本](http://blog.csdn.net/openglnewbee/article/details/25032843)
#### [Swift runtime](http://www.infoq.com/cn/articles/dynamic-analysis-of-runtime-swift)
#### [Xcode快捷键](http://www.cocoachina.com/ios/20160708/16989.html)

# UI
|             库名             |             描述             |           语言             |
|:---------------------------:|:---------------------------:|:---------------------------:|
|      [FontAwesomeKit][]     |           各种icon           |            OC              |
|       [GSMessages][]        | navigationbar下面出来的提示框  |           Swift             |
|       [MobilePlayer][]      |            播放器            |           Swift             |


# 数据库
|             库名             |             描述             |           语言             |
|:---------------------------:|:---------------------------:|:---------------------------:|
|       [SQLite.swift][]      |            数据库            |           Swift             |

[FontAwesomeKit]: https://github.com/PrideChung/FontAwesomeKit
[GSMessages]: https://github.com/wxxsw/GSMessages
[MobilePlayer]: https://github.com/mobileplayer/mobileplayer-ios
[SQLite.swift]: https://github.com/stars
