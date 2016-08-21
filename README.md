# Moots
everything is the best arrangement

### 常用代码

#### tableView分割线左边到头
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

### 笔记

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
