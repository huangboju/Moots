//
//  UIScrollView+HHPullToRefreshWaveView.m
//  HHPullToRefreshWaveView
//
//  Created by Herui on 15/12/24.
//  Copyright © 2015年 harry. All rights reserved.
//

#import "UIScrollView+HHPullToRefreshWaveView.h"
#import "HHPullToRefreshWaveView.h"
#import <objc/runtime.h>

static NSString *const hh_associatePullToRefreshViewKey = @"hh_associatePullToRefreshViewKey";

@interface UIScrollView ()

@property (nonatomic, strong) HHPullToRefreshWaveView *pullToRefreshView;

@end;

@implementation UIScrollView (HHPullToRefreshWaveView)

#pragma mark - Setter && Getter
- (void)setPullToRefreshView:(HHPullToRefreshWaveView *)pullToRefreshView {
    objc_setAssociatedObject(self, &hh_associatePullToRefreshViewKey, pullToRefreshView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HHPullToRefreshWaveView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &hh_associatePullToRefreshViewKey);
}


#pragma mark - Public Func

- (void)hh_addRefreshViewWithActionHandler:(void (^)())actionHandler {

    HHPullToRefreshWaveView *refreshWaveView = [[HHPullToRefreshWaveView alloc] init];
    [self addSubview:refreshWaveView];
    self.pullToRefreshView = refreshWaveView;
    
    refreshWaveView.actionHandler = actionHandler;
    [refreshWaveView observeScrollView:self];
    
}

- (void)hh_removeRefreshView {
    if (!self.pullToRefreshView) {
        return;
    }
    [self.pullToRefreshView invalidateWave];
    [self.pullToRefreshView removeObserverScrollView:self];
    [self.pullToRefreshView removeFromSuperview];
   
}

- (void)hh_setRefreshViewTopWaveFillColor:(UIColor *)color {
    self.pullToRefreshView.topWaveColor = color;
}
- (void)hh_setRefreshViewBottomWaveFillColor:(UIColor *)color {
    self.pullToRefreshView.bottomWaveColor = color;
}


@end
