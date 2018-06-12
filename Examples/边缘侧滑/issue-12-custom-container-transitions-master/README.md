# README

This is the code repository accompanying the [Custom Container View Controller Transitions](http://www.objc.io/issue-12/custom-container-view-controller-transitions.html) article, [issue #12](http://www.objc.io/issue-12) of the [objc.io publication](http://www.objc.io).

In three steps a custom container view controller is built with support for custom child view controller transition animations:

1. The Basics: implementing `ChildViewController` with no transition animation ([stage-1](https://github.com/osteslag/custom-container-transitions/tree/stage-1))

2. Animating the Transition: using an existing animation controller ([stage-2](https://github.com/osteslag/custom-container-transitions/tree/stage-2), [diff](https://github.com/osteslag/custom-container-transitions/compare/stage-1...stage-2))

3. Shrink-Wrapping: implement delegate pattern, external `UIViewControllerAnimatedTransitioning` vending ([stage-3](https://github.com/osteslag/custom-container-transitions/tree/stage-3), [diff](https://github.com/osteslag/custom-container-transitions/compare/stage-2...stage-3))

![Stage 3](stage-3.gif)

Read more on [objc.io](http://www.objc.io/issue-12/custom-container-view-controller-transitions.html).
