//
//  RestHelper.m
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "RestHelper.h"

@implementation RestHelper

+(void)addAuth:(NSDictionary*)query{
    
    
}

+(NSString*)urlEncode:(NSString*)string{
   return (NSString *)CFBridgingRelease(
            CFURLCreateStringByAddingPercentEscapes(NULL,
                        (__bridge CFStringRef) string,
                        NULL,
                        CFSTR("!*'();:@&=+$,/?%#[]\" "),
                        kCFStringEncodingUTF8));
}

+(NSURL*)getFullPath:(NSString*)stub withQuery:(NSDictionary*)query{
    
    NSURLComponents *components = [NSURLComponents new];
    [components setScheme:@"http"];
    [components setHost:@"localhost"];
    [components setPort:[NSNumber numberWithInteger:9000]];
    
    NSString* queryStr = @"";
    
    for (NSString* key in query){
        queryStr = [NSString stringWithFormat:@"%@&%@=%@", queryStr, [self urlEncode:key], [self urlEncode:query[key] ]];
    }
    [components setQuery:queryStr];
    [components setPath:stub];
    
    return[components URL];
}

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query{
    return nil;
}
+(NSString*)post:(NSString*)url withQuery:(NSDictionary*)query{
    return nil;
}
+(NSString*)put:(NSString*)url withQuery:(NSDictionary*)query{
    return nil;
}
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query{
    return nil;
}

@end
