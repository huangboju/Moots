//
//  TableViewController.swift
//  CustomPaging
//
//  Created by Ilya Lobanov on 04/08/2018.
//  Copyright © 2018 Ilya Lobanov. All rights reserved.
//

import UIKit
import pop

final class CPTableViewController: UIViewController {

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table"
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Static.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Private
    
    private let tableView = UITableView()
    
    private let cellInfos: [TableCellInfo] = Static.makeCellInfos()
    
    private var anchors: [CGPoint] {
        return (0..<cellInfos.count).map {
            let inset = tableView.adjustedContentInset.top
            let cellsHeight = cellInfos.prefix($0).reduce(0, { $0 + $1.height })
            return CGPoint(x: 0, y: cellsHeight - inset)
        }
    }
    
    private var maxAnchor: CGPoint {
        let inset = tableView.adjustedContentInset.bottom
        return CGPoint(x: 0, y: tableView.contentSize.height - view.bounds.height + inset)
    }
    
    private func nearestAnchor(forContentOffset offset: CGPoint) -> CGPoint {
        var candidate = anchors.min(by: { abs($0.y - offset.y) < abs($1.y - offset.y) })!
        candidate.y = min(candidate.y, maxAnchor.y)
        return candidate
    }
    
    // MARK: - Private: Static
    
    private struct Static {
        
        static let minCellHeight: CGFloat = 128
        
        static let maxCellHeight: CGFloat = 384
        
        static let cellReuseIdentifier = "\(UITableViewCell.self)"
        
        static let cellColors: [UInt] = [0xB11F38, 0xE77A39, 0xEBD524, 0x4AA77A, 0x685B87, 0xA24C57]
        
        static func makeCellInfos() -> [TableCellInfo] {
            return (cellColors + cellColors + cellColors).map {
                TableCellInfo(text: String(format: "%06X", $0),
                    textColor: .white,
                    bgColor: UIColor(rgb: $0),
                    height: round(.random(in: minCellHeight...maxCellHeight)),
                    font: .systemFont(ofSize: 32, weight: .medium))
            }
        }

    }

}

extension CPTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.cellReuseIdentifier, for: indexPath)
        
        cell.update(with: cellInfos[indexPath.row])
        
        return cell
    }
    
}

extension CPTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellInfos[indexPath.row].height
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let decelerationRate = (UIScrollView.DecelerationRate.normal.rawValue + UIScrollView.DecelerationRate.fast.rawValue) / 2
        let offsetProjection = scrollView.contentOffset.project(initialVelocity: velocity, decelerationRate: decelerationRate)
        let targetAnchor = nearestAnchor(forContentOffset: offsetProjection)
        
        // Stop system animation
        targetContentOffset.pointee = scrollView.contentOffset
        
        scrollView.snapAnimated(toContentOffset: targetAnchor, velocity: velocity)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.stopSnappingAnimation()
    }
}

private extension UIScrollView {
    
    private static let snappingAnimationKey = "CustomPaging.TableViewController.scrollView.snappingAnimation"
    
    func snapAnimated(toContentOffset newOffset: CGPoint, velocity: CGPoint) {

        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
        animation.velocity = velocity
        animation.toValue = newOffset
        animation.fromValue = contentOffset

        pop_add(animation, forKey: UIScrollView.snappingAnimationKey)
    }
    
    func stopSnappingAnimation() {
        pop_removeAnimation(forKey: UIScrollView.snappingAnimationKey)
    }
    

}
