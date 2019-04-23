/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom view flow layout for single column or multiple columns.
*/

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {

    private let minColumnWidth: CGFloat = 300.0
    private let cellHeight: CGFloat = 70.0
    
    private var deletingIndexPaths = [IndexPath]()
    private var insertingIndexPaths = [IndexPath]()

    // MARK: Layout Overrides

    /// - Tag: ColumnFlowExample
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromSafeArea
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: Attributes for Updated Items
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        
        if !deletingIndexPaths.isEmpty {
            if deletingIndexPaths.contains(itemIndexPath) {
                
                attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                attributes.alpha = 0.0
                attributes.zIndex = 0
            }
        }
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            attributes.alpha = 0.0
            attributes.zIndex = 0
        }
        
        return attributes
    }
    
    // MARK: Updates
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for update in updateItems {
            switch update.updateAction {
            case .delete:
                guard let indexPath = update.indexPathBeforeUpdate else { return }
                deletingIndexPaths.append(indexPath)
            case .insert:
                guard let indexPath = update.indexPathAfterUpdate else { return }
                insertingIndexPaths.append(indexPath)
            default:
                break
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        deletingIndexPaths.removeAll()
        insertingIndexPaths.removeAll()
    }
}
