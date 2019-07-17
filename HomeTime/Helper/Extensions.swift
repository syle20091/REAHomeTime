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
    
    /// Get time interval in hours & mins
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

extension UIView {
    ///Call this function before show error banner
    func setUpErrorBanner() {
        let bounds = UIScreen.main.bounds
        let label = UILabel(frame: CGRect(x: 0, y: bounds.height - 48, width: bounds.width, height: 48))
        label.text = "OFFLINE"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.isHidden = false
        label.alpha = 0
        label.tag = 89999
        self.addSubview(label)
    }
    
    ///Call this to show error banner
    ///- Warning: Call setUpErrorBanner() before call this function
    /// - Parameter show: bool to determine show or hide the banner
    /// - Parameter error: error for display
    func errorBanner(show: Bool, error: Error? = nil) {
        guard let label = self.viewWithTag(89999) as? UILabel else {
            return
        }
        
        if show && label.alpha == 1 {return}
        if !show && label.alpha == 0 {return}
        
        label.text = error?.localizedDescription ?? "something went wrong"
        
        UIView.animate(withDuration: 0.9, animations: {
            label.alpha = show ? 1 : 0
        })
    }
}
