//
//  VCollectionViewGridLayout.m
//
//  This software is licensed under the Apache 2 license, quoted below.
//
//  Copyright (C) 2012-2014 Vast.com, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License. You may obtain a copy of
//  the License at
//
//  [http://www.apache.org/licenses/LICENSE-2.0]
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
//  License for the specific language governing permissions and limitations under
//  the License.

#import "VCollectionViewGridLayout.h"
#import <TLIndexPathTools/TLIndexPathItem.h>
#import <TLIndexPathTools/TLIndexPathSectionInfo.h>
#import <TLIndexPathTools/TLIndexPathUpdates.h>
#import <CoreData/CoreData.h>

NSString *const VCollectionViewGridLayoutElementKindSectionHeader = @"VCollectionViewGridLayoutElementKindSectionHeader";

@interface VCollectionViewDataModel : TLIndexPathDataModel
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGRect bufferRect;
@property (strong, nonatomic) NSArray *headerPoses;
@end

typedef enum {
    VCollectionViewChangeTypeNone,
    VCollectionViewChangeTypeInsert,
    VCollectionViewChangeTypeDelete,
    VCollectionViewChangeTypeMoveWithinBuffer,
    VCollectionViewChangeTypeMoveIntoBuffer,
    VCollectionViewChangeTypeMoveOutOfBuffer,
} VCollectionViewChangeType;

@interface VCollectionViewGridLayout ()
@property (weak, nonatomic, readonly) id<VCollectionViewGridLayoutDelegate>delegate;
@property (strong, nonatomic) VCollectionViewDataModel *dataModel;
@property (strong, nonatomic) VCollectionViewDataModel *oldDataModel;
@property (strong, nonatomic) TLIndexPathUpdates *dataModelUpdates;
@property (nonatomic) BOOL invalidatedForStickyHeader;
@property (strong, nonatomic) UICollectionViewLayoutAttributes *stickyPose;
@property (nonatomic) CGRect originalStickyPoseFrame;
@end

@implementation VCollectionViewGridLayout

//- (void)clearState
//{
//    _dataModel = nil;
//    _oldDataModel = nil;
//    _dataModelUpdates = nil;
//}

#pragma mark - Configure layout

- (NSInteger)numberOfColumns
{
    return _numberOfColumns > 0 ? _numberOfColumns : 1;
}

#pragma mark - 

- (id<VCollectionViewGridLayoutDelegate>)delegate
{
    return (id<VCollectionViewGridLayoutDelegate>)self.collectionView.delegate;
}

#pragma mark - Data model

