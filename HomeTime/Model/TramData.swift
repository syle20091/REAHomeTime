//
//  TramData.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

struct TramData {
    var Destination: String?
    var PredictedArrivalDateTime: String?
    var RouteNo: String?
    
    init(json: JSONDictionary) {
        Destination = json["Destination"] as? String
        PredictedArrivalDateTime = json["PredictedArrivalDateTime"] as? String
        RouteNo = json["RouteNo"] as? String
    }
}
