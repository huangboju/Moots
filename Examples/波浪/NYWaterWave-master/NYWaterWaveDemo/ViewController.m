//
//  ViewController.m
//  NYWaterWaveDemo
//
//  Created by 牛严 on 16/8/16.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ViewController.h"
#import "NYWaterWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp
{
    NYWaterWaveView *waterWaveView = [[NYWaterWaveView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    [self.view addSubview:waterWaveView];
}

@end
