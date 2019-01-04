//
//  SimpleViewController.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import Foundation
import CollectionViewTableKit

class SimpleViewController: TableCollectionViewController<SimpleSection> {

    override func viewDidLoad() {
 
        super.viewDidLoad()

        title = "Simple"

        layout.sectionBorderColor = .lightBorder

        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.register(SimpleLabelCell.self, forCellWithReuseIdentifier: SimpleLabelCell.viewReuseIdentifier)
        collectionView.register(SimpleImageLabelCell.self, forCellWithReuseIdentifier: SimpleImageLabelCell.viewReuseIdentifier)
        collectionView.register(SimpleSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleSectionHeaderView.viewReuseIdentifer)

        sections.append(.red)
        sections.append(.green)
        sections.append(.blue)

        collectionView.reloadData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(randomAdd))
    }

    private func createItem() -> SimpleSection {

        if (sections.count % 3) == 0 {
            return .red
        } else if (sections.count % 2) == 0 {
            return .green
        } else {
            return .blue
        }
    }

    @objc func add() {

        sections.append(createItem())

        let indexPath = IndexPath(item: 0, section: sections.count-1)

        collectionView.insertSections(IndexSet(integer: indexPath.section))
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
    }

    @objc func randomAdd() {

        let insertIndex = Int(arc4random_uniform(UInt32(sections.count)))
        let item = createItem()
        let indexPath = IndexPath(item: 0, section: insertIndex)

        sections.insert(item, at: insertIndex)
        collectionView.insertSections(IndexSet(integer: indexPath.section))
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = sections[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellReuseIdentifier, for: indexPath)

        switch section {
        case .red:
            let cell = cell as! SimpleImageLabelCell
            cell.title = section.title
        case .green, .blue:
            let cell = cell as! SimpleLabelCell
            cell.title = section.title
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            assertionFailure()
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimpleSectionHeaderView.viewReuseIdentifer, for: indexPath) as! SimpleSectionHeaderView
        header.title = "Header \(indexPath.section)."

        return header
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        sections.remove(at: indexPath.section)
        collectionView.deleteSections(IndexSet(integer: indexPath.section))
    }
}
