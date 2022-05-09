//
//  ZWBaseFlowLayout.h
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWBaseFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) NSMutableArray *sections;
@property (atomic, assign) int zw_topGap;
@end
