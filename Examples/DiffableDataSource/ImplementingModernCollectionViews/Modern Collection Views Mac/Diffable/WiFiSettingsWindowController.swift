/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Mimics the iOS Wi-Fi settings UI for displaying a dynamic list of available wi-fi access points
*/

import Cocoa

class WiFiSettingsWindowController: NSWindowController {

    enum Section: CaseIterable {
        case config, networks
    }

    enum ItemType {
        case wifiEnabled, currentNetwork, availableNetwork
    }

    struct Item: Hashable {
        let title: String
        let type: ItemType
        let network: WiFiController.Network?

        init(title: String, type: ItemType) {
            self.title = title
            self.type = type
            self.network = nil
            self.identifier = UUID()
        }
        init(network: WiFiController.Network) {
            self.title = network.name
            self.type = .availableNetwork
            self.network = network
            self.identifier = network.identifier
        }
        var isConfig: Bool {
            let configItems: [ItemType] = [.currentNetwork, .wifiEnabled]
            return configItems.contains(type)
        }
        var isNetwork: Bool {
            return type == .availableNetwork
        }

        private let identifier: UUID
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
    }

    @IBOutlet weak var collectionView: NSCollectionView! = nil
    private var dataSource: NSCollectionViewDiffableDataSource<Section, Item>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    private var wifiController: WiFiController! = nil
    private lazy var configurationItems: [Item] = {
        return [Item(title: "Wi-Fi", type: .wifiEnabled),
                Item(title: "breeno-net", type: .currentNetwork)]
    }()

    static let reuseIdentifier = NSUserInterfaceItemIdentifier("reuse-identifier")

    override func windowDidLoad() {
        super.windowDidLoad()
        configureCollectionView()
        configureDataSource()
        updateUI(animated: false)
    }

    func configureCollectionView() {
        let itemNib = NSNib(nibNamed: "WiFiNetworkItem", bundle: nil)!
        collectionView.register(itemNib, forItemWithIdentifier: WiFiNetworkItem.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
    }
}

extension WiFiSettingsWindowController {

    private func configureDataSource() {

        wifiController = WiFiController { [weak self] (controller: WiFiController) in
            guard let self = self else { return }
            self.updateUI()
        }

        dataSource = NSCollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, itemProvider: {
            (collectionView: NSCollectionView, indexPath: IndexPath, item: Item) -> NSCollectionViewItem? in
            guard let collectionViewItem = collectionView.makeItem(
                withIdentifier: WiFiNetworkItem.reuseIdentifier,
                for: indexPath) as? WiFiNetworkItem else { fatalError() }

            collectionViewItem.textField?.stringValue = item.title

            // network cell
            if item.isNetwork {
                collectionViewItem.imageView?.isHidden = true
                collectionViewItem.textField?.isHidden = false
                collectionViewItem.checkBox.isHidden = true
            // configuration cells
            } else if item.isConfig {
                if item.type == .wifiEnabled {
                    collectionViewItem.textField?.stringValue = "Wi-Fi Enabled"
                    collectionViewItem.checkBox.target = self
                    collectionViewItem.checkBox.action = #selector(self.toggleWifi(_:))
                    collectionViewItem.checkBox.state = self.wifiController.wifiEnabled ? .on : .off
                    collectionViewItem.checkBox.isHidden = false
                    collectionViewItem.imageView?.isHidden = true
                    collectionViewItem.textField?.isHidden = false
                } else {
                    collectionViewItem.imageView?.isHidden = false
                    collectionViewItem.checkBox.isHidden = true
                    collectionViewItem.textField?.isHidden = false
                }
            } else {
                fatalError("Unknown item type!")
            }

            return collectionViewItem
        })
    }

    private func updateUI(animated: Bool = true) {
        guard let controller = self.wifiController else { return }

        let configItems = configurationItems.filter { !($0.type == .currentNetwork && !controller.wifiEnabled) }

        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        currentSnapshot.appendSections([.config])
        currentSnapshot.appendItems(configItems, toSection: .config)

        if controller.wifiEnabled {
            let sortedNetworks = controller.availableNetworks.sorted { $0.name < $1.name }
            let networkItems = sortedNetworks.map { Item(network: $0) }
            currentSnapshot.appendSections([.networks])
            currentSnapshot.appendItems(networkItems, toSection: .networks)
        }

        self.dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }

    private func createLayout() -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(19))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }

    @IBAction func toggleWifi(_ wifiEnabledCheckBox: NSButton) {
        wifiController.wifiEnabled = wifiEnabledCheckBox.state == .on
        updateUI()
    }
}
