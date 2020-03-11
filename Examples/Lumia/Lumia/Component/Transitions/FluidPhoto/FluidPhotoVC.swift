//
//  FluidPhotoVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/3/11.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class FluidPhotoVC: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "3"))
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc
    func imageViewClicked(_ sender: UIButton) {
        let vc = FluidPhotoDetailVC()
        vc.transitioningDelegate = vc.transitionController
        vc.transitionController.fromDelegate = self
        vc.transitionController.toDelegate = vc
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension FluidPhotoVC: ZoomAnimatorDelegate {
    
    func transitionWillStart(with zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEnd(with zoomAnimator: ZoomAnimator) {
        
    }

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return imageView
    }
    
    func targetFrame(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return imageView.frame
    }
}




class FluidPhotoDetailVC: UIViewController {
    
    let transitionController = ZoomTransitionController()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "3"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(initiateTransitionInteractively))
        view.addGestureRecognizer(pan)
    }
    
    @objc func initiateTransitionInteractively(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began:
            transitionController.isInteractive = true
            dismiss(animated: true, completion: nil)
        case .ended:
            if transitionController.isInteractive {
                transitionController.isInteractive = false
                transitionController.didPan(with: panGesture)
            }
        default:
            if transitionController.isInteractive {
                self.transitionController.didPan(with: panGesture)
            }
        }
    }
}

extension FluidPhotoDetailVC: ZoomAnimatorDelegate {
    
    func transitionWillStart(with zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEnd(with zoomAnimator: ZoomAnimator) {
        
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {

        return imageView
    }
    
    func targetFrame(for zoomAnimator: ZoomAnimator) -> CGRect? {

        return imageView.frame
    }
}
