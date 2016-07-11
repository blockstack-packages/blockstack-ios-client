//
//  Blockstack.m
//  BlockstackClient
//
//  Created by Jorge Tapia on 7/11/16.
//  Copyright © 2016 Blockstack.org. All rights reserved.
//

#import "Blockstack.h"
#import "Endpoints.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation Blockstack

- (id)initWithAppId:(NSString *)appId andAppSecret:(NSString *)appSecret {
    if (self = [super init]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        self.appId = appId;
        self.appSecret = appSecret;
        
        return self;
    } else {
        return nil;
    }
}

#pragma mark - Users

- (void)lookupUsers:(NSArray *)users completionHandler:(void (^)(id response, NSError *))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:USERS_ENDPOINT parameters:nil error:nil];
    [request setValue:[self getAuthenticationValue] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completionHandler(response, error);
        } else {
            completionHandler(response, nil);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - Helpers

/**
 Processes the app id and app secret into a valid Authorization header value.
 
 @returns A valid Authorization header value based on the app id and app secret.
 */
- (NSString *)getAuthenticationValue {
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", _appId, _appSecret];
    NSData *credentialsData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *value = [NSString stringWithFormat:@"Basic %@", [credentialsData base64EncodedDataWithOptions:0]];
    
    return value;
}

@end
