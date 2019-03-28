//
//  CLTStickyLayout.m
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/10.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "CLTStickyLayout.h"

typedef NS_ENUM(NSInteger , CLTStrickyLayoutType) {

    CLTStrickyLayoutTypeList = 1<<0,
    CLTStrickyLayoutTypeGrid
};

NSString * const CLTCollectionElementKindHeader = @"CLTCollectionElementKindHeader";
NSString * const CLTCollectionElementKindSectionHeader = @"CLTCollectionElementKindSectionHeader";
NSString * const CLTCollectionElementKindSectionFooter = @"CLTCollectionElementKindSectionFooter";
NSString * const CLTCollectionElementKindFooter = @"CLTCollectionElementKindFooter";

NSUInteger const CLTCollectionMinOverlayZ = 1000.0; // Allows for 900 items in a section without z overlap issues

@interface CLTStickyLayout ()

// Caches
@property (nonatomic, assign) BOOL needsToPopulateAttributesForAllSections;
@property (nonatomic, strong) NSMutableDictionary *cachedColumnHeights;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

// Attributes
@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *headerAttributes;
@property (nonatomic, strong) NSMutableDictionary *sectionHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *sectionFooterAttributes;
@property (nonatomic, strong) NSMutableDictionary *footerAttributes;

@property (nonatomic ,assign) CLTStrickyLayoutType layoutType;

@end
@implementation CLTStickyLayout


#pragma mark - NSObject

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    
    self.needsToPopulateAttributesForAllSections = YES;
    self.cachedColumnHeights = [NSMutableDictionary new];
    
    self.registeredDecorationClasses = [NSMutableDictionary new];
    
    self.allAttributes = [NSMutableArray new];
    self.itemAttributes = [NSMutableDictionary new];
    self.headerAttributes = [NSMutableDictionary new];
    self.sectionHeaderAttributes = [NSMutableDictionary new];
    self.sectionFooterAttributes = [NSMutableDictionary new];
    self.footerAttributes = [NSMutableDictionary new];
    
    self.headerHeight = 0;
    self.footerHeight = 0;
    
    self.sectionHeaderHeight = 40;
    self.sectionFooterHeight = 40;
    self.sectionMargin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0);
    
    self.itemSize = CGSizeMake(70, 50);
    
    self.itemHorizontalMargin = 10;
    self.itemVerticalMargin = 10;
    
    self.stickySectionHeader = YES;
    
    self.layoutType = CLTStrickyLayoutTypeGrid;
}

- (void) invalidateLayoutCache{
    
    self.needsToPopulateAttributesForAllSections = YES;
    
    // Invalidate cached Components
    [self.cachedColumnHeights removeAllObjects];
    
    // Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];
    [self.sectionHeaderAttributes removeAllObjects];
    [self.sectionFooterAttributes removeAllObjects];
    [self.footerAttributes removeAllObjects];
    
    [self.allAttributes removeAllObjects];
}

