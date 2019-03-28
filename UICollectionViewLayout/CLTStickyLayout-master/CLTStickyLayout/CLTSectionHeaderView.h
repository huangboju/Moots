//
//  CLTSectionHeaderView.h
//  CLTStickyLayout
//
//  Created by Rocky Young on 2017/3/11.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTProtocol.h"

@interface CLTSectionHeaderView : UICollectionReusableView<CLTProtocol>

@property (nonatomic ,assign) IBOutlet UILabel * sectionHeaderLabel;
@end
