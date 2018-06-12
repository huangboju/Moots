//
//  IIViewController2.m
//  InteractionDemo
//
//  Created by Daniel Broad on 04/07/2013.
//  Copyright (c) 2013 Dorada Software Ltd. All rights reserved.
//

#import "IIViewController2.h"

@interface IIViewController2 ()

@end

@implementation IIViewController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tap to Dismiss";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tap: (UIGestureRecognizer*) recogniser {
    if (recogniser.state == UIGestureRecognizerStateRecognized) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
