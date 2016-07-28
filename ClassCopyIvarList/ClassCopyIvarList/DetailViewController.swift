//
//  DetailViewController.swift
//  ClassCopyIvarList
//
//  Created by star on 16/5/12.
//  Copyright © 2016年 Zezefamily. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var className:String?
    var classArr:Array<NSString>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUI()
        
    }
    
    private func loadUI() {
        
        self.title = "\(self.className)"
        self.classArr = classCopyIvarList(self.className!)
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
        let property = self.classArr![indexPath.row]
        cell.textLabel?.text = property as String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classCopyIvarList(self.className!).count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:查看类中的隐藏属性
    private func classCopyIvarList(className:String) -> Array<NSString> {
        
        var classArray = [NSString]()
        
        let classOjbect:AnyClass! = objc_getClass(className) as?AnyClass
        
        var icount: CUnsignedInt = 0
        
        let ivars = class_copyIvarList(classOjbect, &icount)
        print("icount == \(icount)")
        
        for i in 0...(icount-1) {
            
            let memberName = NSString(UTF8String: ivar_getName(ivars[Int(i)]))
            print("memberName == \(memberName)")
            classArray.append(memberName!)
            
        }
        
        return classArray
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
