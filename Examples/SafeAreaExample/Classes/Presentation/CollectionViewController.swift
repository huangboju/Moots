//
//  CollectionViewController.swift
//  SafeAreaExample
//
//  Created by Evgeny Mikhaylov on 11/10/2017.
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

class CollectionViewController: SafeAreaViewController   {

    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.register(CollectionViewReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: CollectionViewReusableView.self))
        return collectionView
    }()
    
    lazy var collectionViewSectionItems: [CollectionViewSectionItem] = {
        return CollectionViewSectionItemsFactory.sectionItems(for: collectionView)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .grayBackgroundColor
        view.addSubview(collectionView)
    }
    
    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let sectionItem = collectionViewSectionItems[indexPath.section]
        sectionItem.cellItems.enumerated().forEach { (offset, cellItem) in
            if offset == indexPath.row {
                cellItem.enabled = true
                cellItem.selectionHandler?()
            }
            else {
                cellItem.enabled = false
            }
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItem = collectionViewSectionItems[section]
        return sectionItem.cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {
        view.backgroundColor = UIColor.red.withAlphaComponent(0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionItem = collectionViewSectionItems[indexPath.section]
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: String(describing: CollectionViewReusableView.self),
                                                                   for: indexPath) as! CollectionViewReusableView
        view.label.text = sectionItem.title
        view.switcher.isOn = sectionItem.attachContentToSafeArea
        view.delegate = sectionItem
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionItem = collectionViewSectionItems[indexPath.section]
        let cellItem = sectionItem.cellItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self),
                                                      for: indexPath) as! CollectionViewCell
        cell.label.text = cellItem.title
        cell.enabledLabel.isHidden = !cellItem.enabled
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellItem = collectionViewSectionItems[indexPath.section].cellItems[indexPath.item]
        return cellItem.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionItem = collectionViewSectionItems[section]
        return sectionItem.insets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionItem = collectionViewSectionItems[section]
        return sectionItem.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionItem = collectionViewSectionItems[section]
        return sectionItem.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionItem = collectionViewSectionItems[section]
        return sectionItem.referenceHeaderSize
    }
}
