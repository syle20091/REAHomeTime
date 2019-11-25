//
//  Constants.swift
//  HomeTime
//
//  Created by syle on 25/11/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

struct Constants {
    struct Service {
        static let tokenUrl = "http://ws3.tramtracker.com.au/TramTracker/RestService/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS"
        static let urlTemplate = "http://ws3.tramtracker.com.au/TramTracker/RestService/GetNextPredictedRoutesCollection/{STOP_ID}/78/false/?aid=TTIOSJSON&cid=2&tkn={TOKEN}"
    }
}
