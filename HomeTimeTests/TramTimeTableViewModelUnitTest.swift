//
//  TramTimeTableViewModelUnitTest.swift
//  HomeTimeTests
//
//  Created by syle on 16/7/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import XCTest
@testable import HomeTime

class TramTimeTableViewModelUnitTest: XCTestCase {
    var viewModel: TramTimeTableViewModel!
    
    override func setUp() {
        let mock = MockTramDataSession()
        let serviceTramData = TramDataService(session: mock, token: "token")
        viewModel = TramTimeTableViewModel(tramDataService: serviceTramData)
    }
    
    func testIsLoading(){
        XCTAssert(viewModel.isLoading(section: 0) == false)
        XCTAssert(viewModel.isLoading(section: 1) == false)
    }
    
    func testloadTramDataUsingStopId(){
        let exceptation = XCTestExpectation(description: "Fetch tram data")
        
        viewModel.loadTramDataUsing(stopId: "4055") { (error) in
            if error != nil {
                XCTFail()
            }else{
                XCTAssert(self.viewModel.northTrams?.count == 1)
            }
            
            exceptation.fulfill()
        }
        
        self.wait(for: [exceptation], timeout: 10.0)
    }
    
    func testGetTextLabel(){
        viewModel.loadTramDataUsing(stopId: "4055") { (error) in
            if error != nil {
                XCTFail()
            }else{
                let label = self.viewModel.getTextLabel(section: 0, row: 0)
                XCTAssert(label == "14:19 pm")
            }
        }
    }
}

