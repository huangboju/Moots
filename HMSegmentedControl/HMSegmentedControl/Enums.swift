//
//  Enums.swift
//  HMSegmentedControl
//
//  Created by 伯驹 黄 on 2017/6/14.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

public enum HMSegmentedControlSelectionStyle {
    // Indicator width will only be as big as the text width
    case textWidthStripe
    // Indicator width will fill the whole segment
    case fullWidthStripe
    // A rectangle that covers the whole segment
    case box
    // An arrow in the middle of the segment
    case arrow
}

public enum HMSegmentedControlSelectionIndicatorLocation {
    case up
    case down
    case none // No selection indicator
}

public enum HMSegmentedControlSegmentWidthStyle {
    // Segment width is fixed
    case fixed
    // Segment width will only be as big as the text width (including inset)
    case dynamic
}

public enum HMSegmentedControlBorderType {
    case none
    case top
    case left
    case bottom
    case right
}

public enum HMSegmentedControlType {
    case text
    case images
    case textImages
}
