//
//  Extensions.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    ///This function calculate the time difference between two Date
    func calculateTimeDifference(date: Date) -> TimeInterval {
        return abs(date.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate)
    }
}

extension TimeInterval {
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var timeIntervelInstring: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes != 0 {
            return "\(minutes)m"
        } else {
            return "now"
        }
    }
}
