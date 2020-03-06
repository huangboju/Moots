//
//  FluidCardVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2020/1/19.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class FluidCardVC: UIViewController {

    private lazy var cardView: FluidCardView = {
        let cardView = FluidCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardView)
        cardView.widthAnchor.constraint(equalToConstant: 295).isActive = true
        cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 315).isActive = true
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        let topNib = UINib(nibName: "TopView", bundle: nil)
        let topView = topNib.instantiate(withOwner: self, options: nil).first as! UIView
        let bottomNib = UINib(nibName: "BottomView", bundle: nil)
        let bottomView = bottomNib.instantiate(withOwner: self, options: nil).first as! UIView
        cardView.topContentView = topView
        cardView.bottomContentView = bottomView
    }

}
