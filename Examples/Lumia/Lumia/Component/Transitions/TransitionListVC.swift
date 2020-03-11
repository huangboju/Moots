//
//  TransitionListVC.swift
//  Lumia
//
//  Created by 黄伯驹 on 2020/3/6.
//  Copyright © 2020 黄伯驹. All rights reserved.
//

import UIKit

class TransitionListVC: ListVC {
    
    var transitionController: AssetTransitionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "iPhone 相册 转场", segue: .controller(AssetViewController(layoutStyle: .grid)))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "FluidPhoto", segue: .segue(FluidPhotoVC.self))),
        ]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: Interface = rows[indexPath.row].cellItem()
        guard item.name == "iPhone 相册 转场" else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
            return
        }
        if case let .controller(vc) = item.segue {
            let navigationController = UINavigationController(rootViewController: vc)
            transitionController = AssetTransitionController(navigationController: navigationController)
            navigationController.delegate = transitionController
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
}
