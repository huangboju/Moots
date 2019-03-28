//
//  ViewController.m
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/10.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "ViewController.h"
#import "CLTStickyLayout.h"

#import "CLTHeaderView.h"
#import "CLTFooterView.h"

#import "CLTSectionFooterView.h"
#import "CLTSectionHeaderView.h"

#import "CLTItemCell.h"

@interface ViewController ()<UICollectionViewDataSource,CLTStickyLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) CLTStickyLayout * layout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.alwaysBounceVertical = YES;
//    self.collectionView.delegate = self;
    
    self.layout = [[CLTStickyLayout alloc] init];
    self.layout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    
    [self.collectionView registerNib:[CLTItemCell nib] forCellWithReuseIdentifier:[CLTItemCell reuseIdentifier]];
    
    [self.collectionView registerNib:[CLTHeaderView nib] forSupplementaryViewOfKind:CLTCollectionElementKindHeader withReuseIdentifier:[CLTHeaderView reuseIdentifier]];
    [self.collectionView registerNib:[CLTSectionHeaderView nib] forSupplementaryViewOfKind:CLTCollectionElementKindSectionHeader withReuseIdentifier:[CLTSectionHeaderView reuseIdentifier]];
    [self.collectionView registerNib:[CLTSectionFooterView nib] forSupplementaryViewOfKind:CLTCollectionElementKindSectionFooter withReuseIdentifier:[CLTSectionFooterView reuseIdentifier]];
    [self.collectionView registerNib:[CLTFooterView nib] forSupplementaryViewOfKind:CLTCollectionElementKindFooter withReuseIdentifier:[CLTFooterView reuseIdentifier]];
    
    [self.layout invalidateLayoutCache];
}

- (BOOL)prefersStatusBarHidden{

    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 9;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CLTItemCell reuseIdentifier] forIndexPath:indexPath];
    
    cell.itemCellLabel.text = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == CLTCollectionElementKindHeader) {
        CLTHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[CLTHeaderView reuseIdentifier] forIndexPath:indexPath];
        view = headerView;
//        headerView.headerLabel.text = [NSString stringWithFormat:@"%@",[NSDate date]];
    }
    if (kind == CLTCollectionElementKindSectionHeader) {
        CLTSectionHeaderView * sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[CLTSectionHeaderView reuseIdentifier] forIndexPath:indexPath];
        sectionHeaderView.sectionHeaderLabel.text = [NSString stringWithFormat:@"%ld - Section Header View",(long)indexPath.section];
        view = sectionHeaderView;
    }
    if (kind == CLTCollectionElementKindSectionFooter) {
        CLTSectionFooterView * sectionFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[CLTSectionFooterView reuseIdentifier] forIndexPath:indexPath];
        view = sectionFooterView;
    }
    if (kind == CLTCollectionElementKindFooter) {
        CLTFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[CLTFooterView reuseIdentifier] forIndexPath:indexPath];
        view = footerView;
    }
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"indexPath:%@",indexPath);
}


@end
