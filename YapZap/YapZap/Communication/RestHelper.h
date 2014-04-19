//
//  RestHelper.h
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject<NSURLConnectionDataDelegate>

#define PORT 8080
#define PROTOCOL @"http"
#define HOST @"10.0.0.4"

+(void)get:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(void)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(void)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(void)del:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
@end
