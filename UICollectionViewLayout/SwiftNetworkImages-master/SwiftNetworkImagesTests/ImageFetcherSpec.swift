//
//  ImageFetcherSpec.swift
//  SwiftNetworkImagesTEsts
//
//  Created by Arseniy on 3/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

// Disabled till Quick / Nimble are converted to Swift 3

import Quick
import Nimble
@testable import SwiftNetworkImages


extension UIImage {
    enum Asset: String {
        case TestCat = "TestCat"
    }
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

class ImageFetcherSpec: QuickSpec {
    struct GoodMockImageService: NetworkImageService {
        func requestImage(urlString: String, completion: @escaping (Result<UIImage>) -> ()) {
            DispatchQueue.global(qos: .utility).async {
                sleep(1)
                guard let image = UIImage(asset: .TestCat) else {
                    return XCTFail("Coudl not load a test image from bundle!!")
                }
                DispatchQueue.main.async {
                    completion( Result.Success(image))
                }
            }
        }
    }
    struct BadMockImageService: NetworkImageService {
        func requestImage(urlString: String, completion: @escaping (Result<UIImage>) -> ()) {
            DispatchQueue.global(qos: .utility).async {
                sleep(1)
                DispatchQueue.main.async {
                    completion( Result.Failure(NetworkError.NetworkRequestFailed) )
                }
            }
        }
    }
    
    override func spec() {
        describe("Image Fetcher") {
            var imageFetcher: ImageFetcher!
            var testImage: UIImage?
            beforeEach {
                testImage = nil
                imageFetcher = ImageFetcher()
            }
            it("retrives and caches a Image from a good image service") {
                imageFetcher.inject(GoodMockImageService())
                imageFetcher.fetchImage(urlString: "https://httpbin.org/image/jpeg") { image in
                    testImage = image
                }
                expect(testImage).toEventuallyNot(beNil(), timeout: 5)
            }
            it("can live through a request to a bad image service") {
                var imageFetcher = ImageFetcher()
                imageFetcher.inject(BadMockImageService())
                imageFetcher.fetchImage(urlString: "https://httpbin.org/image/jpeg") { image in
                    if let image = image { testImage = image }
                }
                expect(testImage).toEventually(beNil(), timeout: 5)
            }
        }        
    }    
}
