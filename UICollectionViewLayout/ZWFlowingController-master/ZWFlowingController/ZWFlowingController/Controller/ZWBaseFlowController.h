//
//  ZWBaseFlowController.h
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZWBaseCollectionData;
@class ZWBaseCollectionSection;

@interface ZWBaseFlowController : UIViewController
/** UICollectionView */
@property (nonatomic, weak)  UICollectionView  *zw_collectionView;
@property (nonatomic,strong) NSMutableArray    *sections;

//添加数据
-(void) load;
//刷新
-(void) refresh;
//重新添加数据并刷新
-(void) reload;
//添加Section
-(void) addSection: (ZWBaseCollectionSection*) section;

-(void) notifyRefresh;
-(void) notifyReload;
-(void) receivedRefreshNotification;
-(void) receivedReloadNotification;


@end
