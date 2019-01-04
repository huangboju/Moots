//
//  TableCollectionViewController.swift
//
//  Created by Malte Schonvogel on 5/10/17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit

open class TableCollectionViewController<T: TableCollectionViewSection>: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TableFlowLayoutDelegate {

    public let collectionView: UICollectionView

    public let layout = TableFlowLayout()

    public var sections = [T]()

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hue:0.08, saturation:0.01, brightness:0.97, alpha:1.00)
        collectionView.delaysContentTouches = false
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {

        super.viewDidLoad()

        addSubviewsAndAddConstraints()
    }

    public func addSubviewsAndAddConstraints() {

        var viewsDict = [String: Any]()

        viewsDict["collectionView"] = collectionView
        view.addSubview(collectionView)

        let constraints = [
            "H:|[collectionView]|",
            "V:|[collectionView]|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: viewsDict)
        }

        NSLayoutConstraint.activate(constraints)
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)

        view.setNeedsUpdateConstraints()
    }

    override open func updateViewConstraints() {

        super.updateViewConstraints()

        layout.invalidateLayout()
    }


    // MARK: UICollectionViewDelegate

    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {

        let section = sections[indexPath.section]

        return action == #selector(copy(_:)) && section.stringToCopy != nil
    }

    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

        let section = sections[indexPath.section]

        guard action == #selector(copy(_:)), let stringToCopy = section.stringToCopy else {
            return
        }

        UIPasteboard.general.string = stringToCopy
    }

    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        return sections[indexPath.section].shouldSelectItems
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {

        return sections[indexPath.section].shouldSelectItems
    }


    // MARK: UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {

        return sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return sections[section].numberOfItems
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        assertionFailure("Method needs to be overridden")
        return UICollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        assertionFailure("Method needs to be overridden")
        return UICollectionReusableView()
    }


    // MARK: TableFlowLayoutDelegate

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsForSectionAtIndex section: Int) -> Int {

        return sections[section].colsPerRow
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sections[section].sectionInset
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, borderWidthForSectionAtIndex section: Int) -> CGFloat {

        return sections[section].sectionBorderWidth
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, borderColorForSectionAtIndex section: Int) -> UIColor {

        return sections[section].borderColor
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sections[section].minimumLineSpacing
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return sections[section].minimumInteritemSpacing
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: sections[section].heightForHeader(viewWidth: collectionView.frame.width))
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: sections[section].footerHeight)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForRowInSectionAtIndex section: Int) -> CGFloat {
        return sections[section].rowHeight
    }
}
