//
//  SkuVC.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import Foundation

final class SkuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // 强制设置为darkMode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadData()
    }

    func loadData() {
        DispatchQueue.global().async {
            guard let dataFilePath = Bundle.main.path(forResource: "variants", ofType: "json") else { return }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: dataFilePath))
                let model = try JSONDecoder().decode(GoodsModel.self, from: data)
                self.viewModel.updateRows(with: model)
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: SKUCell.self)
        tableView.register(cellType: GoodsInfoCell.self)
        tableView.dataSource = viewModel
        return tableView
    }()

    private lazy var viewModel: SkuViewModel = {
        SkuViewModel()
    }()
}

extension SkuVC: SKUCellDelegate {
    func skuCellItemDidSelect(_ cell: SKUCell) {
        guard let goodsModel = cell.cellModel?.selectedGoods else { return }
        viewModel.refreshInfoRow(with: goodsModel)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}
