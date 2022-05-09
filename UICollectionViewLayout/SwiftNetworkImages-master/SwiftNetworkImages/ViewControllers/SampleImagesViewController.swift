//
//  SampleImagesViewController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit
import AKPFlowLayout

/**
    Top level view controller for the project
 */

class SampleImagesViewController: UIViewController {
    var layoutOptions: AKPLayoutConfigOptions = [.firstSectionIsGlobalHeader,
                                                 .firstSectionStretchable,
                                                 .sectionsPinToGlobalHeaderOrVisibleBounds]
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - ♻️Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setConstraints()
        _configureForDebug(_collectionView)
    }
        
    // MARK: - 🕶Private
    fileprivate var _collectionView: UICollectionView?
    fileprivate var _dataSourceDelegate: SampleImagesDataSourceDelegate?
}

// MARK: - 📐Layout && Constraints
extension SampleImagesViewController {
    func configureCollectionView() {
        let flowLayout: AKPFlowLayout = {
            $0.minimumInteritemSpacing = 2
            $0.layoutOptions = layoutOptions
            $0.firsSectionMaximumStretchHeight = view.bounds.width 
            return $0
        }( AKPFlowLayout() )
        
        _collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor.gray
            
            $0.dataSource = _dataSourceDelegate
            $0.delegate = _dataSourceDelegate
            
            $0.registerClass(ImageCollectionViewCell.self)
            $0.registerClass(ImageCollectionViewHeader.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            $0.registerClass(ImageCollectionViewGlobalHeader.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            
            view.addSubview($0)
        }
    }
    func setConstraints() {
        guard let collectionView = _collectionView else {return}
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Layout Config Options (UIPopoverPresentationControllerDelegate)
extension SampleImagesViewController: UIPopoverPresentationControllerDelegate {
    func showLayoutConfigOptions(_ sender: UIButton) {
        let configController = LayoutConfigController(style: UITableViewStyle.grouped)
        configController.configOptions = [.firstSectionIsGlobalHeader,
                                          .firstSectionStretchable,
                                          .sectionsPinToGlobalHeaderOrVisibleBounds]
        configController.selectedOptions = layoutOptions
        configController.modalPresentationStyle = .popover
        configController.preferredContentSize = CGSize(width: 360, height: configController.height)
        
        if let popOver = configController.popoverPresentationController {
            popOver.backgroundColor = .darkGray
            popOver.permittedArrowDirections = .any
            popOver.delegate = self
            popOver.sourceView = sender
            popOver.sourceRect = sender.bounds
            present(configController, animated: true, completion: nil)
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController:
        UIPopoverPresentationController) {
        if let configController = popoverPresentationController.presentedViewController
                                                                            as? LayoutConfigController {
            if let selectedOptions = configController.selectedOptions,
                let layout = self._collectionView?.collectionViewLayout as? AKPFlowLayout {
                self.layoutOptions = selectedOptions
                if layout.layoutOptions != selectedOptions {
                    layout.layoutOptions = selectedOptions
                    layout.invalidateLayout()
                }
            }
        }
    }
}

// MARK: - 🔌Dependencies injection
extension SampleImagesViewController: DependencyInjectable {
    func inject(_ dataSourceDelegate: SampleImagesDataSourceDelegate) {
        _dataSourceDelegate = dataSourceDelegate
    }
    
}

// MARK: - 🐞Debug configuration
extension SampleImagesViewController: DebugConfigurable {
    private func _configureForDebug(_ collectionView: UICollectionView) -> UICollectionView {
        collectionView.backgroundColor = .green
        collectionView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        return collectionView
    }
}

