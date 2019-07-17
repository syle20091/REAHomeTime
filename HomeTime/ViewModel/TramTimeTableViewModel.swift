//
//  TramTimeTableViewModel.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TramTimeTableViewModel {
    
    private var northTrams: [TramData]?
    private var southTrams: [TramData]?
    public private(set) var loadingNorth: Bool = false
    public private(set) var loadingSouth: Bool = false
    
    var tramDataService: TramDataService!
    
    init(tramDataService: TramDataService) {
        self.tramDataService = tramDataService
    }
    
    /// This function takes tram stopId and will try to load the tram timetable data.
    /// - Parameter stopId: stopId
    /// - Parameter completion: The completion handler to call when the load request is complete
    /// - Parameter error: possible error
    func loadTramDataUsing(stopId: String,completion: @escaping (_ error: Error?) -> Void) {
        startLoading()
        tramDataService.loadTramDataUsing(stopId: stopId) {[weak self] (trams, error) in
            if let error = error {
                completion(error)
            }else{
                if stopId == "4055"{
                    self?.northTrams = trams
                    self?.stopLoadingHorth()
                }else{
                    self?.southTrams = trams
                    self?.stopLoadingSouth()
                }
                completion(nil)
            }
        }
    }
    /// Get the sum NorthTrams time table
    func getNorthTramsCount() -> Int? {
        return northTrams?.count
    }
    /// Get the sum SouthTrams time table
    func getSouthTramsCount() -> Int? {
        return southTrams?.count
    }
    
    func clearTramData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
    }
    
    private func stopLoadingHorth() {
        loadingNorth = false
    }
    
    private func stopLoadingSouth() {
        loadingSouth = false
    }
    
    private func startLoading() {
        loadingNorth = true
        loadingSouth = true
    }
    
    func tramsFor(section: Int) -> [TramData]? {
        return (section == 0) ? northTrams : southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == 0) ? loadingNorth : loadingSouth
    }
    
    /// This function takes section and row interger and return text for each row of the table view.
    /// - Parameter section: section of indexPath
    /// - Parameter row: row of indexPath
    /// - returns: textLabel
    func getTramArrivedText(section: Int, row: Int) -> String? {
        let trams = tramsFor(section: section)
        let tram = trams?[row]
        
        if tram == nil {
            if isLoading(section: section) {
                return "Loading upcoming trams..."
            } else {
                return "No upcoming trams. Tap load to fetch"
            }
        }
        let dateConverter = DotNetDateConverter()
        guard let arrivalDateString = tram?.PredictedArrivalDateTime else {
            return nil
        }
        
        return dateConverter.formattedDateFromString(arrivalDateString).lowercased()
    }
    
    /// This function takes section interger and return time table for the Destination of the tram.
    /// - Parameter section: section of indexPath
    /// - returns: Destination text
    func getDestinationWith(section: Int) -> String? {
        guard let trams = tramsFor(section: section), let destination = trams.first?.Destination else {
            return nil
        }
        return destination
    }
    
    /// This function takes section and row interger and return time interval between now and tram arrived time by string.
    /// - Parameter section: section of indexPath
    /// - Parameter row: row of indexPath
    /// - Parameter currentDate: date to compare default is current date
    /// - returns: time interval between now and tram arrived time
    func getTimeInterval(section: Int, row: Int, currentDate: Date = Date()) -> String {
        
        let dateConverter = DotNetDateConverter()
        let trams = tramsFor(section: section)
        
        if let tramArrivedDate = trams?[row].PredictedArrivalDateTime, let tramDate = dateConverter.dateFromDotNetFormattedDateString(tramArrivedDate) {
            return "( \(currentDate.calculateTimeDifference(date: tramDate).timeIntervelInstring) )"
        }
        
        return ""
    }
}
