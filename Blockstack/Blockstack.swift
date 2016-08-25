//
//  Blockstack.swift
//  Blockstack
//
//  Created by Jorge Tapia on 8/25/16.
//  Copyright © 2016 Blockstack.org. All rights reserved.
//

import Foundation
import Alamofire

/// iOS client for blockstack-server.
public class Blockstack {

    /// Onename API app id.
    private var appId: String?
    
    /// Onename API app secret.
    private var appSecret: String?
    
    /// Initializes the Blockstack client for iOS.
    /// - Parameters:
    ///     - appId: The app id obtained from the [Onename API](http://api.onename.com).
    ///     - appSecret: The app secrect obtained from the [Onename API](http://api.onename.com).
    public init(appId: String, appSecret: String) {
        self.appId = appId
        self.appSecret = appSecret
    }
    
    /// Processes the app id and app secret into a valid Authorization header value.
    ///
    /// - Returns: A valid Authorization header value based on the app id and app secret.
    private func getAuthenticationValue() -> String? {
        let credentialsString = "\(self.appId):\(self.appSecret)"
        let credentialsData = credentialsString.dataUsingEncoding(NSUTF8StringEncoding)
        
        return "Basic \(credentialsData?.base64EncodedStringWithOptions([]))"
    }
    
}

// MARK: - User operations

extension Blockstack {
    
    /// Looks up the data for one or more users by their usernames.
    ///
    /// - Parameters:
    ///     - users: Username(s) to look up.
    ///     - completion: Closure containing an object with a top-level key for each username looked up or an error.
    ///                   Each top-level key contains an sub-object that has a "profile" field and a "verifications" field.
    public func lookup(users users: [String], completion: (response: AnyObject?) -> Void) {
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"]).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                completion(response: JSON)
            }
        }
    }
    
}
