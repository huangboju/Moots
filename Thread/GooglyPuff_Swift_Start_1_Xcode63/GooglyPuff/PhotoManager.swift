//
//  PhotoManager.swift
//  GooglyPuff
//
//  Created by Bjørn Olav Ruud on 06.08.14.
//  Copyright (c) 2014 raywenderlich.com. All rights reserved.
//

import Foundation

/// Notification when new photo instances are added
let PhotoManagerAddedContentNotification = "com.raywenderlich.GooglyPuff.PhotoManagerAddedContent"
/// Notification when content updates (i.e. Download finishes)
let PhotoManagerContentUpdateNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentUpdate"

typealias PhotoProcessingProgressClosure = (completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (error: NSError?) -> Void

private let _sharedManager = PhotoManager()

class PhotoManager {
  class var sharedManager: PhotoManager {
    return _sharedManager
  }

  private var _photos: [Photo] = []
  private let concurrentPhotoQueue = dispatch_queue_create(
    "com.raywenderlich.GooglyPuff.photoQueue", DISPATCH_QUEUE_CONCURRENT)
  
  var photos: [Photo] {
    var photosCopy: [Photo]!
    dispatch_sync(concurrentPhotoQueue) { // 1
      photosCopy = self._photos // 2
    }
    return photosCopy
  }
  
  func addPhoto(photo: Photo) {
    dispatch_barrier_async(concurrentPhotoQueue) { // 1
      self._photos.append(photo) // 2
      dispatch_async(GlobalMainQueue) { // 3
        self.postContentAddedNotification()
      }
    }
  }

//  func downloadPhotosWithCompletion(completion: BatchPhotoDownloadingCompletionClosure?) {
//    dispatch_async(GlobalUserInitiatedQueue) { 
//        var storedError: NSError?
//      let downloadGroup = dispatch_group_create()
//      for address in [OverlyAttachedGirlfriendURLString,
//                      SuccessKidURLString,
//                      LotsOfFacesURLString] {
//                        let url = NSURL(string: address)
//                        dispatch_group_enter(downloadGroup) // 3
//                        let photo = DownloadPhoto(url: url!) {
//                          image, error in
//                          if error != nil {
//                            storedError = error
//                          }
//                          dispatch_group_leave(downloadGroup) // 4
//                        }
//                        PhotoManager.sharedManager.addPhoto(photo)
//      }
//      
//      dispatch_group_notify(downloadGroup, GlobalMainQueue) { // 2
//        if let completion = completion {
//          completion(error: storedError)
//        }
//      }
//    }
//  }
  
  func downloadPhotosWithCompletion(completion: BatchPhotoDownloadingCompletionClosure?) {
    var storedError: NSError!
    let downloadGroup = dispatch_group_create()
    var addresses = [OverlyAttachedGirlfriendURLString,
                     SuccessKidURLString,
                     LotsOfFacesURLString]
    addresses += addresses + addresses // 1
    var blocks: [dispatch_block_t] = [] // 2
    
    for i in 0 ..< addresses.count {
      dispatch_group_enter(downloadGroup)
      let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) { // 3
        let address = addresses[i]
        let url = NSURL(string: address)
        let photo = DownloadPhoto(url: url!) {
          image, error in
          if let error = error {
            storedError = error
          }
          dispatch_group_leave(downloadGroup)
        }
        PhotoManager.sharedManager.addPhoto(photo)
      }
      blocks.append(block)
      dispatch_async(GlobalMainQueue, block) // 4
    }
    
    for block in blocks[3 ..< blocks.count] { // 5
      let cancel = arc4random_uniform(2) // 6
      if cancel == 1 {
        dispatch_block_cancel(block) // 7
        dispatch_group_leave(downloadGroup) // 8
      }
    }
    
    dispatch_group_notify(downloadGroup, GlobalMainQueue) {
      if let completion = completion {
        completion(error: storedError)
      }
    }
  }

  private func postContentAddedNotification() {
    NSNotificationCenter.defaultCenter().postNotificationName(PhotoManagerAddedContentNotification, object: nil)
  }
}
