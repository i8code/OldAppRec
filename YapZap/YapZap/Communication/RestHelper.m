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
#import "AppDelegate.h"


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

+(void)getDataFromRequestPath:(NSString*)path withQuery:(NSDictionary*)query withHttpType:(NSString*)type andBody:(NSData*)body retryCount:(NSInteger)retryCount completion:(void(^)(NSString*))completion{
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]){
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        if (app.showingHelp){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            app.showingHelp = true;
            [UIAlertView showWithTitle:@"Connection Error" message:@"You must be connected to the internet to use this app." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [[LocalyticsSession shared] tagEvent:@"Could not connect to server"];
                exit(EXIT_FAILURE);
            }];
            
        });
        if (completion) completion(nil);
        return;

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
    [request setTimeoutInterval:30];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError){
            if (retryCount<=0){
                completion(nil);
                return;
            }
            
            NSLog(@"Connection error: %ld", connectionError.code);
            if(connectionError.code == NSURLErrorTimedOut){
                NSLog(@"Connection time out");
            }
            
            [NSThread sleepForTimeInterval:5];
            [self getDataFromRequestPath:path withQuery:query withHttpType:type andBody:body retryCount:(retryCount-1) completion:completion];
            
            return;
        }
        
        NSHTTPURLResponse* responseCode = (NSHTTPURLResponse*)response;
        
        if ([responseCode statusCode] == 403){
            //user has been blacklisted
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertView showWithTitle:@"Account Banned" message:@"We're sorry, but you have been banned from this app for inappropriate behavior. If you believe you have been banned in error, please contact admin@yapzap.me." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [[LocalyticsSession shared] tagEvent:@"User banned"];
                    exit(EXIT_FAILURE);
                }];
                
            });
        }
        else if([responseCode statusCode] >= 400){
            NSString* error = [NSString stringWithFormat:@"Error getting %@. HTTP status code %li", url, (long)[responseCode statusCode]];
            NSLog(@"%@", error);
            [[LocalyticsSession shared] tagEvent:error];
            if (completion) completion(nil);
            return;
        }
        else if (!data && [type isEqualToString:@"GET"]){
            NSString* error = [NSString stringWithFormat:@"Server data was nil from %@. HTTP status code %li", url, (long)[responseCode statusCode]];
            NSLog(@"%@", error);
            [[LocalyticsSession shared] tagEvent:error];
            if (completion) completion(nil);
            return;
        }
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response:\n%@\n", responseStr);
        
        if (completion) completion(responseStr);
    }];
}

+(void)get:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString*))completion{
    [self getDataFromRequestPath:url withQuery:query withHttpType:@"GET" andBody:nil retryCount:10 completion:completion];
}
+(void)post:(NSString*)url withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString*))completion{
    [self getDataFromRequestPath:url withQuery:query withHttpType:@"POST" andBody:body retryCount:-1 completion:completion];
}
+(void)put:(NSString*)url  withBody:(NSData*)body andQuery:(NSDictionary*)query completion:(void(^)(NSString*))completion{
    return[self getDataFromRequestPath:url withQuery:query withHttpType:@"PUT" andBody:body retryCount:-1 completion:completion];
}
+(void)del:(NSString*)url withQuery:(NSDictionary*)query completion:(void(^)(NSString*))completion{
    [self getDataFromRequestPath:url withQuery:query withHttpType:@"DELETE" andBody:nil retryCount:10 completion:completion];
}

@end
