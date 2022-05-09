//
//  StickyHeadersCollectionViewController.m
//  Sticky Headers
//
//  Created by Tim Moose on 7/10/13.
//  Copyright (c) 2013 tmoose@vast.com. All rights reserved.
//

#import "StickyHeadersCollectionViewController.h"
#import <TLIndexPathTools/TLIndexPathSectionInfo.h>
#import <TLIndexPathTools/TLIndexPathDataModel.h>
#import <VCollectionViewGridLayout/VCollectionViewGridLayout.h>

#import "HeaderView.h"

@interface StickyHeadersCollectionViewController ()

@end

@implementation StickyHeadersCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:VCollectionViewGridLayoutElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    VCollectionViewGridLayout *layout = (VCollectionViewGridLayout *)self.collectionView.collectionViewLayout;
    layout.numberOfColumns = 2;
    layout.rowSpacing = 10;
    layout.itemSize = CGSizeMake(145, 145);
    layout.headerSize = CGSizeMake(50, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    layout.sectionContentInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    //headers are not sticky by default. must enable.
    layout.stickyHeaders = YES;
    
    TLIndexPathSectionInfo *section1 = [[TLIndexPathSectionInfo alloc] initWithItems:@[
                                        @"1.1", @"1.2", @"1.3", @"1.4", @"1.5", @"1.6",]
                                                                             name:@"Section 1"];

    TLIndexPathSectionInfo *section2 = [[TLIndexPathSectionInfo alloc] initWithItems:@[
                                        @"2.1", @"2.2", @"2.3", @"2.4",]
                                                                             name:@"Section 2"];

    TLIndexPathSectionInfo *section3 = [[TLIndexPathSectionInfo alloc] initWithItems:@[
                                        @"3.1", @"3.2", @"3.3",]
                                                                             name:@"Section 3"];
    
    self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithSectionInfos:@[section1, section2, section3] identifierKeyPath:nil];
}

- (void)collectionView:(UICollectionView *)collectionView configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([VCollectionViewGridLayoutElementKindSectionHeader isEqualToString:kind]) {
        
        HeaderView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:VCollectionViewGridLayoutElementKindSectionHeader
                                                                                   withReuseIdentifier:@"Header"
                                                                                          forIndexPath:indexPath];
        
        header.backgroundColor = [UIColor colorWithWhite:0.75 alpha:.9];
        header.titleLabel.font = [UIFont systemFontOfSize:24];
        header.titleLabel.textAlignment = NSTextAlignmentCenter;
        header.titleLabel.text = [self.indexPathController.dataModel sectionNameForSection:indexPath.section];

        return header;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView performBatchUpdates:^{
        id<NSFetchedResultsSectionInfo> section = [self.indexPathController.dataModel sectionInfoForSection:indexPath.section];
        NSMutableArray *filtered = [section.objects mutableCopy];
        [filtered removeObjectAtIndex:indexPath.row];
        section = [[TLIndexPathSectionInfo alloc] initWithItems:filtered name:section.name];
        
        NSMutableArray *sectionInfos = [self.indexPathController.dataModel.sections mutableCopy];
        sectionInfos[indexPath.section] = section;
        self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithSectionInfos:sectionInfos identifierKeyPath:nil];
//    } completion:nil];
}

#pragma mark - VCollectionViewGridLayout

- (id)collectionView:(UICollectionView *)collectionView layout:(VCollectionViewGridLayout*)layout identifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.indexPathController.dataModel identifierAtIndexPath:indexPath];
}

- (NSString *)collectionView:(UICollectionView *)collectionView layout:(VCollectionViewGridLayout*)layout sectionNameForSection:(NSInteger)section
{
    return [self.indexPathController.dataModel sectionNameForSection:section];
}

@end
