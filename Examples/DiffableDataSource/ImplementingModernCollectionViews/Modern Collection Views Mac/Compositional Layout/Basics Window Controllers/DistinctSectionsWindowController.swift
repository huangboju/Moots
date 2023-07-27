/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Per-section specific layout example
*/

import Cocoa

class DistinctSectionsWindowController: NSWindowController {

    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3
        var columnCount: Int {
            switch self {
            case .grid3:
                return 3

            case .grid5:
                return 5

            case .list:
                return 1
            }
        }
    }

    private var dataSource: NSCollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil
    @IBOutlet weak var collectionView: NSCollectionView!

    override func windowDidLoad() {
        super.windowDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension DistinctSectionsWindowController {
    private func createLayout() -> NSCollectionViewLayout {
        let layout = NSCollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)!
            let columns = sectionLayoutKind.columnCount

            // The `group` auto-calculates the actual item width to make the requested number of `columns` fit,
            // so this `widthDimension` will be ignored.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = columns == 1 ?
                NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

extension DistinctSectionsWindowController {
    private func configureHierarchy() {

        let textItemNib = NSNib(nibNamed: "TextItem", bundle: nil)
        collectionView.register(textItemNib, forItemWithIdentifier: TextItem.reuseIdentifier)

        let listItemNib = NSNib(nibNamed: "ListItem", bundle: nil)
        collectionView.register(listItemNib, forItemWithIdentifier: ListItem.reuseIdentifier)

        collectionView.collectionViewLayout = createLayout()
    }
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) {
                (collectionView: NSCollectionView, indexPath: IndexPath, identifier: Int) -> NSCollectionViewItem? in
            let section = SectionLayoutKind(rawValue: indexPath.section)!
            if section == .list {
                if let item = collectionView.makeItem(
                    withIdentifier: ListItem.reuseIdentifier, for: indexPath) as? ListItem {
                    item.textField?.stringValue = "\(identifier)"
                    return item
                } else {
                    fatalError("Cannot create new item")
                }
            } else {
                if let item = collectionView.makeItem(
                    withIdentifier: TextItem.reuseIdentifier, for: indexPath) as? TextItem {
                    item.textField?.stringValue = "\(identifier)"
                    if let box = item.view as? NSBox {
                        box.cornerRadius = section == .grid5 ? 8 : 0
                    }
                    return item
                } else {
                    fatalError("Cannot create new item")
                }
            }
        }

        // initial data
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
