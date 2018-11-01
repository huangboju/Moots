//
//  FWAppCollectionData.m
//  FirewallaUI
//
//  Created by Jerry Chen on 10/24/16.
//  Copyright © 2016 Firewalla LLC. All rights reserved.
//

#import "FWAppCollectionData.h"

@implementation FWAppCollectionData

-(id) init {
    if (self = [super init]) {
        self.identifier = @"FWAppCollectionCell";
    }
    return self;
}

-(int) zw_height {
    return 53;
}

-(int) zw_width {
    return [UIScreen mainScreen].bounds.size.width;
}

-(int) zw_Ygap {
    return 0;
}

-(int) zw_Xgap {
    return 0;
}

@end
