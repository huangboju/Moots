//
//  SidebarViewController.swift
//  RPush
//

import Cocoa

protocol SidebarDelegate: AnyObject {
    func sidebar(_ controller: SidebarViewController, didSelectItemAt index: Int)
}

class SidebarViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    weak var delegate: SidebarDelegate?
    
    private var tableView: NSTableView!
    
    private let menuItems: [(title: String, sfSymbol: String)] = [
        ("发送消息", "paperplane"),
        ("历史推送", "clock.arrow.circlepath"),
    ]
    
    override func loadView() {
        let effectView = NSVisualEffectView()
        effectView.material = .sidebar
        effectView.blendingMode = .behindWindow
        self.view = effectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.rowHeight = 34
        tableView.selectionHighlightStyle = .sourceList
        tableView.backgroundColor = .clear
        tableView.intercellSpacing = NSSize(width: 0, height: 4)
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("SidebarColumn"))
        column.isEditable = false
        tableView.addTableColumn(column)
        
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    func selectItem(at index: Int) {
        guard index >= 0, index < menuItems.count else { return }
        tableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return menuItems.count
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier("SidebarCell")
        let cell: NSTableCellView
        if let reused = tableView.makeView(withIdentifier: cellId, owner: nil) as? NSTableCellView {
            cell = reused
        } else {
            cell = makeSidebarCell(identifier: cellId)
        }
        
        let item = menuItems[row]
        cell.textField?.stringValue = item.title
        
        if #available(macOS 11.0, *) {
            cell.imageView?.image = NSImage(systemSymbolName: item.sfSymbol, accessibilityDescription: item.title)
            cell.imageView?.contentTintColor = .secondaryLabelColor
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        guard row >= 0 else { return }
        delegate?.sidebar(self, didSelectItemAt: row)
    }
    
    // MARK: - Private
    
    private func makeSidebarCell(identifier: NSUserInterfaceItemIdentifier) -> NSTableCellView {
        let cell = NSTableCellView()
        cell.identifier = identifier
        
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        cell.addSubview(imageView)
        cell.imageView = imageView
        
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = NSFont.systemFont(ofSize: 13)
        textField.lineBreakMode = .byTruncatingTail
        cell.addSubview(textField)
        cell.textField = textField
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 6),
            textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: cell.trailingAnchor, constant: -8),
        ])
        
        return cell
    }
}
