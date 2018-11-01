//
//  ZWBaseFlowController.m
//  ZWFlowingController
//
//  Created by 流年划过颜夕 on 2017/9/28.
//  Copyright © 2017年 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWBaseFlowController.h"
#import "ZWBaseCollectionSection.h"
#import "ZWBaseCollectionData.h"
#import "ZWBaseCollectionCell.h"
#import "ZWBaseFlowLayout.h"
@interface ZWBaseFlowController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ZWBaseFlowController
static NSString * const reuseIdentifier = @"Cell";
-(NSMutableArray *)sections
{
    if (!_sections) {
        _sections=[NSMutableArray array];
    }
    return _sections;
}
-(void) addSection: (ZWBaseCollectionSection *) section {
    [self.sections addObject:section];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildView];
    [self addNotification];

    

}
-(void)setUpChildView
{
    self.view.userInteractionEnabled=YES;
    UICollectionView *zw_collectionView=[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[[ZWBaseFlowLayout alloc] init]];
    [self.zw_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    zw_collectionView.delegate = self;
    zw_collectionView.dataSource = self;
    [self.view addSubview:zw_collectionView];
    self.zw_collectionView=zw_collectionView;
}
-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRefreshNotification) name:@"ZWRefreshNeeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedReloadNotification) name:@"ZWReloadNeeded" object:nil];
}
-(void)refresh
{
    [(ZWBaseFlowLayout *)self.zw_collectionView.collectionViewLayout setSections:self.sections];

    [self.zw_collectionView reloadData];
}

-(void) notifyRefresh { // Just need to refresh with what ever is there
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWRefreshNeeded" object:nil];
}
-(void) notifyReload {  // Reload from Server
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ZWReloadNeeded" object:nil];
}


-(void) receivedRefreshNotification {
    
}

-(void) receivedReloadNotification {
    
}



-(void) reload {
    [self.sections removeAllObjects];
    [self load];
    [self refresh];
}

-(void) load {
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc BaseFlowController");
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"%lu  number of sections",(unsigned long)[self.sections count]);
    NSLog(@"%@  number of sections",self.sections);
    return [self.sections count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu  return the number of items",(unsigned long)[[self.sections objectAtIndex:section] count]);
    return [[[self.sections objectAtIndex:section] baseCells] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWBaseCollectionData *celldata=  [[[self.sections objectAtIndex:indexPath.section] baseCells] objectAtIndex:indexPath.row];
    
    
    ZWBaseCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:celldata.identifier forIndexPath:indexPath];
    
    cell.data = celldata;
    
    
    return cell;
    
    
}

@end
