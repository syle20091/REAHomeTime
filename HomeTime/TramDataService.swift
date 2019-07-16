//
//  TramDataService.swift
//  HomeTime
//
//  Created by syle on 15/7/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TramDataService {
    
    var session: URLSession?
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func fetchApiToken(completion: @escaping (_ token: String?, _ error: Error?) -> Void) {
        let tokenUrl = "http://ws3.tramtracker.com.au/TramTracker/RestService/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS"
        
        loadTramApiResponseFrom(url: tokenUrl) { response, error in
            let tokenObject = response?.first
            let token = tokenObject?["DeviceToken"] as? String
            completion(token, error)
            if let token = token, error == nil  {
                print("Token: : \(String(describing: token))")
            }else{
                print("Error retrieving token: \(String(describing: error))")
            }
        }
    }
    
    func loadTramDataUsing(stopId: String, completion: @escaping (_ tramData: [JSONDictionary]?, _ error: Error?) -> Void) {
        
        fetchApiToken { (token, error) in
            if let token = token, error == nil  {
                let tramsUrl = self.urlFor(stopId: stopId, token: token)
                self.loadTramApiResponseFrom(url: tramsUrl) { trams, error in
                    completion(trams, error)
                }
            }else{
                completion(nil, error)
            }
        }
    }
    
    func loadTramApiResponseFrom(url: String, completion: @escaping (_ responseData: [JSONDictionary]?, _ error: Error?) -> Void) {
        let task = session?.dataTask(with: URL(string: url)!) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else {
                do {
                    if let data = data,
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONDictionary {
                        let objects = jsonResponse["responseObject"] as? [JSONDictionary]
                        completion(objects, nil)
                    } else {
                        completion(nil, JSONError.serialization)
                    }
                } catch {
                    completion(nil, JSONError.serialization)
                }
            }
        }
        
        task?.resume()
    }
    
    func urlFor(stopId: String, token: String) -> String {
        let urlTemplate = "http://ws3.tramtracker.com.au/TramTracker/RestService/GetNextPredictedRoutesCollection/{STOP_ID}/78/false/?aid=TTIOSJSON&cid=2&tkn={TOKEN}"
        return urlTemplate.replacingOccurrences(of: "{STOP_ID}", with: stopId).replacingOccurrences(of: "{TOKEN}", with: token)
    }
}
