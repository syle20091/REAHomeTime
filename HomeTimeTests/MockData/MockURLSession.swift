//
//  MockURLSession.swift
//  HomeTimeTests
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
        print("mock resume")
    }
}

//Mock data session to test fetch token
class MockTokenSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let jsonString =  """
{
"responseObject" :
  [
    {
      "DeviceToken": "some-valid-device-token"
    }
  ]
}
"""
        let data = jsonString.data(using: .utf8)!
        completionHandler(data, nil, nil)
        
        return MockURLSessionDataTask()
    }
}

//Mock data session to test fetch TramData
class MockTramDataSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let jsonString =  """
{
"responseObject" :
  [
    {
    "Destination": "melbourne",
    "PredictedArrivalDateTime": "/Date(1426821588000+1100)/",
    "RouteNo": "22"
    }
  ]
}
"""
        let data = jsonString.data(using: .utf8)!
        completionHandler(data, nil, nil)
        
        return MockURLSessionDataTask()
    }
}

//Mock fail session to test
class MockFailSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let jsonString =  """
{
"FailresponseObject" :
  
}
"""
        let data = jsonString.data(using: .utf8)!
        completionHandler(data, nil, nil)
        
        return MockURLSessionDataTask()
    }
}


