//
//  BlockstackClient.swift
//  BlockstackClient
//
//  Created by Jorge Tapia on 6/27/16.
//  Copyright © 2016 Blockstack.org. All rights reserved.
//

import Foundation
import SwiftyJSON

/// iOS client for blockstack-server.
public struct BlockstackClient {

    /// Onename API app id.
    private static var appId: String?
    
    /// Onename API app secret.
    private static var appSecret: String?
    
    /// Prevents default instantiation
    private init() {}
    
    /// Initializes the Blockstack client for iOS.
    /// - Parameters:
    ///     - appId: The app id obtained from the [Onename API](http://api.onename.com).
    ///     - appSecret: The app secrect obtained from the [Onename API](http://api.onename.com).
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
    public static func lookup(users users: [String], completion: (response: JSON?, error: NSError?) -> Void) {
        if clientIsValid() {
            if let lookupURL = NSURL(string: "\(Endpoints.lookup)/\(users.joinWithSeparator(","))") {
                let request = NSMutableURLRequest(URL: lookupURL)
                request.setValue(getAuthenticationValue(), forHTTPHeaderField: "Authorization")
                
                let searchTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                    if error != nil {
                        completion(response: nil, error: error)
                        return
                    }
                    
                    if let data = data {
                        completion(response: JSON(data: data), error: nil)
                    }
                }
                
                searchTask.resume()
            }
        } else {
            print("Client is not valid. Did you forget to initialize the client?")
        }
    }
    
    /// Takes in a search query and returns a list of results that match the search.
    /// The query is matched against +usernames, full names, and twitter handles by default.
    /// It's also possible to explicitly search verified Twitter, Facebook, Github accounts, and verified domains.
    /// This can be done by using search queries like twitter:itsProf, facebook:g3lepage, github:shea256, domain:muneebali.com
    ///
    /// - Parameters:
    ///     - query: The text to search for.
    ///     - completion: Closure containing an array of results, where each result has a "profile" object or an error.
    public static func search(query query: String, completion: (response: JSON?, error: NSError?) -> Void) {
        if clientIsValid() {
            if let searchURL = NSURL(string: "\(Endpoints.search)\(query)") {
                let request = NSMutableURLRequest(URL: searchURL)
                request.setValue(getAuthenticationValue(), forHTTPHeaderField: "Authorization")
                
                let searchTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                    if error != nil {
                        completion(response: nil, error: error)
                        return
                    }
                    
                    if let data = data {
                        completion(response: JSON(data: data), error: nil)
                    }
                }
                
                searchTask.resume()
            }
        } else {
            print("Client is not valid. Did you forget to initialize the client?")
        }
    }
    
    /// Returns an object with "stats", and "usernames".
    /// "stats" is a sub-object which in turn contains a "registrations" field that reflects a running count of the total users registered.
    /// "usernames" is a list of all usernames in the namespace.
    ///
    /// - Parameter completion: Closure with and object that contains "stats" and "usernames" or an error.
    public static func allUsers(completion: (response: JSON?, error: NSError?) -> Void) {
        if clientIsValid() {
            if let allUsersURL = NSURL(string: Endpoints.allUsers) {
                let request = NSMutableURLRequest(URL: allUsersURL)
                request.setValue(getAuthenticationValue(), forHTTPHeaderField: "Authorization")
                
                let allUsersTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                    if error != nil {
                        completion(response: nil, error: error)
                        return
                    }
                    
                    if let data = data {
                        completion(response: JSON(data: data), error: nil)
                    }
                }
                
                allUsersTask.resume()
            }
        } else {
            print("Client is not valid. Did you forget to initialize the client?")
        }
    }

}
