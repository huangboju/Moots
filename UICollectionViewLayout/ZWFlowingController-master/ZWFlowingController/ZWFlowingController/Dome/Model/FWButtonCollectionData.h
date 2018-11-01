//
//  FWButton.h
//  FirewallaUI
//
//  Created by Jerry Chen on 10/17/16.
//  Copyright © 2016 Firewalla LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBaseCollectionData.h"

@interface FWButtonCollectionData : ZWBaseCollectionData

@property (atomic,readwrite ) NSString *iconName;
@property (atomic,readwrite ) NSString *detailedText;
@property (nonatomic, copy  ) NSString *titleText;
@property (nonatomic, copy  ) UIColor  *stateColor;
@end
