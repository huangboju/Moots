# RPush
一个使用Swift编写的可运行在Mac OS的APNs测试工具，支持基于推送证书及Token认证两种鉴权方式。

# 软件截图
### 基于推送证书：
![证书授权软件截图](https://raw.githubusercontent.com/nevermore-imba/RPush/main/RPush/screenshots/certificate_based_screenshot.png)

### 基于Token认证：
![Token授权软件截图](https://raw.githubusercontent.com/nevermore-imba/RPush/main/RPush/screenshots/token_auth_based_screenshot.png)

# 使用方法
APNs支持两种认证方式，一种是Certificate-Based（证书认证），另一种是Token-Based（Token认证），您可选择其中一个鉴权方式测试推送功能是否正常。在MacOS运行`RPush`软件后：

> **Important**
> 
> The HTTP/2‑based Apple Push Notification service (APNs) provider API lets you take advantage of great features, 
> such as authentication with a JSON Web Token, improved error messaging, and per‑notification feedback. 
> If you still send push notifications with the legacy binary protocol, make sure to upgrade to the APNs provider API as soon as possible. 
> APNs will no longer support the legacy binary protocol after March 31, 2021.
> 
> [Learn about the APNs provider API.](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns?language=objc)

## 使用推送证书发送
- 选中鉴权方式为：`Push Certificate Based`
- 上传.cer推送证书
- 填写设备对应的 DeviceToken
- 填写或者选择默认提供Payload，可参考[Creating the Remote Notification Payload](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CreatingtheNotificationPayload.html#//apple_ref/doc/uid/TP40008194-CH10-SW1)
- 选择推送环境，默认为`开发环境`
- 点击`连接服务器`按钮，待日志提醒连接成功后就可以推送消息了
- 点击`推送消息`按钮，发送你想发送的推送消息
- 如果各项配置正确，你的iOS设备将会收到推送消息

## 使用Auth Key发送
- 选中鉴权方式为：`Token Authentication Based`
- 依次填写`Bundle ID`，`Key ID`, `Team ID`，可参考[Provider Authentication Tokens](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1)
- 上传.p8 key文件
- 填写设备对应的 DeviceToken
- 填写或者选择默认提供Payload，可参考[Creating the Remote Notification Payload](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CreatingtheNotificationPayload.html#//apple_ref/doc/uid/TP40008194-CH10-SW1)
- 选择推送环境，默认为`开发环境`
- 点击`推送消息`按钮，发送你想发送的推送消息
- 如果各项配置正确，你的iOS设备将会收到推送消息

# Bug
如果您在使用过程中发现bug，请邮箱联系我：renpanpan1990@163.com

# 鸣谢
`RPush`借(chao)鉴(xi)了以下产品，在此表示感谢作者开源（分享）😃😃😃。

- [SmartPush](https://github.com/shaojiankui/SmartPush)
- [appstoreconnect-swift-sdk](https://github.com/AvdLee/appstoreconnect-swift-sdk)
- [iOS远程推送--APNs详解](https://blog.csdn.net/weixin_37409570/article/details/96575120)