- (VCollectionViewDataModel *)dataModel
{
    if (!_dataModel) {
        NSMutableArray *sectionInfos = [[NSMutableArray alloc] init];
        NSMutableArray *headerPoses = [[NSMutableArray alloc] init];
        UIEdgeInsets inset = self.sectionInset;
        UIEdgeInsets contentInset = self.sectionContentInset;
        NSInteger sectionCount = [self.collectionView numberOfSections];
        CGRect rectangularHull = CGRectMake(0, 0, 0, 0);
        CGFloat width = self.collectionView.bounds.size.width;
        //TODO eliminate dependency on itemSize property by supporting multiple cell widths
        CGFloat firstXCenter = inset.left + contentInset.left + self.itemSize.width / 2.0;
        CGFloat lastXCenter = width - inset.right - contentInset.right - self.itemSize.width / 2.0;
        CGFloat centerXSpacing = self.numberOfColumns > 1 ? (lastXCenter - firstXCenter) / (self.numberOfColumns - 1) : 0;
        CGFloat sectionYOrigin = 0;
        for (NSInteger section = 0; section < sectionCount; section++) {
            CGFloat sectionHeight = 0;
            CGFloat headerHeight;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                CGSize referenceSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
                headerHeight = referenceSize.height;
            } else {
                headerHeight = self.headerSize.height;
            }
            sectionHeight += headerHeight;
            UICollectionViewLayoutAttributes *headerPose = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:VCollectionViewGridLayoutElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerPose.frame = CGRectMake(inset.left, sectionYOrigin, self.collectionView.frame.size.width - inset.left - inset.right, headerHeight);
            headerPose.zIndex = 1;
            [headerPoses addObject:headerPose];
            rectangularHull = CGRectUnion(rectangularHull, headerPose.frame);
            NSString *sectionName = [self.delegate collectionView:self.collectionView layout:self sectionNameForSection:section];
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            if (headerHeight > 0 && itemCount > 0) {
                sectionHeight += contentInset.top;
            }
            CGFloat rowHeight = 0;
            NSInteger column = 0;
            NSMutableArray *items = [[NSMutableArray alloc] init];
            for (NSInteger item = 0; item < itemCount; item++) {
                column = item % self.numberOfColumns;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                NSString *itemIdentifier = [self.delegate collectionView:self.collectionView layout:self identifierForItemAtIndexPath:indexPath];
                UICollectionViewLayoutAttributes *pose = [[[self class] layoutAttributesClass]
                                                          layoutAttributesForCellWithIndexPath:indexPath];
                CGSize itemSize;
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                    itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                } else {
                    itemSize = self.itemSize;
                }
                rowHeight = MAX(rowHeight, itemSize.height);
                CGFloat frameYOrigin = sectionYOrigin + sectionHeight;
                pose.frame = CGRectMake(0, frameYOrigin, itemSize.width, itemSize.height);
                CGPoint center = pose.center;
                center.x = firstXCenter + (column * centerXSpacing);
                pose.center = center;
                pose.alpha = 1;
                if (self.updateLayoutAttributes) {
                    UICollectionViewLayoutAttributes *updatedPose = self.updateLayoutAttributes(pose);
                    pose = updatedPose ? updatedPose : pose;
                }
                TLIndexPathItem *indexPathData = [[TLIndexPathItem alloc] initWithIdentifier:itemIdentifier sectionName:sectionName cellIdentifier:nil data:pose];
                [items addObject:indexPathData];
                rectangularHull = CGRectUnion(rectangularHull, pose.frame);
                if (item == itemCount - 1) {
                    sectionHeight += rowHeight;
                } else if (column == self.numberOfColumns - 1) {
                    sectionHeight += rowHeight + self.rowSpacing;
                    rowHeight = 0;
                }
            }
            if (itemCount > 0) {
                sectionYOrigin += contentInset.bottom;
            }
            sectionYOrigin += inset.bottom + sectionHeight + inset.top;
            TLIndexPathSectionInfo *sectionInfo = [[TLIndexPathSectionInfo alloc] initWithItems:items name:sectionName];
            [sectionInfos addObject:sectionInfo];
        }
        _dataModel = [[VCollectionViewDataModel alloc] initWithSectionInfos:sectionInfos identifierKeyPath:nil];
        _dataModel.contentSize = rectangularHull.size;
        _dataModel.headerPoses = headerPoses;
        CGRect predictedBounds = self.oldDataModel ? self.oldDataModel.bounds : self.collectionView.bounds;
        //Correct for predicted change in the bounds origin due to the current origin
        //being invalid after a batch update (which we don't know yet).
        CGFloat maxBoundsY = _dataModel.contentSize.height - self.collectionView.bounds.size.height;
        if (predictedBounds.origin.y > maxBoundsY) {
            predictedBounds.origin.y = maxBoundsY;
        }
        _dataModel.bounds = predictedBounds;
        [self updateDataModelForStickyHeader];
    }
    return _dataModel;
}

- (TLIndexPathUpdates *)dataModelUpdates
{
    if (!_dataModelUpdates && self.oldDataModel && self.dataModel) {
        _dataModelUpdates = [[TLIndexPathUpdates alloc] initWithOldDataModel:self.oldDataModel updatedDataModel:self.dataModel];
    }
    return _dataModelUpdates;
}

