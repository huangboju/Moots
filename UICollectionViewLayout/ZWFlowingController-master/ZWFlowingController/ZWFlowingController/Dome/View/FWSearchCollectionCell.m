//
//  FWSearchCollectionCell.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/9.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#import "FWSearchCollectionCell.h"
@interface FWSearchCollectionCell()<UISearchBarDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, copy) NSString    *searchBarText;
@end
@implementation FWSearchCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setupSubView];
        
    }
    return self;
}
-(void)setupSubView
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    searchBar.delegate = self;
    searchBar.showsCancelButton=YES;
    UIImage* searchBarBg = [self GetImageWithColor:kColor(239, 239, 244, 1) andHeight:32.0f];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    //设置文本框背景
//    [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    [self.contentView addSubview:searchBar];
    self.searchBar = searchBar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    

    self.searchBarText=searchText;
    if (self.data.editCallback) {
        self.data.editCallback(self.data,searchText);
    }

}
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancil");
    [_searchBar endEditing:YES];
}

@end
