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
#import "UIAlertView+Blocks.h"


#ifdef DEBUG
@interface SSLIgnorer : NSObject <NSURLConnectionDelegate>
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end

@implementation SSLIgnorer

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
    return [[challenge sender] useCredential:[NSURLCredential credentialForTrust:serverTrust]
                  forAuthenticationChallenge:challenge];
}

@end

#endif

@implementation RestHelper


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
    
    //Update Query
    query = [self addAuth:query];
    NSString* queryStr = @"";
    
    for (NSString* key in query){
        queryStr = [NSString stringWithFormat:@"%@&%@=%@", queryStr, [self urlEncode:key], [self urlEncode:query[key] ]];
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        NSURLComponents *components = [NSURLComponents new];
        [components setScheme:PROTOCOL];
        [components setHost:HOST];
        [components setPort:[NSNumber numberWithInteger:PORT]];
        [components setQuery:queryStr];
        [components setPath:stub];
        
        return[components URL];
    }
    else{
        NSString* baseURLString = [NSString stringWithFormat:
                                   @"%@://%@:%d%@?%@",
                                   PROTOCOL,
                                   HOST,
                                   PORT,
                                   stub,
                                   queryStr];
                                   
        return [NSURL URLWithString:baseURLString];
    }
    
   
}

+(NSString*)getDataFromRequestPath:(NSString*)path withQuery:(NSDictionary*)query withHttpType:(NSString*)type andBody:(NSData*)body{
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView showWithTitle:@"Connection Error" message:@"You must be connected to the internet to use this app." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [[LocalyticsSession shared] tagEvent:@"Could not connect to server"];
                exit(EXIT_FAILURE);
            }];
            
        });
        return nil;

    }
    
    NSURL* url = [self getFullPath:path withQuery:query];
    NSLog(@"%@ %@", type, [url absoluteString]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:type];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (body){
//        NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    [request setURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] >= 400){
        NSString* error = [NSString stringWithFormat:@"Error getting %@. HTTP status code %li", url, (long)[responseCode statusCode]];
        NSLog(@"%@", error);
        [[LocalyticsSession shared] tagEvent:error];
        return nil;
    }
    else if (!oResponseData && [type isEqualToString:@"GET"]){
        NSString* error = [NSString stringWithFormat:@"Server data was nil from %@. HTTP status code %li", url, (long)[responseCode statusCode]];
        NSLog(@"%@", error);
        [[LocalyticsSession shared] tagEvent:error];
        return nil;
    }
    
    NSString* response = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response:\n%@\n", response);
    
    return response;
}

+(NSString*)get:(NSString*)url withQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"GET" andBody:nil];
}
+(NSString*)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"POST" andBody:body];
}
+(NSString*)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"PUT" andBody:body];
}
+(NSString*)del:(NSString*)url withQuery:(NSDictionary*)query{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"DELETE" andBody:nil];
}

@end
