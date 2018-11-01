//
//  ExpandCollectionViewController.m
//  Expand
//
//  Created by Tim Moose on 6/18/13.
//  Copyright (c) 2013 Vast.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ExpandCollectionViewController.h"

#define IDX_TEXT 0
#define IDX_COLOR 1

@interface ExpandCollectionViewController ()
@property (strong, nonatomic) NSMutableSet *selected;
@end

@implementation ExpandCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selected = [NSMutableSet set];
}

- (void)collectionView:(UICollectionView *)collectionView configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //retrieve the cell data for the given index path from the controller
    //and set the cell's text label and background color
    NSArray *item = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = item[IDX_TEXT];
    cell.backgroundColor = item[IDX_COLOR];
    cell.layer.cornerRadius = 6;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id identifer = [self.indexPathController.dataModel identifierAtIndexPath:indexPath];
    if ([self.selected containsObject:identifer]) {
        [self.selected removeObject:identifer];
    } else {
        [self.selected addObject:identifer];
    }
    [self.collectionView performBatchUpdates:nil completion:nil];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(VCollectionViewGridLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id identifer = [self.indexPathController.dataModel identifierAtIndexPath:indexPath];
    return [self.selected containsObject:identifer] ? CGSizeMake(300, 300) : CGSizeMake(300, 92);
}

@end
