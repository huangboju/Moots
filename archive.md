# Automator + fastlane 快速打包


### 一、[fastlane](https://github.com/fastlane/fastlane)

#### 安装（选一种即可）
* Homebrew: `brew cask install fastlane`
* Rubygems: `sudo gem install fastlane -NV`

#### 使用
* [Getting started with fastlane for iOS](https://docs.fastlane.tools/getting-started/ios/setup/)
* [Getting started with fastlane for Android](https://docs.fastlane.tools/getting-started/android/setup/)


### 二、接入[蒲公英](https://www.pgyer.com/doc/view/fastlane)
* `cd 你的项目`
* `fastlane init` 这里会叫你输入苹果账号，之后输入App ID，`control+z`停掉即可
* 在**fastlane**文件里面会有个**Fastfile**的文件,如果没有可以自己建一个
* 在**Fastfile**里面加入以下内容
```
lane :beta do
  gym(scheme: "你要打包的scheme",
      export_method: "development")
  pgyer(api_key: "你的蒲公英api_key", user_key: "你的蒲公英user_key")
end
```
* 在终端中之行`fastlane add_plugin pgyer`(要cd到你的项目)

### 三、Automator
* 开启听写命令
  * **系统偏好设置**->**键盘**->**听写**。
  * 开启**听写**，然后选中**使用优化听写**。此时，您可以获得一个命令列表，并可以选择要使用的命令
* 制作Automator
  * 打开**Automator**->**新建文稿**->**听写命令**
![屏幕快照 2017-07-29 下午3.39.49.png](http://upload-images.jianshu.io/upload_images/2567136-c1d1573afedd6489.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  ```
  on run {input, parameters}
    tell application "Terminal"
      activate
      do script "cd  '这里是你要打包的项目路径（control+option+c复制项目路径，单引号需要保留）'; fastlane beta"
    end tell
    return input
  end run
  ```

![屏幕快照 2017-07-29 下午3.47.03.png](http://upload-images.jianshu.io/upload_images/2567136-f8b664a1efae1475.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  
cmd+s（保存），保存名字可以任意取

### 三、启用命令

  * **系统偏好设置**->**辅助功能**->**听写**
 * 点击**听写命令**->将你之前创建的命令勾上



![屏幕快照 2017-07-29 下午3.59.54.png](http://upload-images.jianshu.io/upload_images/2567136-314330f6824c3402.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* **双击Fn**（打开听写命令后，双击Fn可以关闭听写命令）就可以呼出听写应用,说出你的命令就会之行打包了
