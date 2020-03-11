//
//  SimpleImageViewerVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/3/11.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class SimpleImageViewerVC: UIViewController {
    
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
        let configuration = ImageViewerConfiguration { config in
            config.imageView = self.imageView
        }
        present(ImageViewerController(configuration: configuration), animated: true)
    }
}
