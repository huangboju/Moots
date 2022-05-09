//
//  Utils.swift
//  GooglyPuff
//
//  Created by Bjørn Olav Ruud on 07.08.14.
//  Copyright (c) 2014 raywenderlich.com. All rights reserved.
//

import Foundation

/// Photo Credit: Devin Begley, http://www.devinbegley.com/
let OverlyAttachedGirlfriendURLString = "http://i.imgur.com/UvqEgCv.png"
let SuccessKidURLString = "http://i.imgur.com/dZ5wRtb.png"
let LotsOfFacesURLString = "http://i.imgur.com/tPzTg7A.jpg"

var GlobalMainQueue: dispatch_queue_t {
  return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
  return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
  return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
  return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
  return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
}

class Utils: NSObject {
  class var defaultBackgroundColor: UIColor {
    return UIColor(red: 236.0/255.0, green: 254.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  }

  class var userInterfaceIdiomIsPad: Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
  }
}
