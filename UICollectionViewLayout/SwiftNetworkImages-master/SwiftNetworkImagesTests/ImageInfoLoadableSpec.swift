//
//  ImageInfoLoadableSpec.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//


import Quick
import Nimble
@testable import SwiftNetworkImages

struct  TestImagesInfoLoader: ImageInfoLoadable {
    var dataPath: String? {
        return  Bundle.main.path(forResource: "Animals", ofType: "plist")
    }
}

class ImageInfoLoadableSpec: QuickSpec {
    override func spec() {
        describe("Loads Images Info from a plist") {
            var imagesData: SortedDictionary<String, [ImageInfo]>!
            var sections: [String]!
            beforeEach {
                imagesData = TestImagesInfoLoader().loadImagesInfo()
                sections = imagesData.sortedKeys
            }
            
            it("has multiple sections") {
                expect(sections.count).to(beGreaterThan(0))
            }
            
            it("has sorted sections") {
                expect(sections.isSorted { $0 < $1 } ).to(beTrue())
            }
            
            it("has valid image info items in sections") {
                for (idx, section) in sections.enumerated() where idx > 0 {
                    guard let imageItems = imagesData[section] else {
                        XCTFail("no image info items in section: \(section)")
                        abort()
                    }
                    expect(imageItems.count).to(beGreaterThan(0))
                    
                    for imageItem in imageItems {
                        expect(imageItem.imageCaption).toNot(beEmpty())
                        expect(imageItem.imageURLString).toNot(beEmpty())
                    }
                }
            }
        }
    }
}
