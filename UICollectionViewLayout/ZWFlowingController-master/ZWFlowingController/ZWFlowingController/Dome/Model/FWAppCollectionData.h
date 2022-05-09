//
//  FWAppCollectionData.h
//  FirewallaUI
//
//  Created by Jerry Chen on 10/24/16.
//  Copyright © 2016 Firewalla LLC. All rights reserved.
//

#import "ZWBaseCollectionData.h"

@interface FWAppCollectionData : ZWBaseCollectionData

@property (atomic,readwrite) NSString *title;
@property (atomic,readwrite) NSString *uploadBytesStr;
@property (atomic,readwrite) NSString *downloadBytesStr;
@property (atomic,readwrite) NSString *iconStr;
@property (atomic,readwrite) NSString *ts;



@end
