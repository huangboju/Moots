//
//  FWTimelineCollectionCell.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//

#import "FWTimelineCollectionCell.h"
#import "FWTimelineCollectionData.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
@interface FWTimelineCollectionCell()
@property (nonatomic, copy)   NSString *timeString;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) BOOL isFirstDot;
@property (nonatomic, assign) BOOL dot;

@property (nonatomic, weak) UILabel *timeStringLab;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UIView *dotView;
@property (nonatomic, weak) UIView *lineView;

@end
@implementation FWTimelineCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setupSubView];
        
    }
    return self;
}
-(void)setupSubView
{
    
    UIButton *backgroundBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundBtn addTarget:self action:@selector(clicktoPush:) forControlEvents:UIControlEventTouchUpInside];
    backgroundBtn.backgroundColor=[UIColor clearColor];
//    backgroundBtn.showsTouchWhenHighlighted = YES;
//    [backgroundBtn setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [backgroundBtn setBackgroundImage:[self imageWithColor:kColor(0, 0, 0, 0.6)] forState:UIControlStateHighlighted];
    [self.contentView addSubview:backgroundBtn];
    
    UILabel *timeStringLab=[[UILabel alloc]init];
    timeStringLab.font=[UIFont systemFontOfSize:11];
    timeStringLab.textColor=kColor(143, 142, 148, 1);
    timeStringLab.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:timeStringLab];
    self.timeStringLab=timeStringLab;
    
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.font=[UIFont systemFontOfSize:11];
    titleLab.textColor=kColor(143, 142, 148, 1);
    [self.contentView addSubview:titleLab];
    self.titleLab=titleLab;
    

    
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=kColor(205, 205, 205, 1);
    [self.contentView addSubview:lineView];
    self.lineView=lineView;
    
    UIView *dotView=[[UIView alloc]init];
    dotView.layer.cornerRadius=3;
    dotView.layer.masksToBounds=YES;
    dotView.backgroundColor=kColor(143, 142, 148, 1);
    [self.contentView addSubview:dotView];
    self.dotView=dotView;
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
-(void)setData:(FWTimelineCollectionData *)data
{
    [super setData:data];
    self.timeStringLab.text=@"";
    self.titleLab.text=@"";
    if (data.fontSize>0) {
        self.timeStringLab.font=[UIFont systemFontOfSize:data.fontSize];
        self.titleLab.font=[UIFont systemFontOfSize:data.fontSize];
    }
    if (data.timeString) {
            self.timeStringLab.text=data.timeString;
        self.timeStringLab.hidden=NO;
    }else
    {
        self.timeStringLab.hidden=YES;
    }

    if (data.title) {
        self.titleLab.text=data.title;
        self.titleLab.hidden=NO;
    }else
    {
        self.titleLab.hidden=YES;
    }



    CGRect timeStringLabRect=[self comeBackLabelTextAutoRectWithStr:self.timeStringLab];
    CGRect titleLabRect=[self comeBackLabelTextAutoRectWithStr:self.titleLab];
    self.timeStringLab.frame=CGRectMake(0, (self.frame.size.height-timeStringLabRect.size.height)/2, 70,  timeStringLabRect.size.height);
    if (data.dot) {
        self.dotView.frame=CGRectMake(76, self.frame.size.height/2-3, 6,  6);
        self.dotView.hidden=NO;
    }else
    {
        self.dotView.hidden=YES;
    }

    
    if (data.isFirstDot) {
        self.lineView.frame=CGRectMake(78.5, self.frame.size.height/2, 0.5, self.frame.size.height/2);
    }else
    {
        self.lineView.frame=CGRectMake(78.5, 0, 0.5, self.frame.size.height);
    }

    
    self.titleLab.frame=CGRectMake(88, (self.frame.size.height-titleLabRect.size.height)/2, titleLabRect.size.width, titleLabRect.size.height);

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
    CGRect rect1=[Lab.text boundingRectWithSize:CGSizeMake(kScreenWidth-26, self.contentView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil];
    return rect1;
}
@end
