/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The startup view controller for this sample, using a custom line UICollectionViewFlowLayout.
*/

import UIKit

class FriendsViewController: UICollectionViewController {
    
    static let segueIdentifier = "goFeedViewController"
    
    private var flowLayout = ColumnFlowLayout()
    private var feedViewController = FeedViewController()
    private var people = sampleData()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCollectionView()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as? PersonCell
            else { preconditionFailure("Failed to load collection view cell") }

        cell.person = people[indexPath.item]
        return cell
    }
    
    // MARK: - Segue Management
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let feedViewController = segue.destination as? FeedViewController else {
            fatalError()
        }
        
        if segue.identifier == FriendsViewController.segueIdentifier {
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                let indexPath = indexPaths[0]
                print("\(String(describing: indexPath))")
                let person = people[indexPath.row] as Person
                feedViewController.person = person
            }
        }
    }
    
    // MARK: - UI Hooks
    
    @IBAction func updateButtonTapped(sender: UIButton) {
        performUpdates()
    }
    
    @objc
    func didRefresh() {
        guard let collectionView = collectionView,
            let refreshControl = collectionView.refreshControl else { return }

        // The call to asyncAfter here is only to simulate a half second network delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            refreshControl.endRefreshing()
            
            collectionView.performBatchUpdates({ [unowned self] in
                self.people = FriendsViewController.sampleData()
                collectionView.reloadSections([0])
            })
        }
    }
    
    // MARK: Updates

    /// - Tag: PerformUpdates
    func performUpdates() {
        // This sample code uses test data to simulate updates received from a remote server. The
        // remoteUpdates array contains a collection of PersonUpdate enums representing deletions,
        // insertions, movements and reloads. Several example data sets have been included below.
        // Any rows that are reloaded will be displayed with a cyan-colored update indicator.

        // Sample remote updates showing one person being deleted.
        // let remoteUpdates = [ PersonUpdate.delete(0) ]

        // Sample remote updates showing one reload, one person being moved and one being deleted.
        // let remoteUpdates = [
        //   PersonUpdate.reload(3),
        //   PersonUpdate.move(3, 0),
        //   PersonUpdate.delete(2),
        // ]

        // Sample remote updates moving the top three people down by one and reloading the other row.
        let remoteUpdates = [
            PersonUpdate.move(0, 1),
            PersonUpdate.move(1, 2),
            PersonUpdate.move(2, 3),
            PersonUpdate.reload(3)
        ]

        // Perform any cell reloads without animation because there is no movement.
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                for update in remoteUpdates {
                    if case let .reload(index) = update {
                        people[index].isUpdated = true
                        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    }
                }
            })
        }

        // Animate all other update types together.
        collectionView.performBatchUpdates({
            var deletes = [Int]()
            var inserts = [(person:Person, index:Int)]()

            for update in remoteUpdates {
                switch update {
                case let .delete(index):
                    collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    deletes.append(index)
                    
                case let .insert(person, index):
                    collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                    inserts.append((person, index))
                    
                case let .move(fromIndex, toIndex):
                    // Updates that move a person are split into an addition and a deletion.
                    collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                            to: IndexPath(item: toIndex, section: 0))
                    deletes.append(fromIndex)
                    inserts.append((people[fromIndex], toIndex))
                    
                default: break
                }
            }
            
            // Apply deletions in descending order.
            for deletedIndex in deletes.sorted().reversed() {
                people.remove(at: deletedIndex)
            }
            
            // Apply insertions in ascending order.
            let sortedInserts = inserts.sorted(by: { (personA, personB) -> Bool in
                return personA.index <= personB.index
            })
            for insertion in sortedInserts {
                people.insert(insertion.person, at: insertion.index)
            }
            
            // The update button is enabled only if the list still has people in it.
            navigationItem.rightBarButtonItem?.isEnabled = !people.isEmpty
        })
    }
    
    // MARK: UI Helper Methods

    func prepareCollectionView() {
        guard let navController = self.navigationController else { return }

        // Customize navigation bar.
        self.title = "Friends"
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.appBackgroundColor
        navController.navigationBar.shadowImage = #imageLiteral(resourceName: "barShadow")
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Set our left and right bar button items.
        let avatarView = AvatarView()
        let leftBarButtonItem = UIBarButtonItem(customView: avatarView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Set up the collection view.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white

        // Set up the refresh control as part of the collection view when it's pulled to refresh.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.sendSubviewToBack(refreshControl)
    }

    // MARK: - Sample Data

    static func sampleData() -> [Person] {
        return [
            Person(name: "Steve", month: 6, day: 3, year: 2018),
            Person(name: "Mohammed", month: 6, day: 2, year: 2018),
            Person(name: "Samir", month: 5, day: 21, year: 2018),
            Person(name: "Priyanka", month: 5, day: 20, year: 2018)
        ]
    }
}
