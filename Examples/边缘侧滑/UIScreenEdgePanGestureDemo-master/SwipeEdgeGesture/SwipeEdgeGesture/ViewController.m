//
//  ViewController.m
//  SwipeEdgeGesture
//
//  Created by Paul Solt on 3/21/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate> {
    CGFloat _centerX;
}
@property (weak, nonatomic) IBOutlet UILabel *leftDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UILabel *panGestureLabel;
@property (weak, nonatomic) IBOutlet UISwitch *multipleGesturesSwitch;
@property (weak, nonatomic) IBOutlet UIView *edgeView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];

    UIScreenEdgePanGestureRecognizer *rightEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgeGesture:)];
    rightEdgeGesture.edges = UIRectEdgeRight;
    rightEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:rightEdgeGesture];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panView addGestureRecognizer:panGesture];
    
    // Store the center, so we can animate back to it after a slide
    _centerX = self.view.bounds.size.width / 2;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:gesture.view];
    self.panGestureLabel.text = [NSString stringWithFormat:@"(%0.0f, %0.0f)", translation.x, translation.y];

    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    // You can customize the way in which gestures can work
    
    // Enabling multiple gestures will allow all of them to work together, otherwise only the topmost view's gestures will work (i.e. PanGesture view on bottom)
    
    return self.multipleGesturesSwitch.on;
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {

    // Get the current view we are touching
    UIView *view = [self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];

    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint translation = [gesture translationInView:gesture.view];
        self.leftDistanceLabel.text = [NSString stringWithFormat:@"%0.1f", translation.x];
        
        view.center = CGPointMake(_centerX + translation.x, view.center.y);
    } else {  // cancel, fail, or ended
        // reset
        self.leftDistanceLabel.text = @"0.0";

        // Animate back to center x
        [UIView animateWithDuration:.3 animations:^{
            view.center = CGPointMake(self->_centerX, view.center.y);
            
        }];
    }
}

- (void)handleRightEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    
    // Get the current view we are touching
    UIView *view = [self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];

    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint translation = [gesture translationInView:gesture.view];
        self.rightDistanceLabel.text = [NSString stringWithFormat:@"%0.1f", translation.x];
        
        view.center = CGPointMake(_centerX + translation.x, view.center.y);

    } else {  // cancel, fail, or ended
        // reset
        self.rightDistanceLabel.text = @"0.0";
        
        // Animate back to center x
        [UIView animateWithDuration:.3 animations:^{
            view.center = CGPointMake(self->_centerX, view.center.y);
            
        }];

    }
    
}

@end
