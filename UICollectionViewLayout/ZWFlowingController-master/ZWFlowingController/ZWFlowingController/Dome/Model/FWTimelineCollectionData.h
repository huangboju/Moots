//
//  FWTimelineCollectionData.h
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//

#import "ZWBaseCollectionData.h"

@interface FWTimelineCollectionData : ZWBaseCollectionData
@property (nonatomic, copy  ) NSString *timeString;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) BOOL     isFirstDot;
@property (nonatomic, assign) BOOL     dot;
@property (nonatomic, assign) int      fontSize;
@end
