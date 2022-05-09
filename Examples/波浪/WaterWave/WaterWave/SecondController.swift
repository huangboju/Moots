//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "我是大波浪～"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2.0
        label.layer.cornerRadius = 8
        label.frame = CGRect(x: (screenWidth() * 0.5 - 100), y: 0, width: 200, height: 50)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        let waveView = WaveView(frame: CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: 20))
        
        waveView.closure = {centerY in
            label.frame.origin.y = waveView.frame.minY + centerY - 70
        }
        headerView.backgroundColor = UIColor.red
        headerView.addSubview(waveView)
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        
        waveView.startWave()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}
