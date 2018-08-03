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

    var className: String?
    var classArr: [String] {
        return classCopyIvarList(className!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUI()
    }

    fileprivate func loadUI() {

        title = className
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let property = classArr[indexPath.row]
        cell.textLabel?.text = property
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return classCopyIvarList(className!).count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: 查看类中的隐藏属性
    fileprivate func classCopyIvarList(_ className: String) -> [String] {

        var classArray: [String] = []

        let classOjbect: AnyClass! = objc_getClass(className) as? AnyClass

        var icount: CUnsignedInt = 0

        let ivars = class_copyIvarList(classOjbect, &icount)
        print("icount == \(icount)")

        for i in 0 ... (icount - 1) {
            let memberName = String(utf8String: ivar_getName((ivars?[Int(i)])!)!) ?? ""
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
