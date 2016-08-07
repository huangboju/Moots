//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

func delay(interval: NSTimeInterval, handle: () -> Void) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(interval * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), handle)
}
