//
//  HistoryViewController.swift
//  RPush
//

import Cocoa

protocol HistoryViewDelegate: AnyObject {
    func historyView(_ controller: HistoryViewController, didSelectRecord record: PushHistoryRecord)
}

class HistoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    weak var historyDelegate: HistoryViewDelegate?
    
    private var tableView: NSTableView!
    private var records: [PushHistoryRecord] = []
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadData()
    }
    
    private func setupUI() {
        tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(tableViewDoubleClicked(_:))
        tableView.target = self
        tableView.rowHeight = 28
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        
        let columns: [(id: String, title: String, width: CGFloat, minWidth: CGFloat)] = [
            ("date",    "时间",          140, 120),
            ("auth",    "鉴权方式",       70,  60),
            ("env",     "环境",           60,  50),
            ("token",   "Device Token", 160, 100),
            ("payload", "Payload",      220, 150),
            ("result",  "结果",           50,  40),
        ]
        for col in columns {
            let tc = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(col.id))
            tc.title = col.title
            tc.width = col.width
            tc.minWidth = col.minWidth
            tableView.addTableColumn(tc)
        }
        
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let bottomBar = NSView()
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        let useButton = NSButton(title: "使用选中记录", target: self, action: #selector(useSelectedRecord(_:)))
        useButton.bezelStyle = .rounded
        useButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(useButton)
        
        let deleteButton = NSButton(title: "删除选中", target: self, action: #selector(deleteSelectedRecord(_:)))
        deleteButton.bezelStyle = .rounded
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(deleteButton)
        
        let clearButton = NSButton(title: "清空全部", target: self, action: #selector(clearAllRecords(_:)))
        clearButton.bezelStyle = .rounded
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(clearButton)
        
        let hintLabel = NSTextField(labelWithString: "双击记录可自动填充到发送页面")
        hintLabel.font = NSFont.systemFont(ofSize: 11)
        hintLabel.textColor = .secondaryLabelColor
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(hintLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -10),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            bottomBar.heightAnchor.constraint(equalToConstant: 30),
            
            hintLabel.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            hintLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            useButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            useButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: useButton.leadingAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            clearButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
        ])
    }
    
    func reloadData() {
        records = PushHistoryManager.shared.records
        tableView?.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func tableViewDoubleClicked(_ sender: Any) {
        let row = tableView.clickedRow
        guard row >= 0, row < records.count else { return }
        historyDelegate?.historyView(self, didSelectRecord: records[row])
    }
    
    @objc private func useSelectedRecord(_ sender: Any) {
        let row = tableView.selectedRow
        guard row >= 0, row < records.count else {
            let alert = NSAlert()
            alert.messageText = "请先选择一条记录"
            alert.runModal()
            return
        }
        historyDelegate?.historyView(self, didSelectRecord: records[row])
    }
    
    @objc private func deleteSelectedRecord(_ sender: Any) {
        let row = tableView.selectedRow
        guard row >= 0, row < records.count else {
            let alert = NSAlert()
            alert.messageText = "请先选择一条记录"
            alert.runModal()
            return
        }
        PushHistoryManager.shared.removeRecord(at: row)
        reloadData()
    }
    
    @objc private func clearAllRecords(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "确认清空全部历史记录？"
        alert.addButton(withTitle: "清空")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .warning
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            PushHistoryManager.shared.clearAll()
            reloadData()
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return records.count
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn, row < records.count else { return nil }
        let record = records[row]
        
        let cellId = NSUserInterfaceItemIdentifier("HistoryCell_\(column.identifier.rawValue)")
        let cell: NSTextField
        if let reused = tableView.makeView(withIdentifier: cellId, owner: nil) as? NSTextField {
            cell = reused
        } else {
            cell = NSTextField(labelWithString: "")
            cell.identifier = cellId
            cell.lineBreakMode = .byTruncatingTail
            cell.font = NSFont.systemFont(ofSize: 12)
        }
        
        switch column.identifier.rawValue {
        case "date":
            cell.stringValue = record.formattedDate
            cell.textColor = .labelColor
        case "auth":
            cell.stringValue = record.authMethod == "certificate" ? "证书" : "Token"
            cell.textColor = .labelColor
        case "env":
            cell.stringValue = record.environment == "development" ? "开发" : "生产"
            cell.textColor = .labelColor
        case "token":
            cell.stringValue = record.deviceToken
            cell.textColor = .labelColor
        case "payload":
            cell.stringValue = record.shortPayload
            cell.textColor = .labelColor
        case "result":
            cell.stringValue = record.isSuccess ? "成功" : "失败"
            cell.textColor = record.isSuccess ? .systemGreen : .systemRed
        default:
            cell.stringValue = ""
            cell.textColor = .labelColor
        }
        
        return cell
    }
}
