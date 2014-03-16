//
//  DataSource.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PageSet;
@class Tag;

@interface DataSource : NSObject

+(void)getTimezoneOffset;
+(NSArray*)getTagNames;
+(NSArray*)refreshTagNames;
+(NSArray*)getPopularTags;
+(Tag*)getTagByName:(NSString*)name;
+(Tag*)getNextPopularTag;
+(NSArray*)getNotifications;
+(NSArray*)getRecordingsForTagName:(NSString*)tagName;
+(NSArray*)getMyRecordings;
+(void)updateFacebookFriends;

@end
