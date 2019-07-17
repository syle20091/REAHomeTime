//
//  TramTimeTableViewModelUnitTest.swift
//  HomeTimeTests
//
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
                XCTAssert(self.viewModel.getNorthTramsCount() == 1)
            }
            
            exceptation.fulfill()
        }
        
        self.wait(for: [exceptation], timeout: 10.0)
    }
    
    func testGetTramArrivedText(){
        viewModel.loadTramDataUsing(stopId: "4055") { (error) in
            if error != nil {
                XCTFail()
            }else{
                let label = self.viewModel.getTramArrivedText(section: 0, row: 0)
                XCTAssert(label == "02:19 pm")
            }
        }
    }
    
    func testGetTimeInterval(){
        viewModel.loadTramDataUsing(stopId: "4055") { (error) in
            if error != nil {
                XCTFail()
            }else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                let testDate = formatter.date(from: "2015/03/20 15:21")
                
                let label = self.viewModel.getTimeInterval(section: 0, row: 0, currentDate: testDate!)
                XCTAssert(label == "( 1h 1m )")
            }
        }
    }
    
    func testGetDestinationWith(){
        viewModel.loadTramDataUsing(stopId: "4055") { (error) in
            if error != nil {
                XCTFail()
            }else{
                let label = self.viewModel.getDestinationWith(section: 0)
                XCTAssert(label == "melbourne")
            }
        }
    }
}
