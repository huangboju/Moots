//
//  CLTProtocol.h
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/11.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLTProtocol <NSObject>

+ (NSString *) reuseIdentifier;
+ (UINib *) nib;

@end
