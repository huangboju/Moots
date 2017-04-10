//
//  MainViewController.swift
//  ClassCopyIvarList
//
//  Created by star on 16/5/12.
//  Copyright © 2016年 Zezefamily. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var classArray = [
        "UITextField",
        "UISlider",
        "UIImageView",
        "UITabBarItem",
        "UIActivityIndicatorView",
        "UIBarButtonItem",
        "UILabel",
        "UINavigationBar",
        "UIProgressView",
        "UIAlertAction",
        "UIViewController",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.setValue(UIColor.red, forKey: "color")
        activity.setValue(50, forKey: "width")
        view.addSubview(activity)

        activity.center = view.center

        activity.startAnimating()
    }

    fileprivate func loadUI() {
        title = "UIKit"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailvc") as? DetailViewController
        detailVC?.className = classArray[indexPath.row]
        navigationController?.pushViewController(detailVC!, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath)
        cell.textLabel?.text = classArray[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return classArray.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
