//
//  SkuCell.swift
//  UIScrollViewDemo
//
//  Created by 黄渊 on 2022/10/28.
//  Copyright © 2022 伯驹 黄. All rights reserved.
//

import SnapKit

protocol SKUCellDelegate: AnyObject {
    func skuCellItemDidSelect(_ cell: SKUCell)
}

class SKUCell: UITableViewCell, Reusable {
    var cellModel: SKUCellModelPresenter?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(196)
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = VariantFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: SKUItemCell.self)
        collectionView.register(supplementaryViewType: SKUHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func item(at indexPath: IndexPath) -> SKUItemCellModel? {
        cellModel?.item(at: indexPath)
    }

    func section(at indexPath: IndexPath) -> SKUSectionModel? {
        cellModel?.section(at: indexPath)
    }

    var delegate: SKUCellDelegate? {
        self.viewController() as? SKUCellDelegate
    }
}

extension SKUCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellModel?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel?.sections[section].items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SKUItemCell = collectionView.dequeueReusableCell(for: indexPath, cellType: SKUItemCell.self)
        if let item = item(at: indexPath) {
            cell.update(viewData: item)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: SKUHeader.self)
        if let view = view as? SKUHeader {
            view.text = cellModel?.sections[indexPath.section].title
        }
        return view
    }
}

extension SKUCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = item(at: indexPath) else { return .zero }
        return item.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 32)
    }
}

extension SKUCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if item(at: indexPath)?.canSelected == false { return }
        cellModel?.didSelectItem(at: indexPath)
        delegate?.skuCellItemDidSelect(self)
        collectionView.reloadData()
    }
}

extension SKUCell: Updatable {
    func update(viewData: SKUCellModelPresenter) {
        cellModel = viewData
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(viewData.cellHeight)
        }
        collectionView.reloadData()
    }
}
