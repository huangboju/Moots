//
//  GalleryCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 25.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell, CollectionViewCell {

    typealias CellContent = [UIImage]

    var content: CellContent? {
        didSet {
            collectionView.reloadData()
        }
    }

    fileprivate let layout = UICollectionViewFlowLayout()

    private let collectionView: UICollectionView

    override init(frame: CGRect) {

        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(allSides: spacing)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)

        contentView.backgroundColor = .white

        collectionView.frame = contentView.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.delaysContentTouches = false
        collectionView.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.viewReuseIdentifier)
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        content = nil
        collectionView.contentOffset = .zero
    }

    static func calculateHeight(content: CellContent, forWidth width: CGFloat) -> CGFloat {

        return isIpad ? 200 : 150
    }
}


extension GalleryCell: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthHeight = collectionView.bounds.height - self.layout.sectionInset.top - self.layout.sectionInset.bottom

        return CGSize(width: widthHeight, height: widthHeight)
    }
}


extension GalleryCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return content != nil ? 1 : 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return content?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.viewReuseIdentifier, for: indexPath) as! GalleryImageCell
        cell.image = content?[indexPath.item]

        return cell
    }
}


extension GalleryCell: UICollectionViewDelegate {

}


fileprivate class GalleryImageCell: UICollectionViewCell {

    static let viewReuseIdentifier = "GalleryImageCell"

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    private let imageView = UIImageView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            imageView.alpha = isHighlighted ? 0.7 : 1
        }
    }
}
