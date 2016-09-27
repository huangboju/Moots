//
//  PhotoCollectionViewController.swift
//  GooglyPuff
//
//  Created by Bjørn Olav Ruud on 06.08.14.
//  Copyright (c) 2014 raywenderlich.com. All rights reserved.
//

import UIKit

private let CellImageViewTag = 3
private let BackgroundImageOpacity: CGFloat = 0.1

class PhotoCollectionViewController: UICollectionViewController
{
  var library: ALAssetsLibrary!
  private var popController: UIPopoverController!

  private var contentUpdateObserver: NSObjectProtocol!
  private var addedContentObserver: NSObjectProtocol!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    library = ALAssetsLibrary()

    // Background image setup
    let backgroundImageView = UIImageView(image: UIImage(named:"background"))
    backgroundImageView.alpha = BackgroundImageOpacity
    backgroundImageView.contentMode = .Center
    collectionView?.backgroundView = backgroundImageView

    contentUpdateObserver = NSNotificationCenter.defaultCenter().addObserverForName(PhotoManagerContentUpdateNotification,
      object: nil,
      queue: NSOperationQueue.mainQueue()) { notification in
        self.contentChangedNotification(notification)
    }
    addedContentObserver = NSNotificationCenter.defaultCenter().addObserverForName(PhotoManagerAddedContentNotification,
      object: nil,
      queue: NSOperationQueue.mainQueue()) { notification in
        self.contentChangedNotification(notification)
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    showOrHideNavPrompt()
  }

  deinit {
    let nc = NSNotificationCenter.defaultCenter()
    if contentUpdateObserver != nil {
      nc.removeObserver(contentUpdateObserver)
    }
    if addedContentObserver != nil {
      nc.removeObserver(addedContentObserver)
    }
  }
}

// MARK: - UICollectionViewDataSource

private let PhotoCollectionCellID = "photoCell"

extension PhotoCollectionViewController {
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return PhotoManager.sharedManager.photos.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionCellID, forIndexPath: indexPath) 

    let imageView = cell.viewWithTag(CellImageViewTag) as! UIImageView
    let photoAssets = PhotoManager.sharedManager.photos
    let photo = photoAssets[indexPath.row]

    switch photo.status {
    case .GoodToGo:
      imageView.image = photo.thumbnail
    case .Downloading:
      imageView.image = UIImage(named: "photoDownloading")
    case .Failed:
      imageView.image = UIImage(named: "photoDownloadError")
    }

    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController {
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let photos = PhotoManager.sharedManager.photos
    let photo = photos[indexPath.row]

    switch photo.status {
    case .GoodToGo:
      let detailController = storyboard?.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as? PhotoDetailViewController
      if let detailController = detailController {
        detailController.image = photo.image
        navigationController?.pushViewController(detailController, animated: true)
      }

    case .Downloading:
      let alert = UIAlertController(title: "Downloading",
        message: "The image is currently downloading",
        preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
      presentViewController(alert, animated: true, completion: nil)

    case .Failed:
      let alert = UIAlertController(title: "Image Failed",
        message: "The image failed to be created",
        preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
      presentViewController(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - ELCImagePickerControllerDelegate

extension PhotoCollectionViewController: ELCImagePickerControllerDelegate {
  func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
    for dictionary in info as! [NSDictionary] {
      library.assetForURL(dictionary[UIImagePickerControllerReferenceURL] as! NSURL, resultBlock: {
        asset in
        let photo = AssetPhoto(asset: asset)
        PhotoManager.sharedManager.addPhoto(photo)
      },
      failureBlock: {
        error in
        let alert = UIAlertController(title: "Permission Denied",
          message: "To access your photos, please change the permissions in Settings",
          preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
      })
    }

    if Utils.userInterfaceIdiomIsPad {
      popController?.dismissPopoverAnimated(true)
    } else {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }

  func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
    if Utils.userInterfaceIdiomIsPad {
      popController?.dismissPopoverAnimated(true)
    } else {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

// MARK: - IBAction Methods

extension PhotoCollectionViewController {
  // The upper right UIBarButtonItem method
  @IBAction func addPhotoAssets(sender: AnyObject!) {
    // Close popover if it is visible
    if popController?.popoverVisible == true {
      popController.dismissPopoverAnimated(true)
      popController = nil
      return
    }

    let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .ActionSheet)

    // Cancel button
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alert.addAction(cancelAction)

    // Photo library button
    let libraryAction = UIAlertAction(title: "Photo Library", style: .Default) {
      action in
      let imagePickerController = ELCImagePickerController()
      imagePickerController.imagePickerDelegate = self

      if Utils.userInterfaceIdiomIsPad {
        self.popController.dismissPopoverAnimated(true)
        self.popController = UIPopoverController(contentViewController: imagePickerController)
        self.popController.presentPopoverFromBarButtonItem(self.navigationItem.rightBarButtonItem!, permittedArrowDirections: .Any, animated: true)
      } else {
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      }
    }
    alert.addAction(libraryAction)

    // Internet button
    let internetAction = UIAlertAction(title: "Le Internet", style: .Default) {
      action in
      self.downloadImageAssets()
    }
    alert.addAction(internetAction)

    if Utils.userInterfaceIdiomIsPad {
      popController = UIPopoverController(contentViewController: alert)
      popController.presentPopoverFromBarButtonItem(navigationItem.rightBarButtonItem!, permittedArrowDirections: .Any, animated: true)
    } else {
      presentViewController(alert, animated: true, completion: nil)
    }
  }
}

// MARK: - Private Methods

private extension PhotoCollectionViewController {
  func contentChangedNotification(notification: NSNotification!) {
    collectionView?.reloadData()
    showOrHideNavPrompt();
  }

  func showOrHideNavPrompt() {
    // Implement me!
  }

  func downloadImageAssets() {
    PhotoManager.sharedManager.downloadPhotosWithCompletion() {
      error in
      // This completion block currently executes at the wrong time
      let message = error?.localizedDescription ?? "The images have finished downloading"
      let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
}
