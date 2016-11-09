//
//  EventList.swift
//  Form
//
//  Created by 伯驹 黄 on 16/5/27.
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import EventKit
import UIKit

class EventList: UIViewController {
    
    fileprivate lazy var data: [[EKEvent]] = [[]]
    private lazy var segmentedControl: HMSegmentedControl = {
        let titles = ["今天", "本周", "本月", "今年"]
        let segmentedControl = HMSegmentedControl(sectionTitles: titles)
        segmentedControl?.selectionIndicatorColor = .blue
        segmentedControl?.selectionIndicatorHeight = 2
        segmentedControl?.selectionIndicatorLocation = .down
        segmentedControl?.selectionStyle = .fullWidthStripe
        segmentedControl?.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.blue]
        segmentedControl?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.darkText, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
        segmentedControl?.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 44)
        return segmentedControl!
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 108, width: self.view.frame.width, height: self.view.frame.height - 108))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = classForCoder.description()
        view.backgroundColor = UIColor.white
        segmentedControl.indexChangeBlock = { [unowned self] index in
            let events = EventManger.shared.getEvents(EventDateType(rawValue: index)!)
            self.createData(events)
        }
        view.addSubview(segmentedControl)
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)

        separatorInset1()

        createData(EventManger.shared.getEvents())
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
    }
    
    //分割线到头
    func separatorInset1() {
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = .zero
        }
        if tableView.responds(to: #selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = .zero
        }
    }
    
    func createData(_ events: [EKEvent]) {
        navigationItem.showTitleView(text: "Loading")
        DispatchQueue.global().async {
            var alarmEvents: [EKEvent] = []
            var systemEvents: [EKEvent] = []
            for event in events {
                if event.isAllDay {
                    systemEvents.append(event)
                    
                } else {
                    alarmEvents.append(event)
                }
            }
            self.data = [alarmEvents, systemEvents]
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                self.navigationItem.hideTitleView()
            }
        }
    }

    func addEvent() {
        let controller = UINavigationController(rootViewController: AddEvent())
        present(controller, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EventList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ?  "非系统" : "系统"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension EventList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row]
        let interval = item.endDate.timeIntervalSinceReferenceDate
        let url = URL(string: "calshow:\(interval)")!
        UIApplication.shared.openURL(url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            EventManger.shared.remove(data[indexPath.section][indexPath.row])
            data[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        let item = data[indexPath.section][indexPath.row]

        cell.accessoryType = item.hasAlarms ? .checkmark : .none
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "提醒时间" + item.endDate.format(with: "yyyy-MM-dd HH:mm:ss")!
    }
}
