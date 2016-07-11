//
//  Blockstack.h
//  BlockstackClient
//
//  Created by Jorge Tapia on 7/11/16.
//  Copyright © 2016 Blockstack.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface Blockstack : NSObject

/**
 Onename API app id.
 */
@property (assign) NSString *appId;

/**
 Onename API app secret.
 */
@property (assign) NSString *appSecret;

/**
 Initializes the Blockstack client for iOS.
 
 @param appId The app id obtained from the <a href="http://api.onename.com">Onename API</a>.
 @param appSecret The app id obtained from the <a href="http://api.onename.com">Onename API</a>.
 @return An instance of the Blockstack client.
 */
- (id)initWithAppId:(NSString *)appId andAppSecret:(NSString *)appSecret;

#pragma mark - Users

/**
 Looks up the data for one or more users by their usernames.
 
 @param users Username(s) to look up.
 @param completionHandler Block containing an object with a top-level key for each username looked up or an error. Each top-level key contains an sub-object that has a "profile" field and a "verifications" field.
 */
- (void)lookupUsers:(NSArray *)users completionHandler:(void (^)(id response, NSError *error))completionHandler;

@end
