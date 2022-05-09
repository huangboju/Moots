//
//  ReloadableType.swift
//  Pagination
//
//  Created by 伯驹 黄 on 2016/10/18.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

protocol ReloadableType {
    func reloadData()
}

extension UITableView: ReloadableType {}
extension UICollectionView: ReloadableType {}
