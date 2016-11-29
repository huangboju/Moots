//
//  NextPageLoadable.swift
//  Pagination
//
//  Created by 伯驹 黄 on 2016/10/18.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

import UIKit

protocol NextPageLoadable: class {
    associatedtype DataType
    associatedtype LastIdType
    
    var data: [DataType] { set get }
    var nextPageState: NextPageState<LastIdType> { set get }
    
    func performLoad(successHandler: (_ rows: [DataType], _ hasNext: Bool, _ lastId: LastIdType?) -> (), failHandler: () -> ())
}

extension NextPageLoadable {
    func loadNext(view: ReloadableType) {
        guard nextPageState.hasNext else { return }
        if nextPageState.isLoading { return }
        nextPageState.isLoading = true
        print("loadNext(view: ReloadableType)")
        performLoad(successHandler: { rows, hasNext, lastId in
            self.data += rows
            self.nextPageState.update(hasNext: hasNext, isLoading: false, lastId: lastId)
            view.reloadData()
            }, failHandler: {
                //..
        })
    }
}

extension NextPageLoadable where Self: UITableViewController {
    func loadNext() {
        print("loadNext")
        loadNext(view: tableView)
    }
}

extension NextPageLoadable where Self: UICollectionViewController {
    func loadNext() {
        loadNext(view: collectionView!)
    }
}
