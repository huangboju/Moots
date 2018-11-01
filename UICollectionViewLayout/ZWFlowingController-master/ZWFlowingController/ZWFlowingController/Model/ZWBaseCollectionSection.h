//
//  ZWBaseCollectionSection.h
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ZWBaseCollectionData;
typedef void (^ZWBaseollectionSectionLoad)();
@interface ZWBaseCollectionSection : NSObject
@property (nonatomic) NSIndexPath *sectionId;

@property (nonatomic, assign) int zw_columns;
//head间距
@property (nonatomic, assign) int zw_gap;
//边间距
@property (nonatomic, assign) int zw_sidegap;

@property (nonatomic, strong) NSMutableArray<ZWBaseCollectionData*>* baseCells;


-(id) initWithColumn: (int) columns callback: (ZWBaseollectionSectionLoad) callback;

-(void) addViewFWCell: (ZWBaseCollectionData *) cell;

-(NSUInteger)count;
@end
