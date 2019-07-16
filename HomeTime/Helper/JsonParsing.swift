//
//  JsonParsing.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class JsonParsing {
    init() {
        
    }
    
    func parsing(tramData tramDataInput: [JSONDictionary]?) -> [TramData]? {
        guard let tramDataInput = tramDataInput else {
            return nil
        }
        
        return tramDataInput.map({ return TramData(json: $0) })
    }
}
