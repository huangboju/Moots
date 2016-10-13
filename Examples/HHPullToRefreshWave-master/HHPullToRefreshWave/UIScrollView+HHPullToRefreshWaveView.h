//
//  UIScrollView+HHPullToRefreshWaveView.h
//  HHPullToRefreshWaveView
//
//  Created by Herui on 15/12/24.
//  Copyright © 2015年 harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HHPullToRefreshWaveView)


- (void)hh_addRefreshViewWithActionHandler:(void (^)())actionHandler;
- (void)hh_removeRefreshView;

- (void)hh_setRefreshViewTopWaveFillColor:(UIColor *)color;
- (void)hh_setRefreshViewBottomWaveFillColor:(UIColor *)color;


@end
