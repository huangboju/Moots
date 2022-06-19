//
//  TableDiffable.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2022/6/19.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

enum ContactSection: CaseIterable {
    case favourite
    case all
}

// MARK:- Item model

struct Contact: Hashable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
}

class TableDiffableVC: UIViewController {
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    
    let reuseIdentifier = "TableViewCell"
    
    private var dataSource: UITableViewDiffableDataSource<ContactSection, Contact>?
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        customiseTableview()
    }
    
    // MARK:- Custom methods

    /**Customise tableview */
    func customiseTableview() {
        title = NSLocalizedString("Contact list", comment: "Contact list screen title")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        createContactDataSource()
        updateTableViewModels()
    }
    
    /**Create mock data and update into tableview */
    func updateTableViewModels() {
        let model1 = Contact(id: 1, firstName: "Contact 1", lastName: "Contact 1", dateOfBirth: nil)
        let model2 = Contact(id: 2, firstName: "Contact 2", lastName: "Contact 2", dateOfBirth: nil)
        let model3 = Contact(id: 3, firstName: "Contact 3", lastName: "Contact 3", dateOfBirth: nil)
        let model4 = Contact(id: 4, firstName: "Contact 4", lastName: "Contact 4", dateOfBirth: nil)
        let model5 = Contact(id: 5, firstName: "Contact 5", lastName: "Contact 5", dateOfBirth: nil)
        let models =  [model1, model2, model3, model4, model5]
        update(models, animate: true)
    }
    
    /**Define diffable datasource for tableview with the help of cell provider and assign datasource to tablview */
    func createContactDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, contact in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = contact.firstName
            cell.detailTextLabel?.text = contact.lastName
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    /**Create an empty new snapshot and add contact into that and apply updated snapshot into tableview's datasource */
    func add(_ contact: Contact, animate: Bool = true) {
        guard let dataSource = self.dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<ContactSection, Contact>()
        snapshot.appendSections([ContactSection.all])
        snapshot.appendItems([contact], toSection: ContactSection.all)
        dataSource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    /**Update the contact list into current snapshot and apply updated snapshot into tableview's datasource */
    func update(_ contactList: [Contact], animate: Bool = true) {
        guard let dataSource = self.dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([ContactSection.all])
        snapshot.appendItems(contactList, toSection: ContactSection.all)
        dataSource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    /**Delete the contact from current snapshot and apply updated snapshot into tableview's datasource */
    func remove(_ contact: Contact, animate: Bool = true) {
        guard let dataSource = self.dataSource else { return }
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([contact])
        dataSource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }

}

// MARK:- UITableViewDelegate methods

extension TableDiffableVC: UITableViewDelegate {
    
    /**We can define delegate methods while using diffable datasource in tableview. For confirming that,I will just printed the sample text. */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell selected")
    }
    
}
