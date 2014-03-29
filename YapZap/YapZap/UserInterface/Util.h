//
//  Util.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject


+(UIColor*)colorFromMood:(CGFloat)mood andIntesity:(CGFloat)intensity;
+(CGFloat)moodFromColor:(UIColor*)color;
+(CGFloat)intenstiyFromColor:(UIColor*)color;
+(NSDateFormatter*)getDateFormatter;
+(NSString*)trimUsername:(NSString*)username;
+(void)clearSearchHistory;
+(NSArray*)mostRecentSearches;
+(void)addRecentSearch:(NSString*)term;

+(BOOL)shouldShareOnFB;
+(void)setShareOnFB:(BOOL)share;
+(BOOL)shouldShareOnTW;
+(void)setShareOnTW:(BOOL)share;
+(NSArray*)getFBWritePermissions;
+(NSArray*)getFBReadPermissions;

+(BOOL)hasYapped;
+(void)setHasYapped;


+(BOOL)hasAgreedToTerms;
+(void)setAgreedToTerms;


+(void)setDefaults;
@end
