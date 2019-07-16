//
//  TramTimeTableViewModel.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TramTimeTableViewModel {
    var northTrams: [TramData]?
    var southTrams: [TramData]?
    var loadingNorth: Bool = false
    var loadingSouth: Bool = false
    
    var tramDataService: TramDataService!
    
    init(tramDataService: TramDataService) {
        self.tramDataService = tramDataService
    }
    
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
    
    func clearTramData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
    }
    
    func stopLoadingHorth() {
        loadingNorth = false
    }
    
    func stopLoadingSouth() {
        loadingSouth = false
    }
    
    func startLoading() {
        loadingNorth = true
        loadingSouth = true
    }
    
    func tramsFor(section: Int) -> [TramData]? {
        return (section == 0) ? northTrams : southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == 0) ? loadingNorth : loadingSouth
    }
    
    func getTextLabel(section: Int, row: Int) -> String? {
        let trams = tramsFor(section: section)
        let tram = trams?[row]
        
        if tram == nil {
            if isLoading(section: section) {
                return "Loading upcoming trams..."
            } else {
                return "No upcoming trams. Tap load to fetch"
            }
        }
        
        guard let arrivalDateString = ConvertTime(date: tram?.PredictedArrivalDateTime) else {
            return nil
        }
        
        return arrivalDateString
    }
    
    func ConvertTime(date: String?) -> String? {
        let dateConverter = DotNetDateConverter()
        
        if let arrivalDateString = date {
            return dateConverter.formattedDateFromString(arrivalDateString).lowercased()
        }
        
        return nil
    }
    
}
