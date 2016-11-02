# ADController
炫酷的广告弹框，总有一款适合你!

###用法
```swift
let controller = ADController(type: TransitionType.bottomToTop)
        let flag = controller.isCanShowing(date: adDate!)
        controller.images = yourImages
        controller.selectedHandel = {
            print($0)
        }
        if flag {
            present(controller, animated: true) {}
        }
```

###效果1
![Alt text](https://github.com/huangboju/ADController/blob/master/ADController/Resources/bottomToTop.gif)
###效果2
![Alt text](https://github.com/huangboju/ADController/blob/master/ADController/Resources/overlayHorizontal.gif)
