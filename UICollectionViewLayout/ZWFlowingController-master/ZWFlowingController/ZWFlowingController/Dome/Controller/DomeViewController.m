//
//  ViewController.m
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import "DomeViewController.h"
#import "ZWBaseFlowLayout.h"
#import "ZWBaseCollectionSection.h"
#import "ZWBaseFlowLayout.h"




#import "FWSearchCollectionData.h"
#import "FWSearchCollectionCell.h"

#import "FWButtonCollectionData.h"
#import "FWButtonCollectionCell.h"


#import "FWAppCollectionData.h"
#import "FWAppCollectionCell.h"

#import "FWTimelineCollectionCell.h"
#import "FWTimelineCollectionData.h"

#import "FWPortsInfoCollectionData.h"
#import "FWPortsInfoCollectionCell.h"
@interface DomeViewController ()
@end

@implementation DomeViewController
//先决条件：
//控制器继承于ZWBaseFlowController，
//对应自定义Cell的Model继承继承于ZWBaseCollectionData，并在.m中设置cell的宽高。
//对应自定义Cell继承于ZWBaseCollectionCell
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Flowing UI";
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.zw_collectionView.backgroundColor=[UIColor lightGrayColor];
    self.zw_collectionView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//使用方法（3步）：
    
    
    //1.将创建的需要用到的cell注册放入缓存池中（必须）
    [self registerClassWithCostomCell];
    //2.一个接口为对应的cell初始化数据和捕捉事件源（必须）
    [self load];
    
    //3.刷新（按照加载选后顺序展示）
    [self refresh];
}
-(void) registerClassWithCostomCell
{
    //注册你自定义的cell,唯一标示要与对应cell的data中identifier一致
    [self.zw_collectionView registerClass:[FWSearchCollectionCell class] forCellWithReuseIdentifier:@"FWSearchCollectionCell"];
    
    [self.zw_collectionView registerClass:[FWButtonCollectionCell class] forCellWithReuseIdentifier:@"FWButtonCollectionCell"];
    [self.zw_collectionView registerClass:[FWAppCollectionCell class] forCellWithReuseIdentifier:@"FWAppCollectionCell"];
    [self.zw_collectionView registerClass:[FWTimelineCollectionCell class] forCellWithReuseIdentifier:@"FWTimelineCollectionCell"];
    [self.zw_collectionView registerClass:[FWPortsInfoCollectionCell class] forCellWithReuseIdentifier:@"FWPortsInfoCollectionCell"];

}
-(void) load {
    //加载cell
    [self buildSearchCollectionCell ];
    
    [self buildFWButtonCollectionCell];

    
    [self buildFWAppCollectionCell];
    
    [self buildFWPortsInfoCollectionCell];
    
    [self buildFWTimelineCollectionCell];

    [self buildMoreCell];


    



}
    //设置初始滚动到的位置
