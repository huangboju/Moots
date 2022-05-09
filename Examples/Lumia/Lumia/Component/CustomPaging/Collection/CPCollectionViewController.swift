//
//  CollectionViewController.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 25/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit

final class CPCollectionViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Static.makeLayout())
        pagingView = PagingView(contentView: collectionView)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Collection"
        view.backgroundColor = .white
        
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: Static.cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        contentScrollView.addSubview(pagingView)
        pagingView.anchors = anchors
        pagingView.decelerationRate = settingsView.decelerationRate
        pagingView.springBounciness = settingsView.springBounciness
        pagingView.springSpeed = settingsView.springSpeed
        
        contentScrollView.addSubview(settingsView)
        settingsView.delegate = self
        
        view.addSubview(contentScrollView)
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.showsVerticalScrollIndicator = false
        
        setupLayout()
    }
    
    // MARK: - Private
    
    private let collectionView: UICollectionView
    private let pagingView: PagingView
    private let settingsView = CollectionSettingsView()
    private let contentScrollView = UIScrollView()
    private let cellInfos: [CollectionCell.Info] = Static.makeCellInfos()
    
    private var anchors: [CGPoint] {
        return (0..<cellInfos.count).map {
            let offsetX = cellInfos.prefix($0).reduce(0, { $0 + $1.size.width + Static.cellSpacing })
            return CGPoint(x: offsetX, y: 0)
        }
    }
    
    private func setupLayout() {
        let content = contentScrollView
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        pagingView.heightAnchor.constraint(equalToConstant: Static.collectionHeight).isActive = true
        pagingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pagingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pagingView.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        pagingView.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        pagingView.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        settingsView.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        
        settingsView.topAnchor.constraint(equalTo: pagingView.bottomAnchor).isActive = true
    }
    
    // MARK: - Private: Static
    
    private struct Static {
        
        static let minCellWidth: CGFloat = 64
        
        static let maxCellWidth: CGFloat = 256
        
        static let cellHeight: CGFloat = 56
        
        static let cellSpacing: CGFloat = 8
        
        static let collectionHeight = cellHeight + 64
        
        static let cellReuseIdentifier = "\(CollectionCell.self)"
        
        static let cellColors: [UInt] = [0xB11F38, 0xE77A39, 0xEBD524, 0x4AA77A, 0x685B87, 0xA24C57]
        
        static func makeCellInfos() -> [CollectionCell.Info] {
            return (cellColors + cellColors + cellColors).map {
                let text = String(format: "%06X", $0)
                let size = CGSize(width: round(.random(in: minCellWidth...maxCellWidth)), height: cellHeight)
                return CollectionCell.Info(text: text, textColor: .white, bgColor: UIColor(rgb: $0), size: size)
            }
        }
        
        static func makeLayout() -> UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = cellSpacing
            layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
            layout.scrollDirection = .horizontal
            return layout
        }

    }

}


extension CPCollectionViewController: CollectionSettingsViewDelegate {
    
    func didChangeDeceleration(_ value: CGFloat) {
        pagingView.decelerationRate = value
    }
    
    func didChangeSpringBounciness(_ value: CGFloat) {
        pagingView.springBounciness = value
    }
    
    func didChangeSpringSpeed(_ value: CGFloat) {
        pagingView.springSpeed = value
    }
    
}


extension CPCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return cellInfos[indexPath.item].size
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        pagingView.contentViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pagingView.contentViewWillBeginDragging(scrollView)
    }
 
}


extension CPCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Static.cellReuseIdentifier, for: indexPath)
        (cell as? CollectionCell)?.update(with: cellInfos[indexPath.item])
        return cell
    }
    
}
