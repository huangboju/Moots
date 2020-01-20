//
//  ViewController.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var rows: [RowType] = [
        Row<TitleCell>(viewData: TitleCellItem(title: "动画", segue: .segue(AnimationListVC.self))),
        Row<TitleCell>(viewData: TitleCellItem(title: "隐藏属性查看", segue: .segue(ClassCopyIvarListVC.self))),
        Row<TitleCell>(viewData: TitleCellItem(title: "StateMachine", segue: .segue(StateMachineVC.self)))
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.itemSize = CGSize(width: (self.view.frame.width - inset * 3) / 2, height: 100)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lumia"
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)

        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        for selectedRow in selectedItems {
            transitionCoordinator?.animate(alongsideTransition: { context in
                self.collectionView.deselectItem(at: selectedRow, animated: true)
            }, completion: { context in
                if context.isCancelled {
                    self.collectionView.selectItem(at: selectedRow, animated: false, scrollPosition: [])
                }
            })
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: TitleCellItem = rows[indexPath.row].cellItem()
        show(item.segue) { vc in
            vc.title = item.title
        }
    }
}


extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        rows[indexPath.row].update(cell: cell)
        return cell
    }
}

struct TitleCellItem {
    let title: String
    let segue: Segue
}

class TitleCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.boldSystemFont(ofSize: 25)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        selectedBackgroundView?.layer.cornerRadius = 8
        selectedBackgroundView?.clipsToBounds = true

        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        contentView.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleCell: Updatable {
    func update(viewData: TitleCellItem) {
        textLabel.text = viewData.title
    }
}
