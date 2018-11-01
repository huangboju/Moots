//
//  ZWBaseCollectionSection.m
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWBaseCollectionSection.h"
#import "ZWBaseCollectionData.h"
@interface ZWBaseCollectionSection ()
@property (nonatomic, strong) NSMutableArray *cellMutableArr;
@end
@implementation ZWBaseCollectionSection
-(NSMutableArray<ZWBaseCollectionData*> *)baseCells
{
    if (!_baseCells) {
        _baseCells=[NSMutableArray array];
    }
    return _baseCells;
}
-(id) initWithColumn: (int) columns callback: (ZWBaseollectionSectionLoad) callback{
    
    if (self = [super init]) {
        self.zw_columns=columns;
        
    }
    return self;
}




-(void) addViewFWCell:(ZWBaseCollectionData *)addcell {
    [self.baseCells addObject:addcell];
    
    
    
}

-(NSUInteger)count
{
    return self.cellMutableArr.count;
}

-(ZWBaseCollectionData *) cellAt: (int) index
{
    
    return [self.cellMutableArr objectAtIndex:index];
}
@end