#pragma mark -
#pragma mark Layout hooks

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [self invalidateLayoutCache];
    
    [self prepareLayout];
    
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    // This is a hack to prevent the error detailed in :
    // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
    // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
    for (UIView *subview in self.collectionView.subviews) {
        for (Class decorationViewClass in self.registeredDecorationClasses.allValues) {
            if ([subview isKindOfClass:decorationViewClass]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}

/** 子类必须重写的方法 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needsToPopulateAttributesForAllSections) {
        [self prepareSectionLayoutForSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
        self.needsToPopulateAttributesForAllSections = NO;
    }
    
    BOOL needsToPopulateAllAttribtues = (self.allAttributes.count == 0);
    if (needsToPopulateAllAttribtues) {
        [self.allAttributes addObjectsFromArray:[self.headerAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.sectionHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.sectionFooterAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.footerAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
    }
}

- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    CGFloat headerViewWidth = self.collectionView.bounds.size.width;
    
    CGFloat itemWidth = [self _stickyLayoutItemSize].width;
    CGFloat itemHeight = [self _stickyLayoutItemSize].height;
    
    BOOL needsToPopulateHeaderAttributes = ([self _stickyLayoutHeaderViewHeight] != 0);
    BOOL needsToPopulateFooterAttributes = ([self _stickyLayoutFooterViewHeight] != 0);
    BOOL needsToPopulateSectionFooterAttributes = ([self _stickyLayoutSectionFooterViewHeight] != 0);
    
    // header view
    if (needsToPopulateHeaderAttributes) {
    
        NSIndexPath * headerViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UICollectionViewLayoutAttributes * headerViewAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:headerViewIndexPath ofKind:CLTCollectionElementKindHeader withItemCache:self.headerAttributes];
        headerViewAttributes.frame = (CGRect){
            0.0,
            0.0,
            headerViewWidth,
            [self _stickyLayoutHeaderViewHeight]
        };
        headerViewAttributes.zIndex = [self zIndexForElementKind:CLTCollectionElementKindHeader];
    }
    
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
    
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        
        CGFloat minSectionHeaderY = 0.0 ,minSectionFooterY = 0.0;
        CGFloat nextMinSectionHeaderY = 0.0;
        CGFloat baseItemCellX = 0.0,baseItemCellY = 0.0;
        
        baseItemCellX = self.sectionMargin.left;
        
        // section header view
        nextMinSectionHeaderY = (section == (NSUInteger)self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : ([self stackedSectionHeightUpToSection:(section + 1)] + [self _stickyLayoutHeaderViewHeight]);
        
        CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
        columnMinY += [self _stickyLayoutHeaderViewHeight];
        
        if (!self.stickySectionHeader) {
            minSectionHeaderY = columnMinY;
        }else{
            nextMinSectionHeaderY = (section == (NSUInteger)self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
            
            minSectionHeaderY = fminf(fmaxf(self.collectionView.contentOffset.y, columnMinY), (nextMinSectionHeaderY - [self _stickyLayoutSectionHeaderViewHeight] + [self _stickyLayoutHeaderViewHeight]));
        }
        
        NSIndexPath * sectionHeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        UICollectionViewLayoutAttributes * sectionHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:sectionHeaderIndexPath ofKind:CLTCollectionElementKindSectionHeader withItemCache:self.sectionHeaderAttributes];
        sectionHeaderAttributes.frame = (CGRect){
            0.0,
            minSectionHeaderY,
            headerViewWidth,
            [self _stickyLayoutSectionHeaderViewHeight]
        };
        sectionHeaderAttributes.zIndex = [self zIndexForElementKind:CLTCollectionElementKindSectionHeader];
        
        baseItemCellY = ((section == 0 ? 0.0f : [self stackedSectionHeightUpToSection:section]) + [self _stickyLayoutSectionHeaderViewHeight] + self.sectionMargin.top) + [self _stickyLayoutHeaderViewHeight];

        // item cell view
        if (numberOfItemsInSection) {
            
            for (NSInteger row = 0; row < numberOfItemsInSection; row ++) {
                
                CGFloat itemCellMinX = 0.0,itemCellMinY = 0.0;
                
                if (self.layoutType == CLTStrickyLayoutTypeList) {
                    itemCellMinX = baseItemCellX;
                    itemCellMinY = baseItemCellY + row * (itemHeight + [self _stickyLayoutItemVerticalMargin]);
                }else{
                    itemCellMinX = baseItemCellX + (row % [self columnItem]) * (itemWidth + [self _stickyLayoutItemHorizontalMargin]);
                    itemCellMinY = baseItemCellY + (row / [self columnItem]) * (itemHeight + [self _stickyLayoutItemVerticalMargin]);
                }
                NSIndexPath * itemCellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes * itemCellAttributes = [self layoutAttributesForCellAtIndexPath:itemCellIndexPath withItemCache:self.itemAttributes];
                itemCellAttributes.frame = (CGRect){
                    itemCellMinX,
                    itemCellMinY,
                    itemWidth,
                    itemHeight
                };
                itemCellAttributes.zIndex = [self zIndexForElementKind:nil];
            }
        }
        
        // section footer view
        if (needsToPopulateSectionFooterAttributes) {
            
            minSectionFooterY = (nextMinSectionHeaderY - [self _stickyLayoutSectionFooterViewHeight]) + [self _stickyLayoutHeaderViewHeight];
            if (!self.stickySectionHeader) {
                minSectionFooterY -= [self _stickyLayoutHeaderViewHeight];
            }
            NSIndexPath * sectioniFooterIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            UICollectionViewLayoutAttributes * sectionFooterAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:sectioniFooterIndexPath ofKind:CLTCollectionElementKindSectionFooter withItemCache:self.sectionFooterAttributes];
            sectionFooterAttributes.frame = (CGRect){
                0.0,
                minSectionFooterY,
                headerViewWidth,
                [self _stickyLayoutSectionFooterViewHeight]
            };
            sectionFooterAttributes.zIndex = [self zIndexForElementKind:CLTCollectionElementKindSectionFooter];
        }
    }];
    
    // footer view
    if (needsToPopulateFooterAttributes) {
        
        NSIndexPath * footerViewIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UICollectionViewLayoutAttributes * footerViewAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:footerViewIndexPath ofKind:CLTCollectionElementKindFooter withItemCache:self.headerAttributes];
        footerViewAttributes.frame = (CGRect){
            0.0,
            [self stackedSectionHeight] + [self _stickyLayoutHeaderViewHeight],
            headerViewWidth,
            [self _stickyLayoutFooterViewHeight]
        };
        footerViewAttributes.zIndex = [self zIndexForElementKind:CLTCollectionElementKindFooter];
    }
}

/** 子类必须重写的方法 */
- (CGSize)collectionViewContentSize
{
    CGFloat width;
    CGFloat height;
    
    height = [self stackedSectionHeight] + [self _stickyLayoutHeaderViewHeight] + [self _stickyLayoutFooterViewHeight];
    width = self.collectionView.bounds.size.width;
    return CGSizeMake(width, height);
}

/** 子类必须重写的方法 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath];
}

/** 子类必须重写的方法 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == CLTCollectionElementKindHeader) {
        return self.headerAttributes[indexPath];
    }
    else if (kind == CLTCollectionElementKindFooter){
        return self.footerAttributes[indexPath];
    }
    else if (kind == CLTCollectionElementKindSectionHeader){
        return self.sectionHeaderAttributes[indexPath];
    }
    else if (kind == CLTCollectionElementKindSectionFooter){
        return self.sectionFooterAttributes[indexPath];
    }
    return nil;
}

/** 子类必须重写的方法 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        CGRect sectionRect = [self rectForSection:section];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [visibleSections addIndex:section];
        }
    }];
    
    // 更新布局，但是只更新可见的部分
    [self prepareSectionLayoutForSections:visibleSections];
    
    // 返回可见的attributes
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // Required for sticky headers
    return YES;
}

#pragma mark -
#pragma mark Layout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache{
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache{
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache{
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
    if (elementKind == nil) {
        return CLTCollectionMinOverlayZ;
    }
    // section header
    else if (elementKind == CLTCollectionElementKindSectionHeader) {
        return CLTCollectionMinOverlayZ + 3.0;
    }
    // section footer
    else if (elementKind == CLTCollectionElementKindSectionFooter) {
        return CLTCollectionMinOverlayZ + 2.0;
    }
    // header
    else if (elementKind == CLTCollectionElementKindHeader){
        return CLTCollectionMinOverlayZ + 1.0;
    }
    // footer
    else if (elementKind == CLTCollectionElementKindFooter){
        return CLTCollectionMinOverlayZ + 1.0;
    }
    return CGFLOAT_MIN;
}

#pragma mark -
#pragma mark Stacking

/** 计算整个CollectionView的section堆叠高度 */
- (CGFloat)stackedSectionHeight
{
    return [self stackedSectionHeightUpToSection:self.collectionView.numberOfSections];// + self.signHeaderHeight;
}
/** 计算upToSection之前的所有section的堆叠高度 */
- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection
{
    if (self.cachedColumnHeights[@(upToSection)]) {
        return [self.cachedColumnHeights[@(upToSection)] integerValue];
    }
    
    CGFloat stackedSectionHeight = 0.0;
    for (NSInteger section = 0; section < upToSection; section++) {
        // 遍历该section以前的所有的section，将以前的section的cell高度叠加
        CGFloat sectionHeight = [self sectionHeight:section];
        stackedSectionHeight += sectionHeight;
    }
    if (stackedSectionHeight != 0.0) {
        self.cachedColumnHeights[@(upToSection)] = @(stackedSectionHeight);
        return stackedSectionHeight;
    } else {
        return stackedSectionHeight;
    }
}
/** 当前section下的显示高度， */
- (CGFloat)sectionHeight:(NSInteger)section
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    CGFloat sectionViewHeight = [self _stickyLayoutSectionHeaderViewHeight] + [self _stickyLayoutSectionFooterViewHeight];
    CGFloat sectionMarginHeight = [self _stickyLayoutSectionMargin].top + [self _stickyLayoutSectionMargin].bottom;
    CGFloat cellMarginHeight = 0.0f;
    CGFloat cellItemStackHeight = 0.0f;
    
    cellMarginHeight = [self _stickyLayoutItemVerticalMargin] * ((self.layoutType == CLTStrickyLayoutTypeList) ? (numberOfItems - 1) : ((numberOfItems - 1) / [self columnItem]));
    
    cellItemStackHeight = [self _stickyLayoutItemSize].height * (self.layoutType == CLTStrickyLayoutTypeList ? numberOfItems :((numberOfItems - 1) / [self columnItem] + 1));
    
    return sectionViewHeight + sectionMarginHeight + cellMarginHeight + cellItemStackHeight;
}

- (CGRect)rectForSection:(NSInteger)section
{
    CGRect sectionRect;
    
    CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
    CGFloat nextColumnMinY = (section == self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
    sectionRect = CGRectMake(0.0, columnMinY, self.collectionViewContentSize.width, (nextColumnMinY - columnMinY));
    return sectionRect;
}

- (NSInteger) columnItem{

    NSInteger column = 0;
    if (self.layoutType == CLTStrickyLayoutTypeList) {
        column = 1;
    }else{
        CGFloat availableItemCellWidth = self.collectionView.bounds.size.width - [self _stickyLayoutSectionMargin].left - [self _stickyLayoutSectionMargin].right;
        availableItemCellWidth += [self _stickyLayoutItemHorizontalMargin];
        
        column = (availableItemCellWidth / ([self _stickyLayoutItemSize].width + [self _stickyLayoutItemHorizontalMargin])) ;
    }
    return column;
}

#pragma mark -
#pragma mark Delegate Wrappers

- (CGFloat) _stickyLayoutHeaderViewHeight{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutHeaderViewHeight)]) {
        self.headerHeight = [self.delegate CLT_stickyLayoutHeaderViewHeight];
    }
    return self.headerHeight;
}

