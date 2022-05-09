//
//  UserLocationServiceTests.swift
//  UserLocationServiceTests
//
//  Created by xiAo_Ju on 2019/4/3.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import XCTest
import CoreLocation
@testable import UserLocationService

class UserLocationServiceTests: XCTestCase {
    
    var sut: UserLocationService!
    var locationProvider: LocationProviderMock!
    
    override func setUp() {
        super.setUp()
        locationProvider = LocationProviderMock()
        sut = UserLocationService(with: locationProvider)
    }
    
    override func tearDown() {
        sut = nil
        locationProvider = nil
        super.tearDown()
    }
    
    func testRequestUserLocation_NotAuthorized_ShouldRequestAuthorization() {
        // Given
        locationProvider.isUserAuthorized = false
        
        // When
        sut.findUserLocation { _, _ in }
        
        // Then
        XCTAssertTrue(locationProvider.isRequestWhenInUseAuthorizationCalled)
    }
    
    func testRequestUserLocation_Authorized_ShouldNotRequestAuthorization() {
        // Given
        locationProvider.isUserAuthorized = true
        
        // When
        sut.findUserLocation { _, _ in }
        
        // Then
        XCTAssertFalse(locationProvider.isRequestWhenInUseAuthorizationCalled)
    }
}
