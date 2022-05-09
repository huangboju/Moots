//
//  FWPortsInfoCollectionData.h
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//

#import "ZWBaseCollectionData.h"

@interface FWPortsInfoCollectionData : ZWBaseCollectionData

@property (atomic, readwrite) NSString *title;
@property (atomic, readwrite) NSString *detailedTitle;
@property (nonatomic, copy  ) NSString *iconStr;
@property (atomic, readwrite) NSString *statusTitle;



@end
