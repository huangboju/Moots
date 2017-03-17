//
//  SettingController.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/23.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SafariServices

class SettingCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.sizeToFit()
        let size = textLabel?.frame.size ?? .zero
        textLabel?.frame.origin =  CGPoint(x: (Constants.screenW - size.width) / 2, y: (frame.height - size.height) / 2)
    }
}

class SettingController: UITableViewController {

    private lazy var qrcodeImageView: UIImageView = {
        let qrcodeImageView = UIImageView()
        qrcodeImageView.translatesAutoresizingMaskIntoConstraints = false
        return qrcodeImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        
        tableView.backgroundColor = Constants.backgroundColor

        title = "设置"

        tableView.register(SettingCell.self, forCellReuseIdentifier: "cell")
        
        tableView.addSubview(qrcodeImageView)
        

        let top = NSLayoutConstraint(item: qrcodeImageView, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 25)
        
        let centerX = NSLayoutConstraint(item: qrcodeImageView, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0)
        qrcodeImageView.superview?.addConstraints([top, centerX])
        
        prepareQrcodeImageView()
    }
    
    func  prepareQrcodeImageView() {
        

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(string: "https://www.pgyer.com/app/qrcode/duanzi")!)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.qrcodeImageView.image = image
                }
            } catch let error {
                print("获取二维码失败", error)
            }
            
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.text = "更新"
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = Constants.textColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if #available(iOS 9.0, *) {
            let controller = SFSafariViewController(url: URL(string: "https://www.pgyer.com/duanzi")!)
            present(controller, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
