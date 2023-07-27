/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Visual illustration of an insertion sort using diffable data sources to update the UI
*/

import Cocoa

class InsertionSortWindowController: NSWindowController {

    @IBOutlet weak var sortButton: NSButton!
    static let nodeSize = CGSize(width: 16, height: 34)
    @IBOutlet weak var collectionView: NSCollectionView!
    var dataSource: NSCollectionViewDiffableDataSource
        <InsertionSortArray, InsertionSortArray.SortNode>!
    var isSorting = false
    var isSorted = false

    override func windowDidLoad() {
        super.windowDidLoad()
        configureHierarchy()
        configureDataSource()
        configureSortButton()
    }
}

extension InsertionSortWindowController {

    func configureHierarchy() {
        collectionView.collectionViewLayout = layout()

        let itemNib = NSNib(nibNamed: "InsertionSortItem", bundle: nil)
        collectionView.register(itemNib, forItemWithIdentifier: InsertionSortItem.reuseIdentifier)
    }
    func configureSortButton() {
        sortButton.title = isSorting ? "Stop" : "Sort"
    }
    @IBAction func toggleSort(_ sender: Any?) {
        isSorting.toggle()
        if isSorting {
            performSortStep()
        }
        configureSortButton()
    }
    func performSortStep() {
        if !isSorting {
            return
        }

        var sectionCountNeedingSort = 0

        // grab the current state of the UI from the data source
        var updatedSnapshot = dataSource.snapshot()

        // for each section, if needed, step through and perform the next sorting step
        updatedSnapshot.sectionIdentifiers.forEach {
            let section = $0
            if !section.isSorted {

                // step the sort algorthim
                section.sortNext()
                let items = section.values

                // replace our items for this section with the newly sorted items
                updatedSnapshot.deleteItems(items)
                updatedSnapshot.appendItems(items, toSection: section)

                sectionCountNeedingSort += 1
            }
        }

        var shouldReset = false
        var delay = 125
        if sectionCountNeedingSort > 0 {
            dataSource.apply(updatedSnapshot)
        } else {
            delay = 1000
            shouldReset = true
        }
        let bounds = collectionView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if shouldReset {
                let randomizedSnapshot = self.snapshot(for: bounds)
                self.dataSource.apply(randomizedSnapshot, animatingDifferences: false)
            }
            self.performSortStep()
        }
    }

    func layout() -> NSCollectionViewLayout {
        let layout = NSCollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = Int(contentSize.width / InsertionSortWindowController.nodeSize.width)
            let rowHeight = InsertionSortWindowController.nodeSize.height
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(rowHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }

    func configureDataSource() {
        dataSource = NSCollectionViewDiffableDataSource
            <InsertionSortArray, InsertionSortArray.SortNode>(collectionView: collectionView) {
                (collectionView: NSCollectionView,
                indexPath: IndexPath,
                identifier: Any) in
                let item = self.collectionView.makeItem(withIdentifier: InsertionSortItem.reuseIdentifier, for: indexPath)
            if let sortNode = identifier as? InsertionSortArray.SortNode, let box = item.view as? NSBox {
                box.fillColor = sortNode.color
            }
            return item
        }
        let backgroundQueue = DispatchQueue(label: "com.example.apple-samplecode.insertion-sort.update")
        if let bounds = collectionView.enclosingScrollView?.contentView.bounds {
            backgroundQueue.async {
                let snapshot = self.snapshot(for: bounds)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    func snapshot(for bounds: CGRect) -> NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode> {
        var snapshot = NSDiffableDataSourceSnapshot<InsertionSortArray, InsertionSortArray.SortNode>()
        let rowCount = rows(for: bounds)
        let columnCount = columns(for: bounds)
        for _ in 0..<rowCount {
            let section = InsertionSortArray(count: columnCount)
            snapshot.appendSections([section])
            snapshot.appendItems(section.values)
        }
        return snapshot
    }

    func rows(for bounds: CGRect) -> Int {
        return Int(bounds.height / InsertionSortWindowController.nodeSize.height)
    }

    func columns(for bounds: CGRect) -> Int {
        return Int(bounds.width / InsertionSortWindowController.nodeSize.width)
    }
}
