# Customizing Collection View Layouts

Customize a view layout by changing the size of cells in the flow or implementing a mosaic style.

## Overview

To lay out UICollectionView cells in a simple grid, you can use [`UICollectionViewFlowLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout) directly. For more flexibility, you can subclass [`UICollectionViewLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout) to create advanced layouts.

This sample app demonstrates two custom layout subclasses:

* `ColumnFlowLayout` — A `UICollectionViewFlowLayout` subclass that arranges cells in a list format for narrow screens, or as a grid for wider screens. See "For a Simple Grid, Size Cells Dynamically," below.

* `MosaicLayout` — A `UICollectionViewLayout` subclass that lays out cells in a mosaic-style, nonconforming grid. See "For a Complex Grid, Define Cell Sizes Explicitly," below.

The app opens to the Friends view controller, which uses a column flow layout to display a list of people. Tapping any cell takes you to the Feed view controller, which uses a mosaic layout to display photos from the user's photo library.

Tapping the cloud icon to the right of the navigation bar demonstrates batched animations for inserting, deleting, moving, and reloading items in the collection view. For more information, see "Perform Batch Updates," below. Using pull-to-refresh on the collection view resets the data.

## For a Simple Grid, Size Cells Dynamically

`ColumnFlowLayout` is a subclass of [`UICollectionViewFlowLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout) that uses the size of the collection view to determine the width of its cells. If only one cell will fit comfortably horizontally, the cells are arranged to occupy the entire width of the collection view. Otherwise, multiple columns of cells are displayed with a fixed width. 

In practice, on iPhone devices in portrait mode, `ColumnFlowLayout` displays a single vertical column of cells. In landscape mode, or on an iPad, it displays a grid layout.

Use the [`prepare`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617752-prepare) function to compute the available screen width of the device and set the [`itemSize`](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout/1617711-itemsize) property accordingly.

``` swift
override func prepare() {
    super.prepare()

    guard let collectionView = collectionView else { return }
    
    let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
    let maxNumColumns = Int(availableWidth / minColumnWidth)
    let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
    
    self.itemSize = CGSize(width: cellWidth, height: cellHeight)
    self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
    self.sectionInsetReference = .fromSafeArea
}
```
[View in Source](x-source-tag://ColumnFlowExample)

## For a Complex Grid, Define Cell Sizes Explicitly

If you need more customization than is possible with a subclass of [`UICollectionViewFlowLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout), subclass [`UICollectionViewLayout`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout) instead. 

`MosaicLayout` is a `UICollectionViewLayout` subclass that displays an arbitrary number of cells with differing sizes and aspect ratios. It's used by `FeedViewController` to display images from the user's photo library. Cells are organized into rows in one of four styles, from a single cell to multiple cells in varying layouts.

![Images showing a row of four rectangles, each representing a mosaic style. On the left, a single cell. Second from left, two equal-size cells. Third from left, one cell occupying two-thirds of the area, and two stacked cells to the left of the larger cell. Last, one cell occupying two-thirds of the area, and two stacked cells to the right of the larger cell.](Documentation/CellLayouts.png)

**Calculate Cell Dimensions**

The [`prepare`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617752-prepare) method is called whenever a layout is invalidated. Override this method to calculate the position and size of every cell, as well as the total dimensions for the entire layout. 

