//
//  TramDataService.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TramDataService {
    
    var session: URLSession?
    var token: String?
    var jsonParsing: JsonParsing!
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        jsonParsing = JsonParsing()
    }
    
    //DI init for testing
    init(session: URLSession, token: String? = nil) {
        self.session = session
        self.token = token
        jsonParsing = JsonParsing()
    }
    
    /// This function returns a *token* string if token already fetched otherwise fetch a new one within a completion handler.
    ///
    /// - Parameter completion: The completion handler to call when the load request is complete
    /// - Parameter token: The api token to be returned.
    /// - Parameter error: possible error
    func fetchApiToken(completion: @escaping (_ token: String?, _ error: Error?) -> Void) {
        if let token = token {
            completion(token, nil)
        }else{
            loadTramApiResponseFrom(url: Constants.Service.tokenUrl) { response, error in
                let tokenObject = response?.first
                let token = tokenObject?["DeviceToken"] as? String
                
                if let token = token, error == nil  {
                    self.token = token
                    completion(token, nil)
                    print("Token: : \(String(describing: token))")
                }else{
                    completion(nil, error)
                    print("Error retrieving token: \(String(describing: error))")
                }
            }
        }
    }
    
    /// This function returns a *TramData array* within a completion handler.
    /// - Parameter stopId: tram stop id
    /// - Parameter completion: The completion handler to call when the load request is complete
    /// - Parameter tramData: TramData array to be returned.
    /// - Parameter error: possible error
    func loadTramDataUsing(stopId: String, completion: @escaping (_ tramData: [TramData]?, _ error: Error?) -> Void) {
        
        fetchApiToken { (token, error) in
            if let token = token, error == nil  {
                let tramsUrl = self.urlFor(stopId: stopId, token: token)
                
                self.loadTramApiResponseFrom(url: tramsUrl) { trams, error in
                    completion(self.jsonParsing.parsing(tramData: trams), error)
                }
            }else{
                completion(nil, error)
            }
        }
    }
    
    /// This function returns a *JSONDictionary array* within a completion handler.
    /// - Parameter url: api url
    /// - Parameter completion: The completion handler to call when the load request is complete
    /// - Parameter responseData: response data [JSONDictionary] to be returned.
    /// - Parameter error: possible error
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
    
    /// This function returns a *url string* to aid to fetch tram timetable data.
    /// - Parameter stopId: stopId
    /// - Parameter token: token
    /// - returns: complete url to retrieve the tram timetable data
    func urlFor(stopId: String, token: String) -> String {
        return Constants.Service.urlTemplate.replacingOccurrences(of: "{STOP_ID}", with: stopId).replacingOccurrences(of: "{TOKEN}", with: token)
    }
}
