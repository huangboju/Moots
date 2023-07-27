/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Visual illustration of an insertion sort using diffable data sources to update the UI
*/

import UIKit

class InsertionSortViewController: UIViewController {

    static let nodeSize = CGSize(width: 16, height: 34)
    static let reuseIdentifier = "cell-id"
    var insertionCollectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
        <InsertionSortArray, InsertionSortArray.SortNode>! = nil
    var isSorting = false
    var isSorted = false

    override func viewDidLoad() {
      super.viewDidLoad()
        navigationItem.title = "Insertion Sort Visualizer"
        configureHierarchy()
        configureDataSource()
        configureNavItem()
    }
}

extension InsertionSortViewController {

    func configureHierarchy() {
        insertionCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        insertionCollectionView.backgroundColor = .black
        insertionCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(insertionCollectionView)
    }
    func configureNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isSorting ? "Stop" : "Sort",
                                                            style: .plain, target: self,
                                                            action: #selector(toggleSort))
    }
    @objc
    func toggleSort() {
        isSorting.toggle()
        if isSorting {
            performSortStep()
        }
        configureNavItem()
    }
    /// - Tag: InsertionSortStep
    func performSortStep() {
        if !isSorting {
            return
        }

        var sectionCountNeedingSort = 0

        // Get the current state of the UI from the data source.
        var updatedSnapshot = dataSource.snapshot()

        // For each section, if needed, step through and perform the next sorting step.
        updatedSnapshot.sectionIdentifiers.forEach {
            let section = $0
            if !section.isSorted {

                // Step the sort algorithm.
                section.sortNext()
                let items = section.values

                // Replace the items for this section with the newly sorted items.
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
        let bounds = insertionCollectionView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            if shouldReset {
                let snapshot = self.randomizedSnapshot(for: bounds)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            self.performSortStep()
        }
    }
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = Int(contentSize.width / InsertionSortViewController.nodeSize.width)
            let rowHeight = InsertionSortViewController.nodeSize.height
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
        
        let cellRegistration = UICollectionView.CellRegistration
        <UICollectionViewCell, InsertionSortArray.SortNode> { (cell, indexPath, sortNode) in
            // Populate the cell with our item description.
            cell.backgroundColor = sortNode.color
        }
        
        dataSource = UICollectionViewDiffableDataSource<InsertionSortArray, InsertionSortArray.SortNode>(collectionView: insertionCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, node: InsertionSortArray.SortNode) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: node)
        }

        let bounds = insertionCollectionView.bounds
        let snapshot = randomizedSnapshot(for: bounds)
        dataSource.apply(snapshot)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if dataSource != nil {
            let bounds = insertionCollectionView.bounds
            let snapshot = randomizedSnapshot(for: bounds)
            dataSource.apply(snapshot)
        }
    }
    func randomizedSnapshot(for bounds: CGRect) -> NSDiffableDataSourceSnapshot
        <InsertionSortArray, InsertionSortArray.SortNode> {
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
        return Int(bounds.height / InsertionSortViewController.nodeSize.height)
    }
    func columns(for bounds: CGRect) -> Int {
        return Int(bounds.width / InsertionSortViewController.nodeSize.width)
    }
}
