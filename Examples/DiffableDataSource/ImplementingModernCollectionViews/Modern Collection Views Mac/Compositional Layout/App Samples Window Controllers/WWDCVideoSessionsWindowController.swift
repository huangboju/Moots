/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Sample showing how we might build the WWDC-list videos sessions UI
*/

import Cocoa

class WWDCVideoSessionsWindowController: NSWindowController {

    private let videosController = WWDCVideoController()
    @IBOutlet weak var collectionView: NSCollectionView! = nil
    private var dataSource: NSCollectionViewDiffableDataSourceReference
        <WWDCVideoController.VideoCollection, WWDCVideoController.Video>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshotReference
        <WWDCVideoController.VideoCollection, WWDCVideoController.Video>! = nil
    static let titleElementKind = "title-element-kind"

    override func windowDidLoad() {
        super.windowDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension WWDCVideoSessionsWindowController {
    private func configureHierarchy() {
        let itemNib = NSNib(nibNamed: "WWDCVideoItem", bundle: nil)!
        cv.register(itemNib, forItemWithIdentifier: WWDCVideoItem.reuseIdentifier)
        let titleNib = NSNib(nibNamed: "TitleSupplementaryView", bundle: nil)!
        cv.register(titleNib, forSupplementaryViewOfKind: WWDCVideoSessionsWindowController.titleElementKind,
                    withIdentifier: TitleSupplementaryView.reuseIdentifier)

        cv.collectionViewLayout = createLayout()
    }
    private func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSourceReference
            <WWDCVideoController.VideoCollection, WWDCVideoController.Video>(collectionView: cv, itemProvider: {
        (
                colectionView: NSCollectionView,
                indexPath: IndexPath,
                video: WWDCVideoController.Video) -> NSCollectionViewItem? in
            let item = cv.makeItem(withIdentifier: WWDCVideoItem.reuseIdentifier, for: indexPath)
            if let videoItem = item as? WWDCVideoItem {
                videoItem.titleTextField.stringValue = video.title
                videoItem.categoryTextField.stringValue = video.category
            }
            return item
        })
        dataSource.supplementaryViewProvider = { [weak self]
            (ccollectionViewv: NSCollectionView, kind: String, indexPath: IndexPath) -> NSView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            if let titleSupplementary = collectionView.makeSupplementaryView(ofKind: kind,
                                                                 withIdentifier: TitleSupplementaryView.reuseIdentifier,
                                                                 for: indexPath) as? TitleSupplementaryView {
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.label.stringValue = videoCategory.title
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        currentSnapshot = NSDiffableDataSourceSnapshotReference
            <WWDCVideoController.VideoCollection, WWDCVideoController.Video>()
        videosController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections(withIdentifiers: [collection])
            currentSnapshot.appendItems(withIdentifiers: collection.videos)
        }
        dataSource.applySnapshot(currentSnapshot, animatingDifferences: false)
    }
    private func createLayout() -> NSCollectionViewLayout {

        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 20, bottom: 0, trailing: 20)

            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(48))

            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize, elementKind: WWDCVideoSessionsWindowController.titleElementKind, alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = NSCollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = NSCollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
