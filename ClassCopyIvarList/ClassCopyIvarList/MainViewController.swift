//
//  MainViewController.swift
//  ClassCopyIvarList
//
//  Created by star on 16/5/12.
//  Copyright © 2016年 Zezefamily. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var classArray = ["UITextField","UISlider","UIImageView","UITabBarItem","UIActivityIndicatorView","UIBarButtonItem","UILabel","UINavigationBar","UIProgressView","UIAlertAction"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activity.setValue(UIColor.redColor(), forKey: "color")
        activity.setValue(50, forKey: "width")
        self.view.addSubview(activity)
        
        activity.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        activity.startAnimating()
        
    }

    private func loadUI() {
        
        self.title = "UIKit"
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("detailvc") as? DetailViewController
        detailVC?.className = classArray[indexPath.row]
        navigationController?.pushViewController(detailVC!, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath)
        cell.textLabel?.text = classArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
