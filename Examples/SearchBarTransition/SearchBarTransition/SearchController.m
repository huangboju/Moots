//
//  SearchController.m
//  SearchBarTransition
//
//  Created by 黄伯驹 on 01/02/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "SearchController.h"

@interface SearchController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIVisualEffectView *navBar;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    self.navBar = [self generateVisualView];
    [self.view addSubview:self.navBar];

    [self.searchBar becomeFirstResponder];
    [self.searchBar setShowsCancelButton:YES animated:YES];

    [self.navBar.contentView addSubview:self.searchBar];
}


- (UIVisualEffectView *)generateVisualView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, self.view.frame.size.width, 74);
    visualView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    return visualView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
