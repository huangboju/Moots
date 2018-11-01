//
//  ZWBaseCollectionViewCell.h
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBaseCollectionData.h"
@interface ZWBaseCollectionCell : UICollectionViewCell
@property (atomic,readwrite) ZWBaseCollectionData *data;

@end
