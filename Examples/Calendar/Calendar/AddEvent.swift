//
//  AddEvent.swift
//  Form
//
//  Created by 伯驹 黄 on 16/6/1.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class AddEvent: UITableViewController {
    
    private lazy var titles = [String]()
    private lazy var eventTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0..<20 {
            
            titles.append("票据宝\(arc4random() % 10000)")
        }
        
        navigationItem.title = "Add Event"
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell_id")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = "\(indexPath.row)分钟后提醒"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        let notes = title + "产品的还款" +
            "\(arc4random() % 1000)元" + "将于今天转入您的账户，请注意查收"
        let minutes = Double(indexPath.row * 60)
        let date = Date().addingTimeInterval(minutes)
        
        EventManger.shared.createEvent(title: title, notes: notes, startDate: date, titleType: .repayment, handle: { [weak self] success, error in
            guard let strongSelf = self else { return }
            strongSelf.navigationItem.prompt = success ? "成功添加" + title : "添加失败"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                strongSelf.navigationItem.prompt = nil
            })
        })
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
