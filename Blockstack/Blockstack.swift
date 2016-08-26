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
    private func getAuthorizationValue() -> String? {
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
    public func lookup(users users: [String], completion: (response: AnyObject?, error: NSError?) -> Void) {
        let lookupEndpoint = "\(Endpoints.users)/\(users.joinWithSeparator(","))"
        
        if let authorizationValue = getAuthorizationValue() {
            let headers = ["Authorization": authorizationValue]
            
            Alamofire.request(.GET, lookupEndpoint, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
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
    public func search(query query: String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        let searchEndpoint = "\(Endpoints.search)\(query)"
        
        if let authorizationValue = getAuthorizationValue() {
            let headers = ["Authorization": authorizationValue]
            
            Alamofire.request(.GET, searchEndpoint, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
        }
    }
    
    /// Registers a username.
    ///
    /// - Parameters:
    ///     - username: The username to be registered.
    ///     - recipientAddress: Bitcoin address of the new owner address.
    ///     - profileData: The data to be associated with the blockchain ID.
    ///     - completion: Closure a response that could include an object with an unsigned transaction "unsigned_tx" in hex format.
    public func registerUser(username: String, recipientAddress: String, profileData: [String: AnyObject]?, completion: (response: AnyObject?, error: NSError?) -> Void) {
        if let authorizationValue = getAuthorizationValue() {
            let headers = ["Authorization": authorizationValue]
            
            var params: [String: AnyObject] = ["username": username, "recipient_address": recipientAddress]
            
            if let profile = profileData {
                params["profile"] = profile
            }
            
            Alamofire.request(.POST, Endpoints.users, parameters: params, encoding: .JSON, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
        }
    }
    
    /// Updates a username.
    ///
    /// - Parameters:
    ///     - username: The username to be updated.
    ///     - profileData: The data to be associated with the blockchain ID.
    ///     - ownerPublicKey: Public key of the Bitcoin address that currently owns the username.
    ///     - completion: Closure with a response that could include an object with an unsigned transaction "unsigned_tx" in hex format.
    public func updateUser(username: String, profileData: [String: AnyObject], ownerPublicKey: String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        if let authorizationValue = getAuthorizationValue() {
            let updateEndpoint = "\(Endpoints.users)/\(username)/update)"
            
            let headers = ["Authorization": authorizationValue]
            let params: [String: AnyObject] = ["profile": profileData, "owner_pubkey": ownerPublicKey]
            
            Alamofire.request(.POST, updateEndpoint, parameters: params, encoding: .JSON, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
        }
    }
    
    /// Transfers a user to another Bitcoin address.
    ///
    /// - Parameters:
    ///     - username: The username to be transfered.
    ///     - transferAddress: Bitcoin address of the new owner address.
    ///     - ownerPublicKey: Public key of the Bitcoin address that currently owns the username.
    ///     - completion: Closure with a response that could include an object with an unsigned transaction "unsigned_tx" in hex format.
    public func transferUser(username: String, transferAddress: String, ownerPublicKey: String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        if let authorizationValue = getAuthorizationValue() {
            let updateEndpoint = "\(Endpoints.users)/\(username)/update)"
            
            let headers = ["Authorization": authorizationValue]
            let params: [String: AnyObject] = ["transfer_address": transferAddress, "owner_pubkey": ownerPublicKey]
            
            Alamofire.request(.POST, updateEndpoint, parameters: params, encoding: .JSON, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
        }
    }
    
    /// Returns an object with "stats", and "usernames".
    /// "stats" is a sub-object which in turn contains a "registrations" field that reflects a running count of the total users registered.
    /// "usernames" is a list of all usernames in the namespace.
    ///
    /// - Parameter completion: Closure with and object that contains "stats" and "usernames" or an error.
    public func allUsers(completion: (response: AnyObject?, error: NSError?) -> Void) {
        if let authorizationValue = getAuthorizationValue() {
            let headers = ["Authorization": authorizationValue]
            
            Alamofire.request(.GET, Endpoints.users, headers: headers).responseJSON { response in
                completion(response: response.data, error: response.result.error)
            }
        }
    }
    
}
