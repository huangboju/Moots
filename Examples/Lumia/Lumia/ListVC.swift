//
//  ListVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    open var rows: [RowType] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: self.view.frame.width, height: 60)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FluidInterfacesCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fluid Interfaces"
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)

        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.visibleCells.forEach {
            $0.isHighlighted = false
        }
        
    }
}

extension ListVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        rows[indexPath.row].update(cell: cell)
        return cell
    }
}

extension ListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: Interface = rows[indexPath.row].cellItem()
        guard let segue = item.segue else { return }
        show(segue) { (vc: ClassCopyIvarDetailVC) in
            vc.className = item.name
        }
    }
}

struct Interface {
    let name: String
    let icon: UIImage?
    let color: UIColor?
    let segue: Segue?
    
    init(name: String, icon: UIImage? = nil, color: UIColor? = nil, segue: Segue? = nil) {
        self.name = name
        self.icon = icon
        self.color = color
        self.segue = segue
    }
}

class FluidInterfacesCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.boldSystemFont(ofSize: 25)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private lazy var arrowView: UIImageView = {
        let arrowView = UIImageView(image: UIImage(named: "chevron"))
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.tintColor = UIColor(hex: 0x515151)
        return arrowView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()

        contentView.addSubview(iconView)
        iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        contentView.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(arrowView)
        arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sharedInit() {
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = UIColor.white.withAlphaComponent(isHighlighted ? 0.2 : 0.1)
        }
    }
}

extension FluidInterfacesCell: Updatable {
    func update(viewData: Interface) {
        iconView.image = viewData.icon
        textLabel.text = viewData.name
        arrowView.isHidden = viewData.segue == nil
    }
}
