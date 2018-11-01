//
//  AlamofireNetworkImageServiceSpec.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//


import Quick
import Nimble
@testable import SwiftNetworkImages

// Described in details in a blog: http://www.akpdev.com/articles/2016/05/12/Quick-Shared-Assertions.html

class AlamofireNetworkImageServiceSpec: QuickSpec {
    override func spec() {
        var networkImageServiceWrapper: NetworkImageServiceWrapper!
        beforeEach {
            let networkImageService = AlamofireNetworkImageService()
            networkImageServiceWrapper = NetworkImageServiceWrapper(networkImageService: networkImageService)
        }
        itBehavesLike("a NetworkImageService") { ["networkImageService": networkImageServiceWrapper] }
    }
}

