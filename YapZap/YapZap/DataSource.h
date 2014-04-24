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

+(void)getTimezoneOffset:(void(^)(void))completion;
+(void)getTagNames:(void(^)(NSArray* tagNames))completion;
+(void)refreshTagNames:(void(^)(NSArray* tagNames))completion;
+(void)getPopularTags:(void(^)(NSArray* popularTags))completion;
+(void)getNextPopularTag:(void(^)(Tag* tag))completion;
+(void)getTagByName:(NSString*)name completion:(void(^)(Tag* tag))completion;
+(void)getNotifications:(void(^)(NSArray* notifications))completion;
+(void)getRecordingsForTagName:(NSString*)tagName completion:(void(^)(NSArray* recordings))completion;
+(void)getMyRecordings:(void(^)(NSArray* myRecordings))completion;
+(void)updateFacebookFriends;

@end
