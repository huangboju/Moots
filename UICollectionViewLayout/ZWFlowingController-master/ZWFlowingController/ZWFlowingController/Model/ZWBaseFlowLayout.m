//
//  ZWBaseFlowLayout.m
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWBaseFlowLayout.h"
#import "ZWBaseCollectionData.h"
#import "ZWBaseCollectionSection.h"
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define ITEM_WIDTH          50
#define ITEM_HEIGHT         50

@interface ZWBaseFlowLayout()
@property (nonatomic, strong) NSMutableDictionary *cellLayoutInfo;
@property (nonatomic) int height;

@end
@implementation ZWBaseFlowLayout
- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];

    _cellLayoutInfo = [NSMutableDictionary dictionary];
    int sectionIndex = 0;
    int frameyStart = self.zw_topGap;
    int framexStart = 0;
    int framey = frameyStart;
    int framex = framexStart;
    int lastHeight = 0;
    int column = 0;
    for (ZWBaseCollectionSection *section in self.sections) {
        int cellIndex = 0;
        
        int cellPerRow = section.zw_columns;
        
        framey +=section.zw_gap;
        framex +=section.zw_sidegap;
        
        for (ZWBaseCollectionData *cell in section.baseCells) {
            framex += cell.zw_Xgap;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemAttributes.frame = CGRectMake(framex, framey, cell.zw_width-section.zw_sidegap*2, cell.zw_height);
            
            self.cellLayoutInfo[indexPath] = nil;
            
            self.cellLayoutInfo[indexPath] = itemAttributes;
            cellIndex ++;
            column++;
            framex += cell.zw_width;
            lastHeight = cell.zw_height;
            
            if (column >= cellPerRow) {
                framey += lastHeight+cell.zw_Ygap;
                framex = framexStart;
                column = 0;
            }
        }
        sectionIndex ++;
        framey +=section.zw_sidegap;
        
    }
    self.height = framey;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.height);
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.cellLayoutInfo.count];

    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];

    
    return allAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return self.layoutInfo[BHPhotoAlbumLayoutPhotoCellKind][indexPath];
    return self.cellLayoutInfo[indexPath];
}


@end