#pragma mark - Main layout method overrides

- (CGSize)collectionViewContentSize
{
    return self.dataModel.contentSize;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    //this try-catch block helps work around a `UICollectionView` bug where
    //sections with supplmementary views crash when there are zero items
    @try {
        [super prepareForCollectionViewUpdates:updateItems];
    } @catch (NSException *e) {
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.dataModel.bufferRect = rect;
    NSMutableArray *posesInRect = [[NSMutableArray alloc] init];
    for (TLIndexPathItem *indexPathData in [self.dataModel items]) {
        UICollectionViewLayoutAttributes *pose = indexPathData.data;
        if (CGRectIntersectsRect(rect, pose.frame)) {
            [posesInRect addObject:pose];
        }
    }
    for (UICollectionViewLayoutAttributes *pose in self.dataModel.headerPoses) {
        if (CGRectIntersectsRect(rect, pose.frame) && pose.frame.size.height > 0) {
            [posesInRect addObject:pose];
        }
    }

    return posesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TLIndexPathItem *indexPathData = [self.dataModel itemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *pose = indexPathData.data;
    return pose;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataModel.headerPoses count] > indexPath.section) {
        UICollectionViewLayoutAttributes *pose = [self.dataModel.headerPoses objectAtIndex:indexPath.section];
        return pose;
    }
    return nil;
}

//layoutAttributesForDecorationViewOfKind:atIndexPath: (if your layout supports decoration views)

