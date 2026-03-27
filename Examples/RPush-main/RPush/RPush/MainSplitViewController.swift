//
//  MainSplitViewController.swift
//  RPush
//

import Cocoa

class MainSplitViewController: NSSplitViewController, SidebarDelegate, HistoryViewDelegate {
    
    private(set) var pushVC: ViewController!
    private var sidebarVC: SidebarViewController!
    private var historyVC: HistoryViewController!
    private var contentContainerVC: NSViewController!
    private var currentContentVC: NSViewController?
    
    convenience init(pushViewController: ViewController) {
        self.init()
        self.pushVC = pushViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitView.dividerStyle = .thin
        
        sidebarVC = SidebarViewController()
        sidebarVC.delegate = self
        
        historyVC = HistoryViewController()
        historyVC.historyDelegate = self
        
        contentContainerVC = NSViewController()
        contentContainerVC.view = NSView()
        
        let sidebarItem = NSSplitViewItem(viewController: sidebarVC)
        sidebarItem.canCollapse = false
        sidebarItem.minimumThickness = 160
        sidebarItem.maximumThickness = 250
        sidebarItem.holdingPriority = .init(251)
        
        let contentItem = NSSplitViewItem(viewController: contentContainerVC)
        contentItem.minimumThickness = 500
        
        addSplitViewItem(sidebarItem)
        addSplitViewItem(contentItem)
        
        showPushPage()
    }
    
    // MARK: - Page Switching
    
    func showPushPage() {
        showContent(pushVC)
    }
    
    func showHistoryPage() {
        historyVC.reloadData()
        showContent(historyVC)
    }
    
    private func showContent(_ vc: NSViewController) {
        guard currentContentVC !== vc else { return }
        
        currentContentVC?.view.removeFromSuperview()
        currentContentVC?.removeFromParent()
        
        contentContainerVC.addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentContainerVC.view.addSubview(vc.view)
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: contentContainerVC.view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentContainerVC.view.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: contentContainerVC.view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentContainerVC.view.trailingAnchor),
        ])
        
        currentContentVC = vc
    }
    
    // MARK: - SidebarDelegate
    
    func sidebar(_ controller: SidebarViewController, didSelectItemAt index: Int) {
        switch index {
        case 0:
            showPushPage()
        case 1:
            showHistoryPage()
        default:
            break
        }
    }
    
    // MARK: - HistoryViewDelegate
    
    func historyView(_ controller: HistoryViewController, didSelectRecord record: PushHistoryRecord) {
        pushVC.fillFromHistoryRecord(record)
        showPushPage()
        sidebarVC.selectItem(at: 0)
    }
}
