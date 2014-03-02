//
//  AuthHelper.m
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "AuthHelper.h"
#include <CommonCrypto/CommonDigest.h>


#define key @"B64E4F862CC37A8116783A02770E91CC08F08E42"
#define secret @"67989553EDCBD09B03942AB728CEC8FE5C7951F6"

@implementation AuthHelper

+ (NSString *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, (uint)keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
}

+(NSDictionary*)getTokens{
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    long t = (long)[[NSDate date] timeIntervalSince1970];
    
    NSString* prehash = [NSString stringWithFormat:@"%@%@%ld", secret, key, t];
    
    NSString* hash = [self createSHA512:prehash];
    
    [dictionary setObject:[NSString stringWithFormat:@"%ld", t] forKey:@"t"];
    [dictionary setObject:hash forKey:@"token"];
    [dictionary setObject:key forKey:@"key"];
    
    return dictionary;
}

@end
