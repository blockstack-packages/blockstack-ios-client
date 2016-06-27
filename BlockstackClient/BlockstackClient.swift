//
//  BlockstackClient.swift
//  BlockstackClient
//
//  Created by Jorge Tapia on 6/27/16.
//  Copyright © 2016 Blockstack.org. All rights reserved.
//

import Foundation

/// iOS client for blockstack-server.
public struct BlockstackClient {

    /// Onename API app id.
    private static var appId: String?
    
    /// Onename API app secret.
    private static var appSecret: String?
    
    /// Error domain for BlockstackClient errors.
    private static let errorDomain = "BlockstackClientErrorDomain"
    
    public static func initialize(appId appId: String?, appSecret: String?) {
        self.appId = appId
        self.appSecret = appSecret
    }
    
    /// Detemines if the app id, app scret and Endpoints.plist file are set and valid.
    ///
    /// - Returns: Boolean value indicating wether the client is valid or not.
    private static func clientIsValid() -> Bool {
        if appId != nil && appSecret != nil {
            return true
        }
        
        return false
    }
    
    /// Processes the app id and app secrets into a valid Authorization header value.
    ///
    /// - Returns: A valid Authorization header value based on the app id and app secret.
    private static func getAuthenticationValue() -> String? {
        if clientIsValid() {
            let credentialsString = "\(appId):\(appSecret)"
            let credentialsData = credentialsString.dataUsingEncoding(NSUTF8StringEncoding)
            
            return "Basic \(credentialsData?.base64EncodedStringWithOptions([]))"
        }
        
        print("Client is not valid. Did you forget to initialize the client?")
        return nil
    }
    
}

// MARK: - User operations

extension BlockstackClient {

    /// Looks up the data for one or more users by their usernames.
    ///
    /// - Parameters:
    ///     - users: Username(s) to look up.
    ///     - completion: Closure containing an object with a top-level key for each username looked up or an error.
    ///                   Each top-level key contains an sub-object that has a "profile" field and a "verifications" field.
    public static func lookup(users: [String], completion: (response: JSON?, error: NSError?) -> Void) {
        if clientIsValid() {
            if let lookupURL = NSURL(string: "\(Endpoints.lookup)/\(users.joinWithSeparator(","))") {
                let request = NSMutableURLRequest(URL: lookupURL)
                request.setValue(getAuthenticationValue(), forHTTPHeaderField: "Authorization")
                
                let lookupTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completion(response: nil, error: error)
                        return
                    }
                    
                    if let data = data {
                        completion(response: JSON(data: data), error: nil)
                    }
                }
                
                lookupTask.resume()
            }
        } else {
            print("Client is not valid. Did you forget to initialize the client?")
        }
    }

}
