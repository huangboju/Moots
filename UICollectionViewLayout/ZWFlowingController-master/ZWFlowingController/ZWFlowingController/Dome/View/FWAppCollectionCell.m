//
//  FWAppCollectionCell.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#import "FWAppCollectionCell.h"
#import "FWAppCollectionData.h"
@interface FWAppCollectionCell()
{
    CGFloat   spacing;
    CGFloat   iconImgViewW;
    NSString  *uploadBytesStr;
    NSString  *downloadBytesStr;

}
@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, weak) UILabel     *titleLab;
@property (nonatomic, weak) UILabel     *loadBytesLab;
@property (nonatomic, weak) UILabel     *showTimeLab;
@property (nonatomic, weak) UIView      *bottomView;
@property (nonatomic, weak) UIView      *topView;
@property (nonatomic, weak) UIButton    *backGroundBtn;
@end
@implementation FWAppCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setupSubView];
        
    }
    return self;
}
-(void)setupSubView
{
    UIImageView *iconImgView=[[UIImageView alloc]init];
    iconImgView.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:iconImgView];
    self.iconImgView=iconImgView;
    
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.font=[UIFont systemFontOfSize:17];
    titleLab.textColor=kColor(62, 61, 58, 1);
    [self.contentView addSubview:titleLab];
    self.titleLab=titleLab;
    
    
    UILabel *showTimeLab=[[UILabel alloc]init];
    showTimeLab.font=[UIFont fontWithName:@"HelveticaNeue" size:10];
    showTimeLab.textColor=kColor(62, 61, 58, 1);
    [self.contentView addSubview:showTimeLab];
    self.showTimeLab=showTimeLab;
    
    UILabel *loadBytesLab=[[UILabel alloc]init];
    loadBytesLab.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    loadBytesLab.textColor=kColor(62, 61, 58, 1);
    [self.contentView addSubview:loadBytesLab];
    self.loadBytesLab=loadBytesLab;
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=kColor(195, 194, 199, 1);
    [self.contentView addSubview:bottomView];
    self.bottomView=bottomView;
    
    UIView *topView=[[UIView alloc]init];
    topView.backgroundColor=kColor(195, 194, 199, 1);
    [self.contentView addSubview:topView];
    self.topView=topView;
    
    UIButton *backGroundBtn=[[UIButton alloc]init];
    backGroundBtn.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    backGroundBtn.showsTouchWhenHighlighted = YES;
//    [backGroundBtn setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [backGroundBtn setBackgroundImage:[self imageWithColor:kColor(0, 0, 0, 0.6)] forState:UIControlStateHighlighted];
    [backGroundBtn addTarget:self action:@selector(clicktoPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:backGroundBtn];
    self.backGroundBtn=backGroundBtn;
}
//点击按钮高亮
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)setData:(FWAppCollectionData *)data
{
    [super setData:data];
    if (data.iconStr) {
        iconImgViewW=30;
        self.iconImgView.frame=CGRectMake(15, (self.frame.size.height-iconImgViewW)/2, iconImgViewW, iconImgViewW);
        self.iconImgView.image=[UIImage imageNamed:data.iconStr];
    }else
    {
        iconImgViewW=0;
    }
    spacing=(self.frame.size.height-20-15)/2;
    if (data.title) {
        self.titleLab.text=data.title;
        CGRect titleRect=[self comeBackLabelTextAutoRectWithStr:self.titleLab];
        NSLog(@"%f  hight",titleRect.size.height);
        self.titleLab.frame=CGRectMake(30+iconImgViewW, spacing, titleRect.size.width, 20);
        self.titleLab.hidden=NO;
    }else
    {
        self.titleLab.hidden=YES;
    }
    if (data.uploadBytesStr||data.downloadBytesStr) {

        uploadBytesStr=data.uploadBytesStr?[NSString stringWithFormat:@"↑%@",data.uploadBytesStr]:@"0";
        downloadBytesStr=data.downloadBytesStr?[NSString stringWithFormat:@"↓%@",data.downloadBytesStr]:@"0";

        self.loadBytesLab.text=[NSString stringWithFormat:@"%@   %@",downloadBytesStr,uploadBytesStr];

        CGRect titleRect=[self comeBackLabelTextAutoRectWithStr:self.loadBytesLab];
        NSLog(@"%f  width",titleRect.size.height);
        self.loadBytesLab.frame=CGRectMake(30+iconImgViewW, 25+spacing, titleRect.size.width, titleRect.size.height);
        self.loadBytesLab.hidden=NO;
    }else
    {
        self.loadBytesLab.hidden=YES;
        
    }
    if (data.ts) {
        self.showTimeLab.text=data.ts;
        CGRect titleRect=[self comeBackLabelTextAutoRectWithStr:self.showTimeLab];
        self.showTimeLab.frame=CGRectMake(self.frame.size.width- titleRect.size.width-10, 0, titleRect.size.width,12);
        self.showTimeLab.hidden=NO;
    }else
    {
        self.showTimeLab.hidden=YES;
    }
//    self.topView.frame=CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.bottomView.frame=CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}
-(void)clicktoPush:(UIButton *)btn
{
    [UIView animateWithDuration:0.1  animations:^{
        btn.backgroundColor=kColor(0, 0, 0, 0.6);
    } completion:^(BOOL finished) {
        
        btn.backgroundColor=[UIColor clearColor];
        if (self.data.tapCallback) {
            self.data.tapCallback(self.data);
        }
    }];
    
}
-(CGRect)comeBackLabelTextAutoRectWithStr:(UILabel *)Lab
{
    NSMutableParagraphStyle *paragraphstyle1=[[NSMutableParagraphStyle alloc]init];
    paragraphstyle1.lineBreakMode=NSLineBreakByCharWrapping;
    //设置label的字体和段落风格
    NSDictionary *dic1=@{NSFontAttributeName:Lab.font,NSParagraphStyleAttributeName:paragraphstyle1.copy};
    //计算label的真正大小,其中宽度和高度是由段落字数的多少来确定的，返回实际label的大小
    CGRect rect1=[Lab.text boundingRectWithSize:CGSizeMake(kScreenWidth-15-iconImgViewW-70, self.contentView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
    return rect1;
}
@end
