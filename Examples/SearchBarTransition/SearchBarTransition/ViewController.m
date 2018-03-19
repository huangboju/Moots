//
//  ViewController.m
//  SearchBarTransition
//
//  Created by 黄伯驹 on 01/02/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "ViewController.h"

#import "SearchController.h"

#import "XYPHSearchTransitionDelegate.h"

@interface ViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIVisualEffectView *navBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationController.navigationBarHidden = YES;
    
     self.navBar = [self generateVisualView];
    [self.view addSubview:self.navBar];
    
    [self.navBar.contentView addSubview:self.searchBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 50)];
    titleLabel.text = @"搜索";
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.navBar.contentView addSubview:titleLabel];
}

- (UIVisualEffectView *)generateVisualView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    visualView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    return visualView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 150 - 44, self.view.frame.size.width, 44)];
        _searchBar.tag = 100;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.navigationController.delegate = XYPHSearchTransitionDelegate.transitionAnimator;
    SearchController *vc = [SearchController new];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end
