//
//  MapViewModel.swift
//  TableExample
//
//  Created by Malte Schonvogel on 07.06.17.
//  Copyright © 2017 Malte Schonvogel. All rights reserved.
//

import UIKit
import MapKit

struct MapViewModel: CellRepresentable {

    private let location: CLLocation
    private let cellContent: MapCell.CellContent
    private let regionRadius: CLLocationDistance = 1000

    init(location: CLLocation) {

        self.location = location

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)

        self.cellContent = (region: region, location.coordinate)
    }

    func cellInstance(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.identifier, for: indexPath) as! MapCell
        cell.content = cellContent

        return cell
    }

    func itemHeight(forWidth width: CGFloat, indexPath: IndexPath) -> CGFloat {

        return 250
    }
}