#pragma mark - Responding to Collection View Updates

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    TLIndexPathItem *newItem = [self.dataModel itemAtIndexPath:itemIndexPath];
    TLIndexPathItem *oldItem = [self.oldDataModel currentVersionOfItem:newItem];
    UICollectionViewLayoutAttributes *oldPose = [oldItem.data copy];
    UICollectionViewLayoutAttributes *newPose = [newItem.data copy];
    UICollectionViewLayoutAttributes *pose = [self initialLayoutAttributesForOldPose:oldPose andNewPose:newPose];
    return pose;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    if ([self.dataModel.headerPoses count] > elementIndexPath.section) {
        UICollectionViewLayoutAttributes *newPose = [self.dataModel.headerPoses objectAtIndex:elementIndexPath.section];
        NSString *sectionName = [self.dataModel sectionNameForSection:elementIndexPath.section];
        NSInteger oldSection = [self.oldDataModel sectionForSectionName:sectionName];
        if (oldSection != NSNotFound && [self.oldDataModel.headerPoses count] > oldSection) {
            UICollectionViewLayoutAttributes *oldPose = oldSection == NSNotFound ? nil : [self.oldDataModel.headerPoses objectAtIndex:oldSection];
            return [self initialLayoutAttributesForOldPose:oldPose andNewPose:newPose];
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForOldPose:(UICollectionViewLayoutAttributes *)oldPose andNewPose:(UICollectionViewLayoutAttributes *)newPose
{
    UICollectionViewLayoutAttributes *mappedOldPose = [self mapOldPoseToNewBounds:oldPose];
    VCollectionViewChangeType changeType = [self changeTypeForOldPose:oldPose andNewPose:newPose andMappedOldPose:mappedOldPose];

    //degenerate posses, i.e. poses with zero size, seem to behave better if we
    //always return nil. Otherwise, there can be some visual artifacts.
    BOOL degeneratePose = newPose.size.height == 0 || newPose.size.width == 0;
    if (degeneratePose) {
        return nil;
    }
    
    switch (changeType) {
        case VCollectionViewChangeTypeMoveIntoBuffer:
        {
        UICollectionViewLayoutAttributes *adjustedPose = [self adjustPoseForBufferCrossingMove:oldPose withOtherPose:newPose];
        return adjustedPose;
        }
        case VCollectionViewChangeTypeMoveOutOfBuffer:
            return [self isBoundsChange] ? mappedOldPose : nil;
        case VCollectionViewChangeTypeMoveWithinBuffer:
            return oldPose;
        default:
            return oldPose;
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    TLIndexPathItem *oldItem = [self.oldDataModel itemAtIndexPath:itemIndexPath];
    TLIndexPathItem *newItem = [self.dataModel currentVersionOfItem:oldItem];
    UICollectionViewLayoutAttributes *oldPose = [oldItem.data copy];
    UICollectionViewLayoutAttributes *newPose = [newItem.data copy];
    UICollectionViewLayoutAttributes *pose = [self finalLayoutAttributesForOldPose:oldPose andNewPose:newPose];
    return pose;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    if ([self.oldDataModel.headerPoses count] > elementIndexPath.section) {
        UICollectionViewLayoutAttributes *oldPose = [self.oldDataModel.headerPoses objectAtIndex:elementIndexPath.section];
        NSString *sectionName = [self.oldDataModel sectionNameForSection:elementIndexPath.section];
        NSInteger newSection = [self.dataModel sectionForSectionName:sectionName];
        if (newSection != NSNotFound && [self.dataModel.headerPoses count] > newSection) {
            UICollectionViewLayoutAttributes *newPose = newSection == NSNotFound ? nil : [self.dataModel.headerPoses objectAtIndex:newSection];
            return [self finalLayoutAttributesForOldPose:oldPose andNewPose:newPose];
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForOldPose:(UICollectionViewLayoutAttributes *)oldPose andNewPose:(UICollectionViewLayoutAttributes *)newPose
{
    UICollectionViewLayoutAttributes *mappedOldPose = [self mapOldPoseToNewBounds:oldPose];
    VCollectionViewChangeType changeType = [self changeTypeForOldPose:oldPose andNewPose:newPose andMappedOldPose:mappedOldPose];
    switch (changeType) {
        case VCollectionViewChangeTypeMoveOutOfBuffer:
        {
        UICollectionViewLayoutAttributes *adjustedPose = [self adjustPoseForBufferCrossingMove:newPose withOtherPose:oldPose];
        return adjustedPose;
        }
        case VCollectionViewChangeTypeMoveIntoBuffer:
            return [self isBoundsChange] ? newPose : nil;
        case VCollectionViewChangeTypeMoveWithinBuffer:
            return newPose;
        default:
            return nil;
    }
}

- (UICollectionViewLayoutAttributes *)mapOldPoseToNewBounds:(UICollectionViewLayoutAttributes *)oldPose
{
    UICollectionViewLayoutAttributes *mappedPose = [oldPose copy];
    CGRect oldRect = oldPose.frame;
    CGRect newRect = oldRect;
    CGRect oldbounds = self.oldDataModel.bounds;
    CGRect newBounds = self.dataModel.bounds;
    CGPoint oldOriginRelativeToBounds = CGPointMake(oldRect.origin.x - oldbounds.origin.x, oldRect.origin.y - oldbounds.origin.y);
    newRect.origin = CGPointMake(newBounds.origin.x + oldOriginRelativeToBounds.x, newBounds.origin.y + oldOriginRelativeToBounds.y);
    mappedPose.frame = newRect;
    return mappedPose;
}

- (UICollectionViewLayoutAttributes *)adjustPoseForBufferCrossingMove:(UICollectionViewLayoutAttributes *)pose withOtherPose:(UICollectionViewLayoutAttributes *)otherPose
{
    UICollectionViewLayoutAttributes *adjustedPose = [pose copy];
    CGRect frame = pose.frame;
    CGRect otherFrame = otherPose.frame;
    CGRect adjustedFrame = frame;
    CGFloat distance = sqrtf(powf(frame.origin.x - otherFrame.origin.x, 2) + powf(frame.origin.y + otherFrame.origin.y, 2));
    // If distance is greater than 500, reduce the distance proportionally to the distance
    CGFloat weightFactor = MAX(distance - 500, 0) * 20.0 / 10000.0;
    adjustedFrame.origin.x = (frame.origin.x + weightFactor*otherFrame.origin.x) / (1+weightFactor);
    adjustedFrame.origin.y = (frame.origin.y + weightFactor*otherFrame.origin.y) / (1+weightFactor);
    adjustedPose.frame = adjustedFrame;
    // Set the initial alpha to zero
    adjustedPose.alpha = 0;
    return adjustedPose;
}

- (BOOL)isBoundsChange
{
    return !CGRectEqualToRect(self.dataModel.bounds, self.oldDataModel.bounds);
}

- (VCollectionViewChangeType)changeTypeForOldPose:(UICollectionViewLayoutAttributes *)oldPose
                                    andNewPose:(UICollectionViewLayoutAttributes *)newPose
                              andMappedOldPose:(UICollectionViewLayoutAttributes *)mappedOldPose
{
    BOOL isBoundsChange = [self isBoundsChange];

    if (!oldPose && !newPose) {
        return VCollectionViewChangeTypeNone;
    }
    
    if (!oldPose) {
        return VCollectionViewChangeTypeInsert;
    }
    
    if (!newPose) {
        return VCollectionViewChangeTypeDelete;
    }
    
    BOOL oldPoseWithinRectForLayout = CGRectIntersectsRect(oldPose.frame, self.oldDataModel.bufferRect);
    BOOL newPoseWithinRectForLayout = CGRectIntersectsRect(newPose.frame, self.dataModel.bufferRect);
    if (isBoundsChange) {
        oldPoseWithinRectForLayout = CGRectIntersectsRect(mappedOldPose.frame, self.dataModel.bounds);
    }
    
    if (oldPoseWithinRectForLayout && newPoseWithinRectForLayout) {
        return VCollectionViewChangeTypeMoveWithinBuffer;
    }
    
    if (oldPoseWithinRectForLayout) {
        return VCollectionViewChangeTypeMoveOutOfBuffer;
    }
    
    if (newPoseWithinRectForLayout) {
        return VCollectionViewChangeTypeMoveIntoBuffer;
    }
    
    return VCollectionViewChangeTypeNone;
}

#pragma mark - Invalidating the Layout

- (void)invalidateLayout
{
    [super invalidateLayout];
    // Don't recalculate the data model for invalidation due to sticky header
    if (self.invalidatedForStickyHeader) {
        self.invalidatedForStickyHeader = NO;
    } else {
        // In iOS 7, "invalidateLayout" method is called additional time by system after delegate is deallocated. We shouldn't clean dataModel if delegate is nil because otherwise we wouldn't be able to initialize dataModel properly.
        if (_dataModel && self.delegate) {
            self.oldDataModel = self.dataModel;
            self.dataModel = nil;
            self.dataModelUpdates = nil;
        }
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // Only invalidate layout when we have sticky headers on or the bounds size changes
    if (!self.stickyHeaders && CGSizeEqualToSize(self.dataModel.bounds.size, newBounds.size)) {
        return NO;
    }
    
    self.dataModel.bounds = newBounds;
    [self updateDataModelForStickyHeader];
    self.invalidatedForStickyHeader = YES;
    return YES;
}

#pragma mark - Sticky header

- (void)setStickyHeaderInsetTop:(CGFloat)stickyHeaderInsetTop
{
    if (_stickyHeaderInsetTop != stickyHeaderInsetTop) {
        _stickyHeaderInsetTop = stickyHeaderInsetTop;
        [self updateDataModelForStickyHeader];
        self.invalidatedForStickyHeader = YES;
        [self invalidateLayout];
    }
}

- (void)updateDataModelForStickyHeader
{
    if (!self.stickyHeaders) {
        return;
    }
    
    VCollectionViewDataModel *dataModel = self.dataModel;

    if (dataModel.headerPoses.count == 0) {
        return;
    }

    // Determine the top most visible section

    CGFloat contentInsetTop = self.collectionView.contentInset.top;
    CGRect stickyBounds = dataModel.bounds;
    stickyBounds.origin.y += self.stickyHeaderInsetTop + contentInsetTop;
    stickyBounds.size.height -= self.stickyHeaderInsetTop;

    UICollectionViewLayoutAttributes *topMostPose;
    for (TLIndexPathItem *indexPathData in [dataModel items]) {
        UICollectionViewLayoutAttributes *pose = indexPathData.data;
        if (!CGRectIntersectsRect(pose.frame, stickyBounds)) {
            continue;
        } else if (topMostPose) {
            CGFloat currentTopMostPosition = [self relativeScrollPositionForAttributes:topMostPose];
            CGFloat position = [self relativeScrollPositionForAttributes:pose];
            if (position < currentTopMostPosition) {
                topMostPose = pose;
            }
        } else{
            topMostPose = pose;
        }
    }
    for (UICollectionViewLayoutAttributes *pose in dataModel.headerPoses) {
        if (!CGRectIntersectsRect(pose.frame, stickyBounds)) {
            continue;
        } else if (topMostPose) {
            CGFloat currentTopMostPosition = [self relativeScrollPositionForAttributes:topMostPose];
            CGFloat position = [self relativeScrollPositionForAttributes:pose];
            if (position < currentTopMostPosition) {
                topMostPose = pose;
            }
        } else{
            topMostPose = pose;
        }
    }

    if (!topMostPose) {
        return;
    }

    NSInteger topMostSection = topMostPose.indexPath.section;
    
    // Make the top most header pose sticky

    //reset the frame of current sticky pose for calculation purposes
    self.stickyPose.frame = self.originalStickyPoseFrame;

    UICollectionViewLayoutAttributes *topMostHeaderPose = dataModel.headerPoses[topMostSection];
    UICollectionViewLayoutAttributes *nextSectionPose = dataModel.headerPoses.count > topMostSection + 1 ? dataModel.headerPoses[topMostSection + 1] : nil;
    if (topMostHeaderPose) {
        if (topMostHeaderPose != self.stickyPose) {
            self.stickyPose = topMostHeaderPose;
            self.originalStickyPoseFrame = topMostHeaderPose.frame;
        }
        CGFloat pos = [self relativeScrollPositionForAttributes:topMostHeaderPose];
        if (pos < self.stickyHeaderInsetTop + contentInsetTop) {
            CGRect frame = topMostHeaderPose.frame;
            frame.origin.y = stickyBounds.origin.y;
            if (nextSectionPose) {
                CGFloat delta = nextSectionPose.frame.origin.y - (frame.origin.y + frame.size.height);
                if (delta < 0) frame.origin.y += delta;
            }
            topMostHeaderPose.frame = frame;
        }
    }
}

- (CGFloat)relativeScrollPositionForAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    return [self relativeScrollPositionForRect:attributes.frame];
}

- (CGFloat)relativeScrollPositionForRect:(CGRect)rect
{
    return rect.origin.y - self.dataModel.bounds.origin.y;
}

#pragma mark - Creating layouts

+ (VCollectionViewGridLayout *)layoutWithLayout:(VCollectionViewGridLayout *)layout
{
    VCollectionViewGridLayout *newLayout = [[VCollectionViewGridLayout alloc] init];
    if (layout) {
        newLayout.numberOfColumns = layout.numberOfColumns;
        newLayout.rowSpacing = layout.rowSpacing;
        newLayout.sectionInset = layout.sectionInset;
        newLayout.itemSize = layout.itemSize;
        newLayout.headerSize = layout.headerSize;
        newLayout.stickyHeaders = layout.stickyHeaders;
        //    newLayout.dataModel = layout.dataModel;
        //    newLayout.oldDataModel = layout.dataModel;
        //    newLayout.dataModelUpdates = layout.dataModelUpdates;
    }
    return newLayout;
}

@end

#pragma mark - VCollectionViewDataModel

@implementation VCollectionViewDataModel
@end