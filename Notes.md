# 笔记

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