/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Sample demonstrating UITableViewDiffableDataSource using editing, reordering and header/footer titles support
*/

import UIKit

class TableViewEditingViewController: UIViewController {
    
    let reuseIdentifier = "reuse-id"

    enum Section: Int {
        case visited = 0, bucketList
        func description() -> String {
            switch self {
            case .visited:
                return "Visited"
            case .bucketList:
                return "Bucket List"
            }
        }
        func secondaryDescription() -> String {
            switch self {
            case .visited:
                return "Trips I've made!"
            case .bucketList:
                return "Need to do this before I go!"
            }
        }
    }
    
    typealias SectionType = Section
    typealias ItemType = MountainsController.Mountain
    
    // Subclassing our data source to supply various UITableViewDataSource methods
    
    class DataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
        
        // MARK: header/footer titles support
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let sectionKind = Section(rawValue: section)
            return sectionKind?.description()
        }
        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            let sectionKind = Section(rawValue: section)
            return sectionKind?.secondaryDescription()
        }
        
        // MARK: reordering support
        
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
            guard sourceIndexPath != destinationIndexPath else { return }
            let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
            
            var snapshot = self.snapshot()

            if let destinationIdentifier = destinationIdentifier {
                if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
                   let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
                    let isAfter = destinationIndex > sourceIndex &&
                        snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
                        snapshot.sectionIdentifier(containingItem: destinationIdentifier)
                    snapshot.deleteItems([sourceIdentifier])
                    if isAfter {
                        snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
                    } else {
                        snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
                    }
                }
            } else {
                let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
                snapshot.deleteItems([sourceIdentifier])
                snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
            }
            apply(snapshot, animatingDifferences: false)
        }
        
        // MARK: editing support

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                }
            }
        }
    }
    
    var dataSource: DataSource!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        configureNavigationItem()
    }
}

extension TableViewEditingViewController {
    
    func configureHierarchy() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let formatter = NumberFormatter()
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        
        // data source
        
        dataSource = DataSource(tableView: tableView) { (tableView, indexPath, mountain) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = mountain.name
            if let formattedHeight = formatter.string(from: NSNumber(value: mountain.height)) {
                content.secondaryText = "\(formattedHeight)M"
            }
            cell.contentConfiguration = content
            return cell
        }
        
        // initial data
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func initialSnapshot() -> NSDiffableDataSourceSnapshot<SectionType, ItemType> {
        let mountainsController = MountainsController()
        let limit = 8
        let mountains = mountainsController.filteredMountains(limit: limit)
        let bucketList = Array(mountains[0..<limit / 2])
        let visited = Array(mountains[limit / 2..<limit])

        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        snapshot.appendSections([.visited])
        snapshot.appendItems(visited)
        snapshot.appendSections([.bucketList])
        snapshot.appendItems(bucketList)
        return snapshot
    }
    
    func configureNavigationItem() {
        navigationItem.title = "UITableView: Editing"
        let editingItem = UIBarButtonItem(title: tableView.isEditing ? "Done" : "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItems = [editingItem]
    }
    
    @objc
    func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        configureNavigationItem()
    }
}
