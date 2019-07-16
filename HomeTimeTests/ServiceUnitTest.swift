//
//  ServiceUnitTest.swift
//  HomeTimeTests
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import XCTest
@testable import HomeTime

class ServiceUnitTest: XCTestCase {
    
    var serviceToken: TramDataService!
    var serviceTramData: TramDataService!
    
    override func setUp() {
        let mockToken = MockTokenSession()
        serviceToken = TramDataService(session: mockToken)
        
        let mock = MockTramDataSession()
        serviceTramData = TramDataService(session: mock, token: "token")
    }
    
    func testFetchToken() {
        let exceptation = XCTestExpectation(description: "Fetch token")
        
        serviceToken.fetchApiToken { (token, error) in
            if error != nil {
                XCTFail()
            }
            XCTAssert(token == "some-valid-device-token")
            exceptation.fulfill()
        }
        
        self.wait(for: [exceptation], timeout: 10.0)
    }
    
    func testLoadTramData() {
        let exceptation = XCTestExpectation(description: "Fetch tram data")
        
        serviceTramData.loadTramDataUsing(stopId: "id") { (tram, error) in
            if error != nil {
                XCTFail()
            }
            XCTAssert(tram?.first?.PredictedArrivalDateTime == "/Date(1426821588000+1100)/")
            XCTAssert(tram?.first?.Destination == "melbourne")
            XCTAssert(tram?.first?.RouteNo == "22")
            exceptation.fulfill()
        }
        
        self.wait(for: [exceptation], timeout: 10.0)
    }
}


