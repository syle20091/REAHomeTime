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
    
    ///This function take array of JSONDictionary and parse it to array of TramData
    func parsing(tramData tramDataInput: [JSONDictionary]?) -> [TramData]? {
        guard let tramDataInput = tramDataInput else {
            return nil
        }
        
        return tramDataInput.map({ return TramData(json: $0) })
    }
}
