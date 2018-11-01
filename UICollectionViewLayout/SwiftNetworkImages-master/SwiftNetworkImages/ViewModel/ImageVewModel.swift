//
//  ImageViewModel.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Image View Model

struct ImageViewModel {
    let imageCaption: Observable<String>
    let imageURLString: Observable<String>
    let image: Observable<UIImage?>
    
    init() {
        imageCaption = Observable(EmptyString)
        imageURLString = Observable(EmptyString)
        image = Observable(nil)
    }
    
    var imageFetcher: ImageFetcher? {
        didSet {
            guard !self.imageURLString.value.isEqual(EmptyString),
                                        let fetcher = imageFetcher else {return}
            fetcher.fetchImage(urlString: self.imageURLString.value) { [s = self] img in
                if let img = img {
                    s.image.value = img
                }
            }
        }
    }
    private let EmptyString = ""
}

extension ImageViewModel {
    init(imageInfo: ImageInfo) {
        self.init()
        imageCaption.value = imageInfo.imageCaption
        imageURLString.value = imageInfo.imageURLString
    }
}
