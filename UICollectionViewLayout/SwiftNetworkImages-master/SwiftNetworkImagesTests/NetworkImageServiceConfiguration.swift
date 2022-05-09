//
//  NetworkImageServiceSpec.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftNetworkImages


// Described in details in a blog: http://www.akpdev.com/articles/2016/05/12/Quick-Shared-Assertions.html

/// NetworkImageService wrapper,
/// needed since SharedExampleContext has a NSDictionary return type
/// and NSDictionary values can only be object types (not Swift structs)
class NetworkImageServiceWrapper {
    private(set) var networkImageService: NetworkImageService
    
    init(networkImageService: NetworkImageService) {
        self.networkImageService = networkImageService
    }
}

/// Shared Examples Configuration for the NetworkImageService tests
class NetworkImageServiceConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        var networkImageService: NetworkImageService!
        sharedExamples("a NetworkImageService") { (sharedExampleContext: @escaping SharedExampleContext) in
            beforeEach {
                guard let networkImageServiceWrapper =
                        sharedExampleContext()["networkImageService"] as? NetworkImageServiceWrapper else {
                        XCTFail("failed retrieve a networkImageService from SharedExampleContext")
                        abort()
                }
                networkImageService = networkImageServiceWrapper.networkImageService
            }
            it("eventually retrives an image") {
                var image: UIImage?
                networkImageService.requestImage(urlString: "https://httpbin.org/image/jpeg") { result in
                    expect(Thread.current.isMainThread).to(beTrue())
                    do {
                        image = try result.resolve()
                    } catch {}
                }
                expect(image).toEventuallyNot(beNil(), timeout: 10)
            }
            
            it("eventually gets an expected error if there are problems with connection") {
                var error: NetworkError?
                networkImageService.requestImage(urlString: "https://some.broken.server.com/content/image/png") { result in
                    expect(Thread.current.isMainThread).to(beTrue())
                    do {
                        _ = try result.resolve()
                    } catch let networkError as NetworkError {
                        error = networkError
                    } catch {}
                }
                expect(error).toEventually(equal(NetworkError.NetworkRequestFailed), timeout: 10)
            }
            
            it("eventually gets an expected error for handling wrong content type") {
                var error: NetworkError?
                networkImageService.requestImage(urlString: "https://httpbin.org/get") { result in
                    expect(Thread.current.isMainThread).to(beTrue())
                    do {
                        _ = try result.resolve()
                    } catch let networkError as NetworkError {
                        error = networkError
                    } catch {}
                }
                expect(error).toEventually(equal(NetworkError.NetworkRequestFailed) ||
                                           equal(NetworkError.ContentValidationFailed),
                                           timeout: 10)
            }            
        }
    }
}
