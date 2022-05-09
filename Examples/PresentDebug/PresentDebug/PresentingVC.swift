//
//  ViewController.swift
//  ModalPresentationStyleCustom
//
//  Created by 黄伯驹 on 2021/11/21.
//

import UIKit

class PresentingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(classForCoder, #function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(classForCoder, #function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(classForCoder, #function)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(classForCoder, #function)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("🍀🍀🍀 开始显示 PresentedVC 🍀🍀🍀")

        let presentedVC = PresentedVC()
        presentedVC.modalPresentationStyle = UIModalPresentationStyle.custom
        presentedVC.transitioningDelegate = self
        present(presentedVC, animated: true, completion: nil)
    }
}

extension PresentingVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FadePresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator()
    }
}

final class FadePresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return true
    }
}

final class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: .to) else {
            return
        }

        view.alpha = 0

        transitionContext.containerView.addSubview(view)

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            view.alpha = 1
        } completion: { flag in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

