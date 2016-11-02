//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class PresentationController: UIPresentationController {
    private lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.center = self.containerView!.center
        dimmingView.bounds = CGRect(origin: .zero, size: ADConfig.shared.ADViewSize)
        return dimmingView
    }()
    
    private lazy var dismissButton: UIButton = {
        let x = (Constants.screenWidth + ADConfig.shared.ADViewSize.width) / 2
        let y = (Constants.screenHeight - ADConfig.shared.ADViewSize.height) / 2
        let dismissButton = UIButton(frame: CGRect(x: x - 44, y: y, width: 44, height: 44))
        if ADConfig.shared.closeButtonPosition == .bottom {
            dismissButton.frame.origin = CGPoint(x: (Constants.screenWidth - 44) / 2, y: (Constants.screenHeight + ADConfig.shared.ADViewSize.height) / 2)
        }
        dismissButton.imageView?.tintColor = UIColor.white
        dismissButton.alpha = 0
        dismissButton.setImage(ADConfig.shared.closeButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return dismissButton
    }()

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        UIView.animate(withDuration: 0.4) {
            self.dismissButton.alpha = 1
        }
    }

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dimmingView)
        UIApplication.shared.keyWindow?.addSubview(dismissButton)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            _ in
            self.dimmingView.bounds = self.containerView!.bounds
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
            }, completion: nil)
        dismissAction()
    }
    
    func dismissAction() {
        
        if let controller = presentedViewController as? ADController {
            if ["overlayVertical", "overlayHorizontal"].contains(ADConfig.shared.transitionType.rawValue) {
                ADConfig.shared.lastImage = getSnap(targetView: controller.view).image
            }
            if let closedHandel = controller.closedHandel {
                closedHandel()
            }
        }

        var applyTransform = CGAffineTransform(rotationAngle: 3 * .pi)
        applyTransform = applyTransform.scaledBy(x: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4, animations: {
            self.dismissButton.transform = applyTransform
            }, completion: { _ in
                self.dismissButton.removeFromSuperview()
                self.presentedViewController.dismiss(animated: true, completion: nil)
        })
    }

    func getSnap(targetView: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0)
        targetView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }

    override func containerViewWillLayoutSubviews(){
        dimmingView.center = containerView!.center
        dimmingView.bounds = containerView!.bounds

        presentedView?.center = containerView!.center
        // 显示部分的大小
        
        presentedView?.bounds = CGRect(origin: .zero, size: ADConfig.shared.ADViewSize)
    }
}
