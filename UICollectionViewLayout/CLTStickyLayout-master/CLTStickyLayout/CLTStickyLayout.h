//
//  CLTStickyLayout.h
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/10.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CLTCollectionElementKindHeader;
extern NSString * const CLTCollectionElementKindSectionHeader;
extern NSString * const CLTCollectionElementKindSectionFooter;
extern NSString * const CLTCollectionElementKindFooter;

@protocol CLTStickyLayoutDelegate;

@interface CLTStickyLayout : UICollectionViewLayout

@property (nonatomic ,weak) id<CLTStickyLayoutDelegate> delegate;

@property (nonatomic) CGFloat headerHeight;// default is 0
@property (nonatomic) CGFloat footerHeight;// default is 0

@property (nonatomic) CGFloat sectionHeaderHeight;// default is 40
@property (nonatomic) CGFloat sectionFooterHeight;// default is 40
@property (nonatomic) UIEdgeInsets sectionMargin;// default is {10,10,10,10}

@property (nonatomic) CGSize itemSize;// default is {70 50}
@property (nonatomic) CGFloat itemHorizontalMargin;// default is 10
@property (nonatomic) CGFloat itemVerticalMargin;// default is 10

@property (nonatomic) BOOL stickySectionHeader;// default is YES

/** invoke this when the collectionView goto `reloadData` 、`setCollectionViewLayout...`*/
- (void) invalidateLayoutCache;
@end

@protocol CLTStickyLayoutDelegate <NSObject>

@optional;

- (CGFloat) CLT_stickyLayoutHeaderViewHeight;
- (CGFloat) CLT_stickyLayoutFooterViewHeight;

- (CGFloat) CLT_stickyLayoutSectionHeaderViewHeight;
- (CGFloat) CLT_stickyLayoutSectionFooterViewHeight;
- (UIEdgeInsets) CLT_stickyLayoutSectionMargin;

- (CGSize)  CLT_stickyLayoutItemSize;
- (CGFloat) CLT_stickyLayoutItemHorizontalMargin;
- (CGFloat) CLT_stickyLayoutItemVerticalMargin;

@end
