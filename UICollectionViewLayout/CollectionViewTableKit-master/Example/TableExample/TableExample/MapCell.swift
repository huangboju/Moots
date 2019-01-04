//
//  MapCell.swift
//  TableExample
//
//  Created by Malte Schonvogel on 25.05.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UICollectionViewCell, CollectionViewCell {

    typealias CellContent = (region: MKCoordinateRegion, coordinate: CLLocationCoordinate2D)

    var content: CellContent? {
        didSet {
            guard let content = content else { return }

            mapView.setRegion(content.region, animated: false)

            let annotation = MKPointAnnotation()
            annotation.coordinate = content.coordinate
            mapView.addAnnotation(annotation)
        }
    }

//    var location: CLLocation? {
//        didSet {
//            guard let location = location else { return }
//
//            let coordniateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//
//            mapView.setRegion(coordniateRegion, animated: false)
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location.coordinate
//            mapView.addAnnotation(annotation)
//        }
//    }

    private let mapView = MKMapView()

    override init(frame: CGRect) {

        super.init(frame: frame)

        contentView.backgroundColor = .white

        mapView.frame = contentView.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = false
        contentView.addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        mapView.removeAnnotations(mapView.annotations)
    }

    static func calculateHeight(content: (region: MKCoordinateRegion, coordinate: CLLocationCoordinate2D), forWidth width: CGFloat) -> CGFloat {

        return 250
    }
}
