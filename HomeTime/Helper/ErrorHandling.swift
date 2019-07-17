//
//  ErrorHandling.swift
//  HomeTime
//
//  Created by syle on 17/7/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

enum JSONError: Error {
    case serialization
}

extension JSONError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serialization:
            return NSLocalizedString("Serialization error", comment: "")
        }
    }
}
