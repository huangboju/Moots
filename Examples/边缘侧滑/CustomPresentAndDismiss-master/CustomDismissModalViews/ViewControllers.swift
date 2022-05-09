//  Created by David Seek on 11/21/16.
//  Copyright © 2016 David Seek. All rights reserved.

import UIKit

class VC1: UIViewController, UIViewControllerTransitioningDelegate {
    
    let interactor = Interactor()
    
    @IBAction func present(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2") as! VC2
        vc.transitioningDelegate = self
        vc.interactor = interactor
        
        presentVCRightToLeft(self, vc)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class VC2: UIViewController {
    
    var interactor:Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiatePanGestureRecognizer(self, #selector(gesture))
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismissVCLeftToRight(self)
    }
    
    @objc func gesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismissVCOnPanGesture(self, sender, interactor!)
    }
}
