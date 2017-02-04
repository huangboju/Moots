//
//  ViewController.m
//  HHPullToRefreshWaveDemo
//
//  Created by Herui on 12/26/15.
//  Copyright © 2015 hirain. All rights reserved.
//

#import "ViewController.h"
#import "HHPullToRefreshWave.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    [self.tableView hh_removeRefreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1];

    self.tableView.backgroundColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseCell"];
    [self.tableView hh_addRefreshViewWithActionHandler:^{
        NSLog(@"action");
    }];
    [self.tableView hh_setRefreshViewTopWaveFillColor:[UIColor lightGrayColor]];
    [self.tableView hh_setRefreshViewBottomWaveFillColor:[UIColor whiteColor]];
    
   
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    return cell;
}




@end
