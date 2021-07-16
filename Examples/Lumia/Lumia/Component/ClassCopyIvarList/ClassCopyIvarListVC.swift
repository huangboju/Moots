//
//  ClassCopyIvarListVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class ClassCopyIvarListVC: ListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "属性查看器"

        rows = [
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIPickerView", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIDatePicker", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UITextField", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UISlider", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIImageView", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UITabBarItem", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIActivityIndicatorView", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIBarButtonItem", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UILabel", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UINavigationBar", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIProgressView", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIAlertAction", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIViewController", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIRefreshControl", segue: .segue(ClassCopyIvarDetailVC.self))),
            Row<FluidInterfacesCell>(viewData: Interface(name: "UIAlertController", segue: .segue(ClassCopyIvarDetailVC.self))),
        ]
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: Interface = rows[indexPath.row].cellItem()
        guard let segue = item.segue else { return }
        show(segue) { (vc: ClassCopyIvarDetailVC) in
            vc.className = item.name
        }
    }
}


class ClassCopyIvarDetailVC: ListVC {
    
    var className: String? {
        didSet {
            title = className
            if let v = className {
                rows = classCopyIvarList(v)
            }
        }
    }
    
    // MARK: 查看类中的隐藏属性
    fileprivate func classCopyIvarList(_ className: String) -> [RowType] {

        var classArray: [RowType] = []

        let classOjbect: AnyClass! = objc_getClass(className) as? AnyClass

        var icount: CUnsignedInt = 0

        let ivars = class_copyIvarList(classOjbect, &icount)
        print("icount == \(icount)")

        for i in 0 ... (icount - 1) {
            let memberName = String(utf8String: ivar_getName((ivars?[Int(i)])!)!) ?? ""
            print("memberName == \(memberName)")
            classArray.append(Row<FluidInterfacesCell>(viewData: Interface(name: memberName)))
        }

        return classArray
    }
}
