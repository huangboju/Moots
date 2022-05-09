//
//  ExpandViewController.m
//  Expand
//
//  Created by Tim Moose on 6/18/13.
//  Copyright (c) 2013 Vast.com. All rights reserved.
//

#import "ExpandViewController.h"
#import <TLIndexPathTools/TLCollectionViewController.h>
#import <VCollectionViewGridLayout/VCollectionViewGridLayout.h>
#import "UIColor+Hex.h"

@interface ExpandViewController ()
@property (strong, nonatomic) TLCollectionViewController *collectionViewController;
@end

@implementation ExpandViewController

#pragma mark - Setup

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *items = @[
                             
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
    self.collectionViewController.indexPathController.items = items;
    [self toggleLayout:self.layoutToggle];
}

#pragma mark - Layout

- (IBAction)toggleLayout:(UISegmentedControl *)sender {
    //preserve content offset across layout swap to workaournd UICollectionView bug
    CGPoint contentOffset = self.collectionViewController.collectionView.contentOffset;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    self.collectionViewController.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    if (sender.selectedSegmentIndex == 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = sectionInset;
        self.collectionViewController.collectionView.collectionViewLayout = layout;
    } else {
        VCollectionViewGridLayout *layout = [[VCollectionViewGridLayout alloc] init];
        layout.numberOfColumns = 1;
        layout.rowSpacing = 10;
        //TODO Setting this is still necessary even through the collection view
        //implements the collectionView:layout:sizeForItemAtIndexPath: delegate
        //method because VCollectionViewGridLayout doesn't fully support multiple
        //cell widths yet and the width value of this property is still used
        //in the layout calculation.
        layout.itemSize = CGSizeMake(300, 92);
        layout.sectionInset = sectionInset;
        self.collectionViewController.collectionView.collectionViewLayout = layout;
    }
    self.collectionViewController.collectionView.contentOffset = contentOffset;
}

@end
