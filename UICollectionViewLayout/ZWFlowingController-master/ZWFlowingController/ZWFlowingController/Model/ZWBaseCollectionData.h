//
//  ZWBaseCollectionData.h
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZWBaseCollectionData;
typedef void(^ZWBaseCollectionDataTap)(ZWBaseCollectionData *cell);
typedef void(^ZWBaseCollectionDataSelect)(ZWBaseCollectionData *cell, int itme);
typedef void(^ZWBaseCollectionDataEdit)(ZWBaseCollectionData *cell,NSString *text);


@interface ZWBaseCollectionData : NSObject
//唯一标示
@property (atomic,readwrite) NSString    *identifier;

//点击回调
@property (atomic,copy) ZWBaseCollectionDataTap tapCallback;
//选择回调
@property (atomic,copy) ZWBaseCollectionDataSelect selectCallback;
//编辑回调
@property (atomic,copy) ZWBaseCollectionDataEdit editCallback;

//Cell的高度
-(int) zw_height;
//Cell的宽度
-(int) zw_width;
//x的差距
-(int) zw_Ygap;
//Y的差距
-(int) zw_Xgap;
@end
