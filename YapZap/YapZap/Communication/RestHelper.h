//
//  RestHelper.h
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject

#define PORT 443
#define PROTOCOL @"https"
#define HOST @"yapzap.me"

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query;
+(NSString*)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query;
+(NSString*)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query;
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query;

@end
