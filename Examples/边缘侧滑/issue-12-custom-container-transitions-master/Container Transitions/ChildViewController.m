//
//  ChildViewController.m
//  Container Transitions
//
//  Created by Joachim Bondo on 30/04/2014.
//  Copyright (c) 2014 Joachim Bondo. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()
@property (nonatomic, strong) UILabel *privateTitleLabel;
@end

@implementation ChildViewController

- (void)setTitle:(NSString *)title {
	super.title = title;
	[self _updateAppearance];
}

- (void)setThemeColor:(UIColor *)themeColor {
	_themeColor = themeColor;
	[self _updateAppearance];
}

- (void)loadView {
	
	self.privateTitleLabel = [[UILabel alloc] init];
	self.privateTitleLabel.backgroundColor = [UIColor clearColor];
	self.privateTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	self.privateTitleLabel.textAlignment = NSTextAlignmentCenter;
	self.privateTitleLabel.numberOfLines = 0;
	[self.privateTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	self.view = [[UIView alloc] init];
	[self.view addSubview:self.privateTitleLabel];
	
	// Center label in view.
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.6f constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)viewDidLoad {
	
	self.privateTitleLabel.text = self.title;
	[self _updateAppearance];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (_contentSizeCategoryDidChangeWithNotification:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)dealloc {
	if ([self isViewLoaded]) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
}

#pragma mark - Private Methods

- (void)_updateAppearance {
	if ([self isViewLoaded]) {
		self.privateTitleLabel.text = self.title;
		self.view.backgroundColor = self.themeColor;
		self.view.tintColor = self.themeColor;
	}
}

- (void)_contentSizeCategoryDidChangeWithNotification:(NSNotification *)notification {
	self.privateTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	[self.privateTitleLabel invalidateIntrinsicContentSize];
}

@end
