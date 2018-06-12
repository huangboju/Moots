//  Created by David Seek on 11/21/16.
//  Copyright © 2016 David Seek. All rights reserved.

import UIKit

class DismissAnimator : NSObject {
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let screenBounds = UIScreen.main.bounds
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }

        var x      = toView.bounds.minX - screenBounds.width
        let y      = toView.bounds.minY
        let width  = toView.bounds.width
        let height = toView.bounds.height
        var frame  = CGRect(x: x, y: y, width: width, height: height)

        toView.alpha = 0.2

        toView.frame = frame

        let containerView = transitionContext.containerView

        containerView.insertSubview(toView, belowSubview: fromView)

        let bottomLeftCorner = CGPoint(x: screenBounds.width, y: 0)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromView.frame = finalFrame
                toView.alpha = 1
                
                x = toView.bounds.minX
                frame = CGRect(x: x, y: y, width: width, height: height)

                toView.frame = frame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

let transition: CATransition = CATransition()

func presentVCRightToLeft(_ fromVC: UIViewController, _ toVC: UIViewController) {
    transition.duration = 0.5
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromRight
    fromVC.view.window!.layer.add(transition, forKey: kCATransition)
    fromVC.present(toVC, animated: false, completion: nil)
}

func dismissVCLeftToRight(_ vc: UIViewController) {
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    vc.view.window!.layer.add(transition, forKey: nil)
    vc.dismiss(animated: false, completion: nil)
}

func instantiatePanGestureRecognizer(_ vc: UIViewController, _ selector: Selector) {
    var edgeRecognizer: UIScreenEdgePanGestureRecognizer!
    edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: vc, action: selector)
    edgeRecognizer.edges = .left
    vc.view.addGestureRecognizer(edgeRecognizer)
}

func dismissVCOnPanGesture(_ vc: UIViewController, _ sender: UIScreenEdgePanGestureRecognizer, _ interactor: Interactor) {
    let percentThreshold:CGFloat = 0.3
    let translation = sender.translation(in: vc.view)
    let fingerMovement = translation.x / vc.view.bounds.width
    let rightMovement = max(fingerMovement, 0.0)
    let rightMovementPercent = min(rightMovement, 1.0)
    let progress = rightMovementPercent

    switch sender.state {
    case .began:
        interactor.hasStarted = true
        vc.dismiss(animated: true, completion: nil)
    case .changed:
        interactor.shouldFinish = progress > percentThreshold
        interactor.update(progress)
    case .cancelled:
        interactor.hasStarted = false
        interactor.cancel()
    case .ended:
        interactor.hasStarted = false
        interactor.shouldFinish
            ? interactor.finish()
            : interactor.cancel()
    default:
        break
    }
}

///////////////// *********  Usage ********* /////////////////
//
// within the fromVC class: 
// *********
//
//
//      let interactor = Interactor()
//
//      @IBAction func present(_ sender: Any) {
//              let vc = self.storyboard?.instantiateViewController(withIdentifier: "toVC") as! toVC
//              vc.transitioningDelegate = self
//              vc.interactor = interactor
//              presentVCRightToLeft(self, vc)
//      }
//
//      func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//              return DismissAnimator()
//      }
//
//      func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//              return interactor.hasStarted ? interactor : nil
//      }
//
//
// *********
//
//
// within the toVC class:
// *********
//
//
//    var interactor:Interactor? = nil
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        instantiatePanGestureRecognizer(self, #selector(gesture))
//    }
//    
//    @IBAction func dismissButton(_ sender: Any) {
//        dismissVCLeftToRight(self)
//    }
//    
//    func gesture(_ sender: UIScreenEdgePanGestureRecognizer) {
//        dismissVCOnPanGesture(self, sender, interactor!)
//    }
//
//
