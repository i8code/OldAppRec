//
//  RestHelper.h
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject<NSURLConnectionDataDelegate>

#define PORT 443
#define PROTOCOL @"https"
#define HOST @"yapzap.me"

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(NSString*)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(NSString*)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString* responseStr))completion;
@end
