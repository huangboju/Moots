//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit

class ThirdController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 57 / 255, green: 67 / 255, blue: 89 / 255, alpha: 1)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.hh_addRefreshViewWithAction { 
            
        }
        tableView.hh_setRefreshViewTopWaveFill(color: UIColor.red)
        tableView.hh_setRefreshViewBottomWaveFill(color: UIColor.blue)
        view.addSubview(tableView)
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ThirdController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}
