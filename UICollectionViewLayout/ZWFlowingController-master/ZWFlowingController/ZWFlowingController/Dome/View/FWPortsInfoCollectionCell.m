//
//  FWPortsInfoCollectionCell.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#import "FWPortsInfoCollectionCell.h"
#import "FWPortsInfoCollectionData.h"

@interface FWPortsInfoCollectionCell()
{
    CGFloat iconImgViewW;
    CGFloat spacing;
}

@property (nonatomic, weak) UILabel     *titleLab;
@property (nonatomic, weak) UILabel     *detailedTitleLab;
@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, weak) UILabel     *statusTitleLab;
@property (nonatomic, weak) UIView      *bottomView;
@property (nonatomic, weak) UIButton    *backGroundBtn;
@end
@implementation FWPortsInfoCollectionCell
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
    [self.contentView addSubview:titleLab];
    self.titleLab=titleLab;

    
    UILabel *detailedTitleLab=[[UILabel alloc]init];
    detailedTitleLab.font=[UIFont systemFontOfSize:12];
    detailedTitleLab.textColor=kColor(143, 142, 148, 1);
    [self.contentView addSubview:detailedTitleLab];
    self.detailedTitleLab=detailedTitleLab;

    
    UILabel *statusTitleLab=[[UILabel alloc]init];
    statusTitleLab.font=[UIFont systemFontOfSize:17];
    statusTitleLab.textColor=kColor(143, 142, 148, 1);
    [self.contentView addSubview:statusTitleLab];
    self.statusTitleLab=statusTitleLab;
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=kColor(195, 194, 199, 1);
    [self.contentView addSubview:bottomView];
    self.bottomView=bottomView;
    
    UIButton *backGroundBtn=[[UIButton alloc]init];
    backGroundBtn.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    backGroundBtn.showsTouchWhenHighlighted = YES;
    [backGroundBtn addTarget:self action:@selector(clickToPush:) forControlEvents:UIControlEventTouchUpInside];
//    [backGroundBtn setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [backGroundBtn setBackgroundImage:[self imageWithColor:kColor(0, 0, 0, 0.6)] forState:UIControlStateHighlighted];
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
-(void)setData:(FWPortsInfoCollectionData *)data
{
    [super setData:data];
    self.titleLab.text=@"";
    self.detailedTitleLab.text=@"";
    self.statusTitleLab.text=@"";
    
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
    if (data.detailedTitle) {
        self.detailedTitleLab.text=data.detailedTitle;
        NSLog(@"%@  detailedTitle",data.detailedTitle);
        CGRect titleRect=[self comeBackLabelTextAutoRectWithStr:self.detailedTitleLab];
                NSLog(@"%f  width",titleRect.size.height);
        self.detailedTitleLab.frame=CGRectMake(30+iconImgViewW, 20+spacing, titleRect.size.width, titleRect.size.height);
        self.detailedTitleLab.hidden=NO;
    }else
    {
        self.detailedTitleLab.hidden=YES;
    }
    if (data.statusTitle) {
        self.statusTitleLab.text=data.statusTitle;
        CGRect titleRect=[self comeBackLabelTextAutoRectWithStr:self.statusTitleLab];
        self.statusTitleLab.frame=CGRectMake(self.frame.size.width-titleRect.size.width-10, (self.frame.size.height-titleRect.size.height)/2, titleRect.size.width, titleRect.size.height);
        self.statusTitleLab.hidden=NO;
    }else
    {
        self.statusTitleLab.hidden=YES;
    }

    self.bottomView.frame=CGRectMake(30+iconImgViewW, self.frame.size.height-0.5, self.frame.size.width-20-iconImgViewW, 0.5);
}

-(void)clickToPush:(UIButton *)btn
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
