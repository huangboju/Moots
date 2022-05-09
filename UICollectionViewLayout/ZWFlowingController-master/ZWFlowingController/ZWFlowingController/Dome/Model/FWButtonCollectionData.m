//
//  FWButton.m
//  FirewallaUI
//
//  Created by Jerry Chen on 10/17/16.
//  Copyright © 2016 Firewalla LLC. All rights reserved.
//

#import "FWButtonCollectionData.h"
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
@interface FWButtonCollectionData()



@property UIButton *button;

@end

@implementation FWButtonCollectionData

//设置重用标示
-(id) init {
    if (self = [super init]) {
        self.identifier = @"FWButtonCollectionCell";
    }
    return self;
}
//设置Cell的高度
-(int) zw_height {
    
    return fDeviceWidth/3-12/3;
}
//设置Cell的宽度
-(int) zw_width {
    return fDeviceWidth/3-12/3;
}
//设置Y间隙
-(int) zw_Ygap {
    return 3;
}
//设置X间隙
-(int) zw_Xgap {
    return 3;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
