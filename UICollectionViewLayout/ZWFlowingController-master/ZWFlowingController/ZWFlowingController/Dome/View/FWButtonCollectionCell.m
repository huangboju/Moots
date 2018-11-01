//
//  FWButton.m
//  FirewallaUI
//
//  Created by Jerry Chen on 10/17/16.
//  Copyright © 2016 Firewalla LLC. All rights reserved.
//

#import "FWButtonCollectionCell.h"
#define iconImgWithandHight     48
@interface FWButtonCollectionCell()

@property (nonatomic, weak) UILabel     *nameLab;
@property (nonatomic, weak) UIImageView *iconImgView;
@property (nonatomic, weak) UIView      *stateView;

@property (nonatomic, weak) UIButton    *addButon;


@end

@implementation FWButtonCollectionCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self setupSubView];
        [self setupSubViewFrame];
    }
    return self;
}






-(void)setupSubView
{

    
    UIImageView *iconImgView=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImgView];
    iconImgView.contentMode= UIViewContentModeScaleAspectFit;
    self.iconImgView=iconImgView;
    iconImgView.alpha = 0.7;
    iconImgView.tintColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.02 alpha:0.7];

    
    UILabel  *nameLab=[[UILabel alloc]init];
    nameLab.font=[UIFont systemFontOfSize:17];
    nameLab.backgroundColor=[UIColor clearColor];
    nameLab.font=[UIFont fontWithName:@"Helvetica-Bold" size:11];
    [self.contentView addSubview:nameLab];
    self.nameLab=nameLab;
    
    
    UIView *stateView=[[UIView alloc]init];
    [self.contentView addSubview:stateView];
    self.stateView=stateView;
    self.stateView.layer.cornerRadius=5;
    self.stateView.layer.masksToBounds=YES;
    
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    addButton.backgroundColor=[UIColor clearColor];
    [addButton addTarget:self action:@selector(clickToPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addButton];
    self.addButon=addButton;
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
-(void)setupSubViewFrame
{
    self.nameLab.frame=CGRectMake(5, 5, self.frame.size.width-15, 13);
    self.iconImgView.frame=CGRectMake((self.frame.size.width-iconImgWithandHight)/2, (self.frame.size.height-iconImgWithandHight)/2, iconImgWithandHight, iconImgWithandHight);
    self.stateView.frame=CGRectMake(self.frame.size.width-15, 4, 10, 10);
}

-(void)clickToPush:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.1  animations:^{
        btn.alpha=0.6;
    } completion:^(BOOL finished) {
        
        btn.backgroundColor=[UIColor clearColor];
        if (self.data.tapCallback) {
            self.data.tapCallback(self.data);
        }
    }];
}

-(void)setData:(FWButtonCollectionData *)data
{
    [super setData:data];
    _nameLab.text=@"";
    _stateView.backgroundColor=[UIColor clearColor];
    
    if (data.titleText) {
        _nameLab.text= data.titleText;
        _nameLab.hidden=NO;
    }else
    {
        _nameLab.hidden=YES;
    }



    if (data.iconName) {
        _iconImgView.image=[UIImage imageNamed:data.iconName];
        _iconImgView.hidden=NO;
    }else
    {
        _iconImgView.hidden=YES;
    }


    if (data.stateColor) {
        _stateView.backgroundColor=data.stateColor;
        _stateView.hidden = false;
    }
    else {
        _stateView.hidden = true;
    }

}

@end
