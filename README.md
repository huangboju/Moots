# Moots

## [常用代码](../Snippets.md)


---------------------------------------------------------------------------------------------------------------------

## [笔记](../Notes.md)


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