-(void)viewDidLayoutSubviews
{
    
//      [self.zw_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]  atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

}
-(void)buildSearchCollectionCell
{
    //1.初始化ZWBaseCollectionSection数据
    ZWBaseCollectionSection *section=[[ZWBaseCollectionSection alloc]initWithColumn:1 callback:^{
        
    }];
    //2.初始化ZWBaseCollectionSection数据
    FWSearchCollectionData *search=[[FWSearchCollectionData alloc]init];
    
    search.editCallback=^(ZWBaseCollectionData *cell,NSString *searchStr){
        NSLog(@"show search text %@",searchStr);

    };
    
     ///2.将cell和celldata数据装入section中备用
    [section addViewFWCell:search];
    //3.将section装入collectionView中，加载完毕 等待刷新
    [self addSection:section];
}
-(void)buildFWButtonCollectionCell
{
    //1.初始化FWButtonCollectionCell数据
    FWButtonCollectionData *devices = [[FWButtonCollectionData alloc] init];
    devices.tapCallback = ^(ZWBaseCollectionData* data) {
        NSLog(@"点击了音乐");

    };

    devices.titleText=@"音乐";
    devices.detailedText= [NSString stringWithFormat:@"%D devices",5];
    devices.iconName=@"音乐";
    
    FWButtonCollectionData *alarms = [[FWButtonCollectionData alloc] init];
    alarms.tapCallback = ^(ZWBaseCollectionData* data) {
               NSLog(@"点击了新闻");
    };
    alarms.titleText=@"新闻";
    alarms.detailedText=[NSString stringWithFormat:@"%D alarms",8];
    alarms.iconName=@"新闻";
    
    FWButtonCollectionData *blockedSites = [[FWButtonCollectionData alloc] init];
    blockedSites.tapCallback = ^(ZWBaseCollectionData* data) {
           NSLog(@"点击了理财");
    };
    blockedSites.titleText=@"理财";
    blockedSites.detailedText=[NSString stringWithFormat:@"%D sites",5 ];
    blockedSites.iconName=@"理财";
    blockedSites.stateColor=[UIColor greenColor];
    
    
    
    //2.初始化装载Cell的section数据，3列初始化
    ZWBaseCollectionSection *section0=[[ZWBaseCollectionSection  alloc]initWithColumn:3 callback:^{
        
        
    }];
    section0.zw_gap=3;
    ///2.1.将cell和celldata数据装入section中备用
    [section0 addViewFWCell:devices];
    [section0 addViewFWCell:alarms];
    [section0 addViewFWCell:blockedSites];
    [section0 addViewFWCell:devices];
    [section0 addViewFWCell:alarms];
    [section0 addViewFWCell:blockedSites];
    [section0 addViewFWCell:devices];
    [section0 addViewFWCell:alarms];
    [section0 addViewFWCell:blockedSites];
    //3.将section装入collectionView中，加载完毕 等待刷新
    [self addSection:section0];
}
-(void)buildFWPortsInfoCollectionCell
{
    //初始化装载Cell的section数据，1列初始化
    ZWBaseCollectionSection *section3=[[ZWBaseCollectionSection alloc]initWithColumn:1 callback:^{
        
    }];
    FWPortsInfoCollectionData *portsInfo=[[FWPortsInfoCollectionData alloc]init];
    portsInfo.title=@"活在未来";
    portsInfo.detailedTitle=@"活在未来，走远了";
    portsInfo.statusTitle=@"已读";
    portsInfo.iconStr=@"AI";
    portsInfo.tapCallback=^(ZWBaseCollectionData *cell){
            NSLog(@"点击了活在未来");
    };
    [section3 addViewFWCell:portsInfo];
    
    FWPortsInfoCollectionData *portsInfo1=[[FWPortsInfoCollectionData alloc]init];
    portsInfo1.title=@"昨日重现";
    portsInfo1.detailedTitle=@"Your forever is all that I need";
    portsInfo1.statusTitle=@"已读";
    portsInfo1.iconStr=@"DOC";
    portsInfo1.tapCallback=^(ZWBaseCollectionData *cell){
                    NSLog(@"点击了昨日重现");
    };
    [section3 addViewFWCell:portsInfo1];
    
    FWPortsInfoCollectionData *portsInfo2=[[FWPortsInfoCollectionData alloc]init];
    portsInfo2.title=@"十七岁天空";
    portsInfo2.detailedTitle=@"青春荒唐不负你";
    portsInfo2.statusTitle=@"未读";
    portsInfo2.iconStr=@"PPT";
    portsInfo2.tapCallback=^(ZWBaseCollectionData *cell){
                    NSLog(@"点击了十七岁天空");
    };
    [section3 addViewFWCell:portsInfo2];
    [self addSection:section3];
}
-(void)buildFWTimelineCollectionCell{
    ZWBaseCollectionSection *section2=[[ZWBaseCollectionSection alloc]initWithColumn:1 callback:^{
        
    }];
    
    section2.zw_gap=5;
    FWTimelineCollectionData *firstPM=[[FWTimelineCollectionData alloc]init];
    
    firstPM.timeString=@"1:23PM";
    firstPM.dot=YES;
    firstPM.isFirstDot=YES;
    firstPM.title=@"youtube.com";
    firstPM.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push firstPM");
    };
    [section2 addViewFWCell:firstPM];
    
    
    
    FWTimelineCollectionData *secondPM=[[FWTimelineCollectionData alloc]init];
    
    secondPM.timeString=@"1:20PM";
    secondPM.dot=YES;
    secondPM.title=@"youku.com";
    secondPM.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM");
    };
    [section2 addViewFWCell:secondPM];
    
    
    FWTimelineCollectionData *secondPM1=[[FWTimelineCollectionData alloc]init];
    
    secondPM1.title=@"google.com";
    secondPM1.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM1");
    };
    [section2 addViewFWCell:secondPM1];
    FWTimelineCollectionData *secondPM2=[[FWTimelineCollectionData alloc]init];
    
    
    secondPM2.title=@"linkedin.com";
    secondPM2.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM2");
    };
    [section2 addViewFWCell:secondPM2];
    
    
    FWTimelineCollectionData *secondPM3=[[FWTimelineCollectionData alloc]init];
    
    
    secondPM3.title=@"163.com";
    secondPM3.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM3");
    };
    [section2 addViewFWCell:secondPM3];
    
    
    FWTimelineCollectionData *secondPM4=[[FWTimelineCollectionData alloc]init];
    
    
    secondPM4.title=@"qq.com";
    secondPM4.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM4");
    };
    [section2 addViewFWCell:secondPM4];
    
    
    FWTimelineCollectionData *secondPM5=[[FWTimelineCollectionData alloc]init];
    
    
    secondPM5.title=@"cnn.com";
    secondPM5.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM5");
    };
    [section2 addViewFWCell:secondPM5];
    
    
    FWTimelineCollectionData *secondPM6=[[FWTimelineCollectionData alloc]init];
    
    
    secondPM6.title=@"xx.com";
    secondPM6.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push secondPM6");
    };
    [section2 addViewFWCell:secondPM6];
    [self addSection:section2];
}
-(void)buildFWAppCollectionCell
{
    
    ZWBaseCollectionSection *section1=[[ZWBaseCollectionSection alloc]initWithColumn:1 callback:^{
        
    }];
    FWAppCollectionData *YTB=[[FWAppCollectionData alloc]init];
    YTB.iconStr=@"youtube";
    YTB.uploadBytesStr=@"20KB";
    YTB.downloadBytesStr=@"200MB";
    YTB.title=@"Youtube";
    YTB.ts=@"now";
    YTB.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push YTB");
    };
    [section1 addViewFWCell:YTB];
    
    
    FWAppCollectionData *FB=[[FWAppCollectionData alloc]init];
    FB.iconStr=@"skype";
    FB.uploadBytesStr=@"20MB";
    FB.downloadBytesStr=@"250KB";
    FB.title=@"skype";
    FB.ts=@"1 min ago";
    FB.tapCallback=^(ZWBaseCollectionData *cell){
        NSLog(@"push FB");
    };
    [section1 addViewFWCell:FB];
    [self addSection:section1];
}
-(void)buildMoreCell
{
    [self buildFWAppCollectionCell];
    
    [self buildFWTimelineCollectionCell];
    
    [self buildFWButtonCollectionCell];
    
    
    [self buildFWAppCollectionCell];
    
    [self buildFWPortsInfoCollectionCell];
    
    [self buildFWTimelineCollectionCell];
    [self buildFWButtonCollectionCell];
    
    
    [self buildFWAppCollectionCell];
    
    [self buildFWPortsInfoCollectionCell];
    
    [self buildFWTimelineCollectionCell];
    [self buildFWButtonCollectionCell];
    
    
    [self buildFWAppCollectionCell];
    
    [self buildFWPortsInfoCollectionCell];
    
    [self buildFWTimelineCollectionCell];
}
@end
