UIScreenEdgePanGestureDemo
==========================

Here is tutorial code for the [UIScreenEdgePanGestureRecognizer](https://developer.apple.com/library/ios/documentation/uikit/reference/UIScreenEdgePanGestureRecognizer_class/Reference/Reference.html) for left/right edge swipes on iOS.

You can only add one edge to the UIScreenEdgePanGestureRecognizer. If you want to respond to multiple edges, add a separate gesture recognizer for each screen edge. Use the [UIRectEdge](https://developer.apple.com/library/ios/documentation/uikit/reference/UIKitConstantsReference/Reference/reference.html#//apple_ref/doc/c_ref/UIRectEdge) to setup each gesture recognizer in your app.

If you want to use multiple gestures in-conjunction with the UIScreenEdgePanGestureRecognizer, you'll have to set the delegate and conform to the [UIGestureRecognizerDelegate](https://developer.apple.com/library/ios/documentation/uikit/reference/UIGestureRecognizerDelegate_Protocol/Reference/Reference.html) protocol

![The UIScreenEdgePanGestureRecognizer demonstrates how to use the swipe gesture on the edge of the iPhone](https://raw.githubusercontent.com/PaulSolt/UIScreenEdgePanGestureDemo/master/Edge%20Swipe%20Gesture%20iPhone.png)

