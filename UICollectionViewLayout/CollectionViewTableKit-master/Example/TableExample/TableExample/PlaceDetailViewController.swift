//
//  PlaceDetailViewController.swift
//  TableExample
//
//  Created by Malte Schonvogel on 23.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import MapKit
import CollectionViewTableKit

private let headerHeight: CGFloat = 320

class PlaceDetailViewController: UIViewController {

    fileprivate let topHeaderView = TopHeaderView()

    fileprivate let collectionView: UICollectionView

    fileprivate let layout = TableFlowLayout()

    fileprivate let place: Place

    fileprivate var sections: [ManageableSection]

    required init(place: Place = .hardcodedPlace) {

        self.sections = [
            TopActionsSectionManager(title: nil, items: [
                .save,
                .checkIn,
                .rate,
                .share
                ].map(TopActionViewModel.init)
            ),
            MapSectionManager(title: nil, items: [
                MapViewModel(location: place.location)
                ]
            ),
            PlaceActionsSectionManager(title: nil, items: [
                .address(place.address),
                .call(place.phoneNumber),
                .openWebsite(place.webUrl),
                .moreInfo
                ].map(PlaceActionViewModel.init)
            ),
            GallerySectionManager(title: "Photos", items: [
                GalleryViewModel(images: place.images)
                ]
            ),
            ReviewSectionManager(title: "User's reviews", items: place.reviews.map(ReviewViewModel.init)),
        ]

        self.place = place

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        layout.collectionViewHeaderHeight = headerHeight
        layout.sectionBorderColor = .lightBorder
        layout.sectionBorderWidth = CGFloat(1) / UIScreen.main.scale

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.backgroundColor = .offWhite

        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.viewReuseIdentifer)

        collectionView.register(IconActionCell.self, forCellWithReuseIdentifier: IconActionCell.identifier)
        collectionView.register(IconTableCell.self, forCellWithReuseIdentifier: IconTableCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: MapCell.identifier)
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        var viewsDict = [String: UIView]()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        viewsDict["collectionView"] = collectionView
        view.addSubview(collectionView)

        topHeaderView.image = place.cover
        collectionView.addSubview(topHeaderView)

        let constraints = [
            "H:|[collectionView]|",
            "V:|[collectionView]|",
            ].flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: viewsDict)
        }

        NSLayoutConstraint.activate(constraints)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        topHeaderView.frame.size = CGSize(width: collectionView.bounds.width, height: headerHeight - collectionView.contentOffset.y)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent
    }
}


extension PlaceDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        return false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard scrollView.contentOffset.y < headerHeight else { return }

        topHeaderView.frame.origin.y = scrollView.contentOffset.y
        topHeaderView.frame.size.height = headerHeight - scrollView.contentOffset.y
    }
}


extension PlaceDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return sections[indexPath.section].cellInstance(collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            assertionFailure()
            return UICollectionReusableView()
        }

        return sections[indexPath.section].headerInstance(collectionView, indexPath: indexPath)
    }
}


extension PlaceDetailViewController: TableFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsForSectionAtIndex section: Int) -> Int {

        switch sections[section] {
        case is TopActionsSectionManager:
            return 4
        case is ReviewSectionManager where isIpad:
            return 2
        case is PlaceActionsSectionManager where isIpad:
            return 2
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        switch sections[section] {
        case is MapSectionManager, is PlaceActionsSectionManager:
            return UIEdgeInsets(top: spacing, left: 0, bottom: 0, right: 0)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAtIndexPath indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {

        return sections[indexPath.section].itemHeight(forWidth: itemWidth, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = collectionView.bounds.width
        let height = sections[section].headerHeight(forWidth: width)

        return CGSize(width: width, height: height)
    }
}
