//
//  CLTItemCell.m
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/11.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "CLTItemCell.h"

@implementation CLTItemCell

- (void)setSelected:(BOOL)selected
{
    if (selected && (self.selected != selected)) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.25, 1.25);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    [super setSelected:selected];
}

#pragma mark -
#pragma mark CLTProtocol

+ (NSString *) reuseIdentifier{

    return NSStringFromClass([self class]);
}

+ (UINib *)nib{

    return [UINib nibWithNibName:[self reuseIdentifier] bundle:nil];
}
@end
