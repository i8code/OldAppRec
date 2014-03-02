//
//  RestHelper.m
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "RestHelper.h"
#import "AuthHelper.h"
#import "Reachability.h"

@implementation RestHelper

#define PORT 3000
#define PROTOCOL @"http"
#define HOST @"localhost"

+(NSDictionary*)addAuth:(NSDictionary*)query{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithCapacity:query.count+3];
    
    [dictionary addEntriesFromDictionary:query];
    [dictionary addEntriesFromDictionary:[AuthHelper getTokens]];
    return dictionary;
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
    [components setScheme:PROTOCOL];
    [components setHost:HOST];
    [components setPort:[NSNumber numberWithInteger:PORT]];
    
    
    //Update Query
    query = [self addAuth:query];
    NSString* queryStr = @"";
    
    for (NSString* key in query){
        queryStr = [NSString stringWithFormat:@"%@&%@=%@", queryStr, [self urlEncode:key], [self urlEncode:query[key] ]];
    }
    [components setQuery:queryStr];
    [components setPath:stub];
    
    return[components URL];
}

+(NSString*)getDataFromRequestPath:(NSString*)path withQuery:(NSDictionary*)query withHttpType:(NSString*)type andBody:(NSString*)body{
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    NSURL* url = [self getFullPath:path withQuery:query];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:type];
    if (body){
        NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    [request setURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"GET" andBody:nil];
}
+(NSString*)post:(NSString*)url withBody:(NSString*)body andQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"POST" andBody:body];
}
+(NSString*)put:(NSString*)url  withBody:(NSString*)body andQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"PUT" andBody:body];
}
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"DELETE" andBody:nil];
}

@end