- (CGFloat) _stickyLayoutFooterViewHeight{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutFooterViewHeight)]) {
        self.footerHeight = [self.delegate CLT_stickyLayoutFooterViewHeight];
    }
    return self.footerHeight;
}

- (CGFloat) _stickyLayoutSectionHeaderViewHeight{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutSectionHeaderViewHeight)]) {
        self.sectionHeaderHeight = [self.delegate CLT_stickyLayoutSectionHeaderViewHeight];
    }
    return self.sectionHeaderHeight;
}

- (CGFloat) _stickyLayoutSectionFooterViewHeight{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutSectionFooterViewHeight)]) {
        self.sectionFooterHeight = [self.delegate CLT_stickyLayoutSectionFooterViewHeight];
    }
    return self.sectionFooterHeight;
}

- (UIEdgeInsets) _stickyLayoutSectionMargin{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutSectionMargin)]) {
        self.sectionMargin = [self.delegate CLT_stickyLayoutSectionMargin];
    }
    return self.sectionMargin;
}

- (CGSize)  _stickyLayoutItemSize{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutItemSize)]) {
        self.itemSize = [self.delegate CLT_stickyLayoutItemSize];
    }
    
    CGFloat availableItemCellWidth = self.collectionView.bounds.size.width - [self _stickyLayoutSectionMargin].left - [self _stickyLayoutSectionMargin].right;

    self.itemSize = (CGSize){
        MIN(availableItemCellWidth, self.itemSize.width),
        self.itemSize.height
    };
    
    if (self.itemSize.width < availableItemCellWidth) {
        self.layoutType = CLTStrickyLayoutTypeGrid;
    }else{
        self.layoutType = CLTStrickyLayoutTypeList;
    }
    
    return self.itemSize;
}

- (CGFloat) _stickyLayoutItemHorizontalMargin{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutItemHorizontalMargin)]) {
        self.itemHorizontalMargin = [self.delegate CLT_stickyLayoutItemHorizontalMargin];
    }
    return self.itemHorizontalMargin;
}

- (CGFloat) _stickyLayoutItemVerticalMargin{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CLT_stickyLayoutItemVerticalMargin)]) {
        self.itemVerticalMargin = [self.delegate CLT_stickyLayoutItemVerticalMargin];
    }
    return self.itemVerticalMargin;
}

@end
