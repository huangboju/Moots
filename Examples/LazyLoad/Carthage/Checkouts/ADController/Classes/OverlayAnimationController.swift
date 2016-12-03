//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class OverlayAnimationController: AnimatedTransitioning {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = ADConfig.shared.firstImage
        return imageView
    }()

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView

        guard let fromView = fromVC.view else { return }
        guard let toView = toVC.view else { return }
       
        let duration = transitionDuration(using: transitionContext)
        let isVertical = ADConfig.shared.isVertical
        
        let completion = { (flag: Bool) in
            UIView.animate(withDuration: 0.4, animations: {
                self.imageView.alpha = 0
                }, completion: { (flag) in
                    self.imageView.removeFromSuperview()
            })
            let isCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!isCancelled)
        }
        
        if toVC.isBeingPresented {
            
            containerView.addSubview(toView)

            let toViewWidth = ADConfig.shared.ADViewSize.width
            let toViewHeight = ADConfig.shared.ADViewSize.height

            toView.center = containerView.center

            let size = isVertical ? CGSize(width: 1, height: toViewHeight) : CGSize(width: toViewWidth, height: 1)
            toView.bounds = CGRect(origin: .zero, size: size)
            
            imageView.frame = toView.frame
            containerView.addSubview(imageView)
            
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.setBounds(with: toView, width: toViewWidth, height: toViewHeight)
                }, completion: completion)
        }

        //Dismissal 转场中不要将 toView 添加到 containerView
        if fromVC.isBeingDismissed {
            fromView.alpha = 0
            containerView.addSubview(imageView)
            imageView.frame = fromView.frame
            imageView.image = ADConfig.shared.lastImage
            UIView.animate(withDuration: duration, animations: {
                self.setBounds(with: fromView, width: 1, height: 1)
                }, completion: completion)
        }
    }

    func setBounds(with view: UIView, width: CGFloat, height: CGFloat) {
        if ADConfig.shared.isVertical {
            imageView.bounds.size.width = width
            view.bounds.size.width = width
        } else {
            imageView.bounds.size.height = height
            view.bounds.size.height = height
        }
    }
}
