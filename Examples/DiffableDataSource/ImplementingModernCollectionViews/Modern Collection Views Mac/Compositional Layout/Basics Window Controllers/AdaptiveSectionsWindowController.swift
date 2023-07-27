/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A layout that adapts to a changing layout environment
*/

import Cocoa

class AdaptiveSectionsWindowController: NSWindowController {

    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            switch self {
            case .grid3:
                return wideMode ? 6 : 3

            case .grid5:
                return wideMode ? 10 : 5

            case .list:
                return wideMode ? 2 : 1
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

extension AdaptiveSectionsWindowController {
    private func createLayout() -> NSCollectionViewLayout {
        let layout = NSCollectionViewCompositionalLayout {
            (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let layoutKind = SectionLayoutKind(rawValue: sectionIndex)!
            let columns = layoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = layoutKind == .list ?
                NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

extension AdaptiveSectionsWindowController {
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
                if let textItem = collectionView.makeItem(
                    withIdentifier: TextItem.reuseIdentifier, for: indexPath) as? TextItem {
                    textItem.textField?.stringValue = "\(identifier)"
                    if let box = textItem.view as? NSBox {
                        box.cornerRadius = section == .grid5 ? 8 : 0
                    }
                    return textItem
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
