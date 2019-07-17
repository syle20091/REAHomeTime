//
//  Copyright © 2017 REA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import HomeTime

// MARK: -

class ViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("ViewController") {
            var viewController: TramTimeTableViewController?
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: "TramTimeTableViewController") as? TramTimeTableViewController
                _ = viewController?.view // .view // load it up
            }
            
            it("should have sections for north and south") {
                let sections = viewController?.tramTimesTable.numberOfSections
                
                expect(sections) == 2
            }
            
            it("should initialize no tram data") {
                let tramsTable = viewController?.tramTimesTable
                
                let north = tramsTable?.numberOfRows(inSection: 0)
                expect(north) == 1
                
                let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramTimeTableViewCell
                let placeholder = placeholderCell.timeLabel?.text
                expect(placeholder?.hasPrefix("No upcoming trams")) == true
                
                let south = tramsTable?.numberOfRows(inSection: 1)
                expect(south) == 1
            }
            
            it("should display arriveDateTime on table after load api response") {
                let mock = MockTramDataSession()
                let serviceTramData = TramDataService(session: mock, token: "token")
                
                viewController?.viewModel = TramTimeTableViewModel(tramDataService: serviceTramData)
                viewController?.loadTramData()
                
                let tramsTable = viewController?.tramTimesTable
                let northTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramTimeTableViewCell
                expect(northTramCell.timeLabel?.text) == "02:19 pm"
                
                let southTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 1)) as! TramTimeTableViewCell
                expect(southTramCell.timeLabel?.text) == "02:19 pm"
            }
            
            it("should clear data on table after clear button was clicked") {
                viewController?.clearTramData()
                
                let tramsTable = viewController?.tramTimesTable
                
                let north = tramsTable?.numberOfRows(inSection: 0)
                expect(north) == 1
                
                let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramTimeTableViewCell
                let placeholder = placeholderCell.timeLabel?.text
                expect(placeholder?.hasPrefix("No upcoming trams")) == true
                
                let south = tramsTable?.numberOfRows(inSection: 1)
                expect(south) == 1
            }
            
            it("should display errorBanner when loading with wrong session data") {
                let mock = MockFailSession()
                let serviceTramData = TramDataService(session: mock, token: "token")
                
                viewController?.viewModel = TramTimeTableViewModel(tramDataService: serviceTramData)
                viewController?.loadTramData()
                
                let label = viewController?.view.viewWithTag(89999) as! UILabel

                expect(label.alpha) == 1
            }
            
            it("should dismiss errorBanner when clear was clicked") {
                
                viewController?.clearTramData()
                
                let label = viewController?.view.viewWithTag(89999) as! UILabel
                
                expect(label.alpha) == 0
            }
            
        }
        
    }
}
