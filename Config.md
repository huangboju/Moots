# 常用配置

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