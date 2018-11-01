//
//  ImageInfoLoader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//
import Foundation

/// Provides structured description of Sample Images data

protocol ImageInfoLoadable {
    /// Load images info from a specified resource
    /// - returns: a sorted dictionary of [sections: items]    
    func loadImagesInfo() -> SortedDictionary<String, [ImageInfo]>?
    
    /// path to the resource to load images info from
    var dataPath: String? { get }
}

/// Implements `ImageInfoLoadable` via loading the info from a plist
extension ImageInfoLoadable {
    /// default implementation
    func loadImagesInfo() -> SortedDictionary<String, [ImageInfo]>? {
        guard let dataPath = dataPath,
              let dictArray = NSArray(contentsOfFile: dataPath) as? [[String: AnyObject]] else {return nil}

        typealias SortedImageInfo = SortedDictionary<String, [ImageInfo]>
        let imageInfos: SortedImageInfo = dictArray
            // Using reduce for building a dectionary here is mostly for the purpose of having fun :)
            // The penalty is of course resulting O(n**2) compared to that of O(n) if just 
            // looping & adding entries to a mutable dict
            .reduce ( SortedImageInfo() ) { (accumulator: SortedImageInfo,
                                             sectionInfo: [String: AnyObject]) in
                var sortedImageInfos = accumulator
                
                guard let sectionName = sectionInfo["sectionName"] as? String,
                          let sectionImagesDesc = sectionInfo["sectionImages"] as? [[String: String]]
                                                                                else { return accumulator }
                let imageInfoArray = sectionImagesDesc.flatMap { (imageDesc: [String: String]) -> ImageInfo? in
                    guard let imageCaption = imageDesc["imageCaption"],
                              let imageURLString = imageDesc["imageURL"] else {return nil}
                    return ImageInfo(imageCaption: imageCaption, imageURLString: imageURLString)
                }                
                sortedImageInfos[sectionName] = imageInfoArray
                return sortedImageInfos
            }
        return imageInfos
    }
}

struct  ImagesInfoLoader: ImageInfoLoadable {
    var dataPath: String? {
        return  Bundle.main.path(forResource: "Animals", ofType: "plist")
    }
}