``` swift
override func prepare() {
    super.prepare()
    
    guard let collectionView = collectionView else { return }

    // Reset cached information.
    cachedAttributes.removeAll()
    contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
    
    // For every item in the collection view:
    //  - Prepare the attributes.
    //  - Store attributes in the cachedAttributes array.
    //  - Combine contentBounds with attributes.frame.
    let count = collectionView.numberOfItems(inSection: 0)
    
    var currentIndex = 0
    var segment: MosaicSegmentStyle = .fullWidth
    var lastFrame: CGRect = .zero
    
    let cvWidth = collectionView.bounds.size.width
    
    while currentIndex < count {
        let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: 200.0)
        
        var segmentRects = [CGRect]()
        switch segment {
        case .fullWidth:
            segmentRects = [segmentFrame]
            
        case .fiftyFifty:
            let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
            segmentRects = [horizontalSlices.first, horizontalSlices.second]
            
        case .twoThirdsOneThird:
            let horizontalSlices = segmentFrame.dividedIntegral(fraction: (2.0 / 3.0), from: .minXEdge)
            let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
            segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]
            
        case .oneThirdTwoThirds:
            let horizontalSlices = segmentFrame.dividedIntegral(fraction: (1.0 / 3.0), from: .minXEdge)
            let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
            segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
        }
        
        // Create and cache layout attributes for calculated frames.
        for rect in segmentRects {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
            attributes.frame = rect
            
            cachedAttributes.append(attributes)
            contentBounds = contentBounds.union(lastFrame)
            
            currentIndex += 1
            lastFrame = rect
        }

        // Determine the next segment style.
        switch count - currentIndex {
        case 1:
            segment = .fullWidth
        case 2:
            segment = .fiftyFifty
        default:
            switch segment {
            case .fullWidth:
                segment = .fiftyFifty
            case .fiftyFifty:
                segment = .twoThirdsOneThird
            case .twoThirdsOneThird:
                segment = .oneThirdTwoThirds
            case .oneThirdTwoThirds:
                segment = .fiftyFifty
            }
        }
    }
}
```
[View in Source](x-source-tag://PrepareMosaicLayout)

**Provide the Content Size**

Override the [`collectionViewContentSize`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617796-collectionviewcontentsize) property, providing a size for the collection view. 

``` swift
override var collectionViewContentSize: CGSize {
    return contentBounds.size
}
```
[View in Source](x-source-tag://CollectionViewContentSize)

**Define the Layout Attributes**

Override [`layoutAttributesForElements(in:)`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617769-layoutattributesforelements), defining the layout attributes for a geometric region. The collection view calls this function periodically to display items, which is known as *querying by geometric region*.

``` swift
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    // Find any cell that sits within the query rect.
    guard let lastIndex = cachedAttributes.indices.last,
          let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
    
    // Starting from the match, loop up and down through the array until all the attributes
    // have been added within the query rect.
    for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
        guard attributes.frame.maxY >= rect.minY else { break }
        attributesArray.append(attributes)
    }
    
    for attributes in cachedAttributes[firstMatchIndex...] {
        guard attributes.frame.minY <= rect.maxY else { break }
        attributesArray.append(attributes)
    }
    
    return attributesArray
}
```
[View in Source](x-source-tag://LayoutAttributesForElements)

Also provide the layout attributes for a specific item by implementing [`layoutAttributesForItem(at:)`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617797-layoutattributesforitem). The collection view calls this function periodically to display one particular item, which is known as *querying by index path*.
	
``` swift
override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cachedAttributes[indexPath.item]
}
```
[View in Source](x-source-tag://LayoutAttributesForItem)

> Because these functions are called often, they can affect the performance of your app. To make them as efficient as possible, follow the example code as closely as you can.

**Handle Bounds Changes**

The [`shouldInvalidateLayout(forBoundsChange:)`](https://developer.apple.com/documentation/appkit/nscollectionviewlayout/1531047-shouldinvalidatelayout) function is called for every bounds change from the collection view, or whenever its size or origin changes. This function is also called frequently during scrolling. The default implementation returns `false`, or, if the size and origin change, it returns `true`.

``` swift
override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let collectionView = collectionView else { return false }
    return !newBounds.size.equalTo(collectionView.bounds.size)
}
```
[View in Source](x-source-tag://ShouldInvalidateLayout)

For optimum performance, this sample performs a binary search inside [`layoutAttributesForElements(in:)`](https://developer.apple.com/documentation/uikit/uicollectionviewlayout/1617769-layoutattributesforelements) instead of a linear search of the attributes it needs for each element in a given bounds area.

## Perform Batch Updates

Tapping the top-right button in the navigation bar triggers the collection view to perform a *batch update* of multiple animated operations (insert, delete, move, and reload) of its collection view cells all at the same time.

Within a call to [`performBatchUpdates()`](https://developer.apple.com/documentation/uikit/uicollectionview/1618045-performbatchupdates), all insert, delete, move, and reload operations are animated simultaneously. In this sample, batch updates are made by processing an array of `PersonUpdate` objects, each of which encapsulates one update:

* `insert` with a `Person` object and insertion index.
* `delete` with an index.
* `move` from one index to another.
* `reload` with an index.

First, the `reload` operations are performed without animation because no cell movement is involved:

``` swift
// Perform any cell reloads without animation because there is no movement.
UIView.performWithoutAnimation {
    collectionView.performBatchUpdates({
        for update in remoteUpdates {
            if case let .reload(index) = update {
                people[index].isUpdated = true
                collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    })
}
```
[View in Source](x-source-tag://PerformUpdates)

Next, the remaining operations are animated:

``` swift
// Animate all other update types together.
collectionView.performBatchUpdates({
    var deletes = [Int]()
    var inserts = [(person:Person, index:Int)]()

    for update in remoteUpdates {
        switch update {
        case let .delete(index):
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            deletes.append(index)
            
        case let .insert(person, index):
            collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            inserts.append((person, index))
            
        case let .move(fromIndex, toIndex):
            // Updates that move a person are split into an addition and a deletion.
            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                    to: IndexPath(item: toIndex, section: 0))
            deletes.append(fromIndex)
            inserts.append((people[fromIndex], toIndex))
            
        default: break
        }
    }
    
    // Apply deletions in descending order.
    for deletedIndex in deletes.sorted().reversed() {
        people.remove(at: deletedIndex)
    }
    
    // Apply insertions in ascending order.
    let sortedInserts = inserts.sorted(by: { (personA, personB) -> Bool in
        return personA.index <= personB.index
    })
    for insertion in sortedInserts {
        people.insert(insertion.person, at: insertion.index)
    }
    
    // The update button is enabled only if the list still has people in it.
    navigationItem.rightBarButtonItem?.isEnabled = !people.isEmpty
})
```
[View in Source](x-source-tag://PerformUpdates)


