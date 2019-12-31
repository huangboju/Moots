//
//  ClassCopyIvarListVC.swift
//  Lumia
//
//  Created by xiAo_Ju on 2019/12/31.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class ClassCopyIvarListVC: UIViewController {
    lazy var rows: [RowType] = [
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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: self.view.frame.width, height: 60)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FluidInterfacesCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fluid Interfaces"
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)

        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.visibleCells.forEach {
            $0.isHighlighted = false
        }
        
    }
}

extension ClassCopyIvarListVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        rows[indexPath.row].update(cell: cell)
        return cell
    }
}

extension ClassCopyIvarListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: Interface = rows[indexPath.row].cellItem()
        guard let segue = item.segue else { return }
        show(segue) { (vc: ClassCopyIvarDetailVC) in
            vc.className = item.name
        }
    }
}




class ClassCopyIvarDetailVC: UIViewController {
    
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

    lazy var rows: [RowType] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: self.view.frame.width, height: 60)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        collectionView.dataSource = self
        collectionView.register(FluidInterfacesCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fluid Interfaces"
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)

        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension ClassCopyIvarDetailVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        rows[indexPath.row].update(cell: cell)
        return cell
    }
}
