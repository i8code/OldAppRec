//
//  RestHelper.h
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject

#define PORT 3000
#define PROTOCOL @"http"
#define HOST @"10.0.0.10"

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query;
+(NSString*)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query;
+(NSString*)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query;
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query;

@end
