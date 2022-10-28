//
//  GroupTableDetail.swift
//  ExampleApp
//
//  Created by 黄伯驹 on 2017/11/2.
//  Copyright © 2017年 Arkadiusz Holko. All rights reserved.
//

import UIKit

class GroupTableController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var oldBottomInset: CGFloat?
    
    private var tap: UITapGestureRecognizer?

    var rows: [[RowType]] = [] {
        didSet {
            registerCells()
        }
    }

    final override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self

        addObserver(with: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification)
        addObserver(with: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification)

        initSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    open func initSubviews() {}

    final func row(at indexPath: IndexPath) -> RowType {
        return rows[indexPath.section][indexPath.row]
    }

//    final var tags: Set<String> {
//        let _tags = rows.flatMap { $0 }.map { $0.tag }
//        return Set(_tags)
//    }
//
//    final func cellBy<T: UITableViewCell>(tag: String) -> T {
//        for section in rows {
//            for row in section where row.tag == tag {
//                guard let cell = row.cell() as? T else {
//                    fatalError("cell不存在")
//                }
//                return cell
//            }
//        }
//        fatalError("cell不存在")
//    }

    final func tableHeaderView<T: UIView>() -> T? {
        guard let headerView = tableView.tableHeaderView as? T else {
            return nil
        }
        return headerView
    }

    final func tableFooterView<T: UIView>() -> T? {
        guard let footerView = tableView.tableFooterView as? T else {
            return nil
        }
        return footerView
    }

    private func registerCells() {
        rows.flatMap { $0 }.forEach { tableView.register($0.cellClass, forCellReuseIdentifier: $0.reuseIdentifier) }
    }
}

extension GroupTableController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfigurator = row(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.reuseIdentifier, for: indexPath)
        cellConfigurator.update(cell: cell)
        return cell
    }
}

extension GroupTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK - Keyboard
extension GroupTableController {
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tableView.addGestureRecognizer(tap!)

        let keyBoardInfo = notification.userInfo!
        let endFrame = keyBoardInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        let keyBoardFrame = tableView.window!.convert(endFrame.cgRectValue, to: tableView.superview)
        let newBottomInset = tableView.frame.minY + tableView.frame.height - keyBoardFrame.minY
        var tableInsets = tableView.contentInset
        var scrollIndicatorInsets = tableView.scrollIndicatorInsets
        oldBottomInset = oldBottomInset ?? tableInsets.bottom
        if newBottomInset > oldBottomInset! {
            tableInsets.bottom = newBottomInset
            scrollIndicatorInsets.bottom = tableInsets.bottom
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration((keyBoardInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double))
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: (keyBoardInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int))!)
            tableView.contentInset = tableInsets
            tableView.scrollIndicatorInsets = scrollIndicatorInsets
            UIView.commitAnimations()
        }
    }

    @objc
    private func keyboardDidHide(_ notification: NSNotification) {
        
        if let tap = tap {
            tableView.removeGestureRecognizer(tap)
        }

        guard let oldBottom = oldBottomInset else { return }
        let keyBoardInfo = notification.userInfo!
        var tableInsets = tableView.contentInset
        var scrollIndicatorInsets = tableView.scrollIndicatorInsets
        tableInsets.bottom = oldBottom
        scrollIndicatorInsets.bottom = tableInsets.bottom
        oldBottomInset = nil
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration((keyBoardInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double))
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: (keyBoardInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int))!)
        tableView.contentInset = tableInsets
        tableView.scrollIndicatorInsets = scrollIndicatorInsets
        UIView.commitAnimations()
    }

    @objc
    private func tapGesture(_ sender: UITapGestureRecognizer) {
        tableView.removeGestureRecognizer(sender)
        view.endEditing(true)
    }
}
