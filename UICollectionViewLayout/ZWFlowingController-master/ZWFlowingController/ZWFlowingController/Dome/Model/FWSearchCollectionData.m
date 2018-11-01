//
//  FWSearchCollectionData.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/9.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//

#import "FWSearchCollectionData.h"

@implementation FWSearchCollectionData
-(id) init {
    if (self = [super init]) {
        self.identifier = @"FWSearchCollectionCell";
    }
    return self;
}
-(int) zw_height {
    return  44;
}

-(int) zw_width {
    return [UIScreen mainScreen].bounds.size.width;
}

-(int) zw_ygap {
    return 0;
}

-(int) zw_xgap {
    return 0;
}
@end
