//
//  ViewControllerWithoutCLTests.swift
//  UserLocationServiceTests
//
//  Created by xiAo_Ju on 2019/4/3.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import XCTest
@testable import UserLocationService

class ViewControllerWithoutCLTests: XCTestCase {
    
    var sut: ViewControllerWithoutCL!
    var locationProvider: UserLocationProviderMock!

    override func setUp() {
        super.setUp()
        locationProvider = UserLocationProviderMock()
        sut = ViewControllerWithoutCL(locationProvider: locationProvider)
    }

    override func tearDown() {
        sut = nil
        locationProvider = nil
        super.tearDown()
    }
    
    func testRequestUserLocation_NotAuthorized_ShouldFail() {
        // Given
        locationProvider.locationBlockLocationValue = UserLocationMock()
        locationProvider.locationBlockErrorValue    = UserLocationError.canNotBeLocated
        
        // When
        sut.requestUserLocation()
        
        // Then
        XCTAssertNil(sut.userLocation)
    }
    
    func testRequestUserLocation_Authorized_ShouldReturnUserLocation() {
        // Given
        locationProvider.locationBlockLocationValue = UserLocationMock()
        
        // When
        sut.requestUserLocation()
        
        // Then
        XCTAssertNotNil(sut.userLocation)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
