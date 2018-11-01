//
//  SampleImageDetailVC.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/10/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

class SampleImageDetailVC: UIViewController {
    var imageView: UIImageView?
    override var prefersStatusBarHidden: Bool { return true }
    
    var imageVewModel: ImageViewModel? {
        didSet {
            guard let imageVewModel = imageVewModel else { return }
            _loadingIndicator.startAnimating()
            _loadingIndicator.isHidden = false
            imageVewModel.image.observe { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView?.image = image
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self?._loadingIndicator.stopAnimating()
                    self?._loadingIndicator.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        imageView = UIImageView().configure {
            $0.contentMode = .scaleAspectFill
            $0.addSubview(_loadingIndicator)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setConstraints()
       // _configureForDebug()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(actionClose(tap:)))
        view.addGestureRecognizer(recognizer)
    }
        
    func actionClose(tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate lazy var _loadingIndicator: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.color = .darkGray 
        return $0
    }( UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge) )

}

extension SampleImageDetailVC {
    func setConstraints() {
        guard let imageView = self.imageView else { return }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            _loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            _loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
}

// MARK: - 🐞Debug configuration
extension SampleImageDetailVC: DebugConfigurable {
    func _configureForDebug()  {
        view.backgroundColor = .magenta
        view.layer.borderWidth = 20.0
        view.layer.borderColor = UIColor.green.cgColor
    }
}
