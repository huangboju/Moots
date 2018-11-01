//
//  AnimationViewController.m
//  Animation
//
//  Created by Tim Moose on 6/18/13.
//  Copyright (c) 2013 Vast.com. All rights reserved.
//

#import "SortNFilterViewController.h"
#import <TLIndexPathTools/TLCollectionViewController.h>
#import <VCollectionViewGridLayout/VCollectionViewGridLayout.h>
#import "UIColor+Hex.h"

@interface SortNFilterViewController ()
@property (strong, nonatomic) TLCollectionViewController *collectionViewController;
@property (strong, nonatomic) NSArray *unfilteredItems;
@property (nonatomic) BOOL filtered;
@end

@implementation SortNFilterViewController

#pragma mark - Setup

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.unfilteredItems = @[
                         
                         //first screen of items
                         
                         @[@"A", [UIColor colorWithHexRGB:0x96D6C1]],
                         @[@"B", [UIColor colorWithHexRGB:0xD696A3]],
                         @[@"C", [UIColor colorWithHexRGB:0xFACB96]],
                         @[@"D", [UIColor colorWithHexRGB:0xFAED96]],
                         @[@"E", [UIColor colorWithHexRGB:0x96FAC3]],
                         @[@"F", [UIColor colorWithHexRGB:0x6AA9CF]],
                         
                         //second screen of items
                         
                         @[@"H", [UIColor colorWithHexRGB:0x96D6C1]],
                         @[@"I", [UIColor colorWithHexRGB:0xD696A3]],
                         @[@"J", [UIColor colorWithHexRGB:0xFACB96]],
                         @[@"K", [UIColor colorWithHexRGB:0xFAED96]],
                         @[@"L", [UIColor colorWithHexRGB:0x96FAC3]],
                         @[@"M", [UIColor colorWithHexRGB:0x6AA9CF]],
                         
                         ];    

    self.collectionViewController = (TLCollectionViewController *)segue.destinationViewController;
    self.collectionViewController.indexPathController.items = self.unfilteredItems;
    [self toggleLayout:self.layoutToggle];
}

#pragma mark - Layout

- (IBAction)toggleLayout:(UISegmentedControl *)sender {
    //preserve content offset across layout swap to workaournd UICollectionView bug
    CGPoint contentOffset = self.collectionViewController.collectionView.contentOffset;
    CGSize itemSize = CGSizeMake(145, 92);
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    self.collectionViewController.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    if (sender.selectedSegmentIndex == 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.itemSize = itemSize;
        layout.sectionInset = sectionInset;
        self.collectionViewController.collectionView.collectionViewLayout = layout;
    } else {
        VCollectionViewGridLayout *layout = [[VCollectionViewGridLayout alloc] init];
        layout.numberOfColumns = 2;
        layout.rowSpacing = 10;
        layout.itemSize = itemSize;
        layout.sectionInset = sectionInset;
        self.collectionViewController.collectionView.collectionViewLayout = layout;
    }
    self.collectionViewController.collectionView.contentOffset = contentOffset;
}

#pragma mark - Shuffle and filter

- (void)shuffle
{
    //shuffle the items randomly and update the controller with the shuffled items
    NSMutableArray *shuffledItems = [NSMutableArray arrayWithArray:self.collectionViewController.indexPathController.items];
    NSInteger count = shuffledItems.count;
    for (int i = 0; i < count; i++) {
        [shuffledItems exchangeObjectAtIndex:i withObjectAtIndex:arc4random() % count];
    }
    self.collectionViewController.indexPathController.items = shuffledItems;
}

- (IBAction)filter:(UIButton *)sender {
    //filter the items randomly and update the controller with the filtered items
    self.filtered = !self.filtered;
    [sender setTitle:self.filtered ? @"Unfilter" : @"Filter" forState:UIControlStateNormal];
    if (self.filtered) {
        NSMutableArray *filtered = [NSMutableArray array];
        for (id item in self.unfilteredItems) {
            if (rand() % 2 == 0) {
                [filtered addObject:item];
            }
        }
        self.collectionViewController.indexPathController.items = filtered;        
    } else {
        self.collectionViewController.indexPathController.items = self.unfilteredItems;
    }
}

@end
