//
//  NYWaterWaveView.m
//  NYWaterWaveDemo
//
//  Created by 牛严 on 16/8/16.
//  Copyright © 2016年 牛严. All rights reserved.
//

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


#import "NYWaterWaveView.h"

@interface NYWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic,strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic,strong) CAShapeLayer *secondeWaveLayer;
@property (nonatomic,strong) CAShapeLayer *thirdWaveLayer;

@end

@implementation NYWaterWaveView
{
    CGFloat _waveAmplitude;      //!< 振幅
    CGFloat _waveCycle;          //!< 周期
    CGFloat _waveSpeed;          //!< 速度
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveOffsetX;            //!< 波浪x位移
    UIColor *_waveColor;             //!< 波浪颜色
    
    CGFloat _waveSpeed2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgba(251, 91, 91,1);
        self.layer.masksToBounds = YES;
        
        [self ConfigParams];
        
        [self startWave];
    }
    return self;
}

#pragma mark 配置参数
- (void)ConfigParams
{
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = 200;
    _waveColor = rgba(255, 255, 255,0.1);
    _waveSpeed = 0.25/M_PI;
    _waveSpeed2 = 0.3/M_PI;
    _waveOffsetX = 0;
    _wavePointY = _waterWaveHeight - 50;
    _waveAmplitude = 13;
    _waveCycle =  1.29 * M_PI / _waterWaveWidth;
}

#pragma mark 加载layer ，绑定runloop 帧刷新
- (void)startWave
{
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondeWaveLayer];
    [self.layer addSublayer:self.thirdWaveLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark 帧刷新事件
- (void)getCurrentWave
{
    _waveOffsetX += _waveSpeed;
    
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    [self setThirdWaveLayerPath];
}

#pragma mark 三个shapeLayer动画
- (void)setFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = _waveAmplitude * sin(_waveCycle * x + _waveOffsetX - 10) + _wavePointY + 10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    
    CGPathRelease(path);
}

- (void)setSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = (_waveAmplitude -2) * sin(_waveCycle * x + _waveOffsetX ) + _wavePointY ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondeWaveLayer.path = path;
    
    CGPathRelease(path);
}

- (void)setThirdWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= _waterWaveWidth; x ++) {
        y = (_waveAmplitude +2)* sin(_waveCycle * x + _waveOffsetX + 20) + _wavePointY -10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _thirdWaveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark Get
- (CAShapeLayer *)firstWaveLayer
{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondeWaveLayer
{
    if (!_secondeWaveLayer) {
        _secondeWaveLayer = [CAShapeLayer layer];
        _secondeWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondeWaveLayer;
}

- (CAShapeLayer *)thirdWaveLayer
{
    if (!_thirdWaveLayer) {
        _thirdWaveLayer = [CAShapeLayer layer];
        _thirdWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _thirdWaveLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}

@end
