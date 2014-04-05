//
//  DataSource.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "DataSource.h"
#import "SampleData.h"
#import "Tag.h"
#import "Recording.h"
#import "RestHelper.h"
#import "Notification.h"
#import "User.h"
#import "AuthHelper.h"
#import "UIAlertView+Blocks.h"
#import "LocalyticsSession.h"

@interface DataSource()

@end

@implementation DataSource


static NSArray* _tags;
static NSMutableArray* tagNames;

+(void)getTimezoneOffset{
    [RestHelper get:@"/time" withQuery:nil completion:^(NSString *timezoneOffsetStr) {
        if (!timezoneOffsetStr ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertView showWithTitle:@"Connection Error" message:@"Could not connect to the YapZap server. Please try again later." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [[LocalyticsSession shared] tagEvent:@"Could not connect to server"];
                    exit(EXIT_FAILURE);
                }];
                
            });
            return;
        }
        [[LocalyticsSession shared] tagEvent:@"Connected to server"];
        long response = [timezoneOffsetStr longLongValue];
        long t = (long)[[NSDate date] timeIntervalSince1970];
        [AuthHelper setTimeOffset:(response-t)];
    }];
                                   
}

+(void)getTagNames:(void(^)(NSArray*))completion{
    
    if (tagNames){
        completion(tagNames);
        return;
    }
    
    //   NSData *jsonData = [[SampleData getTagNameJson] dataUsingEncoding:NSUTF8StringEncoding];
    [RestHelper get:@"/tag_names" withQuery:nil completion:^(NSString* stringData) {
        
        NSData *jsonData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!jsonData){
            completion([[NSArray alloc] init]);
            return;
        }
        NSArray* tagNamesJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        tagNames = [[NSMutableArray alloc] init];
        for (NSString* tagName in tagNamesJson){
            [tagNames addObject:tagName];
        }
        
        completion(tagNames);

    }];
}
+(void)refreshTagNames:(void(^)(NSArray* tagNames))completion{
    tagNames = nil;
    [self getTagNames:completion];
}

+(void)getPopularTags:(void(^)(NSArray* popularTags))completion{
    
    [RestHelper get:@"/tags" withQuery:nil completion:^(NSString *responseStr) {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData){
            completion([[NSArray alloc] init]);
            return;
        }
        NSArray* tagsJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSDictionary* tagDic in tagsJson){
            [array addObject:[Tag fromJSON:tagDic]];
        }
        _tags = array;
        completion(array);

    }];
}
+(void)getNextPopularTag:(void(^)(Tag* tag))completion{
    static int currentTag =-1;
    if(_tags==nil){
        [self getPopularTags:^(NSArray *popularTags) {
            [self getNextPopularTag:completion];
        }];
        return;
    }
    if (!_tags || _tags.count==0){
        completion(nil);
        return;
    }
    currentTag=(currentTag+1)%_tags.count;
    completion([_tags objectAtIndex:currentTag]);
}

+(void)getTagByName:(NSString*)name completion:(void(^)(Tag* tag))completion{
    NSString* path = [NSString stringWithFormat:@"/tags/%@", name];
    [RestHelper get:path withQuery:nil completion:^(NSString *responseStr) {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData){
            completion(nil);
            return;
        }
        NSDictionary* tagJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        completion([Tag fromJSON:tagJson]);
    }];
}

#define NOTIFICATION_KEY @"last_notification_update"

+(void)getNotifications:(void(^)(NSArray* notifications))completion{
    if (![User getUser].username){
        completion(nil);
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"/notifications/%@", [User getUser].qualifiedUsername];
    [RestHelper get:path withQuery:nil completion:^(NSString *responseStr) {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData){
            completion(nil);
            return;
        }
        
        NSArray* notificiationsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSDictionary* note in notificiationsDic){
            [array addObject:[Notification fromJSON:note]];
        }
        
        completion(array);
    }];
}

+(void)getRecordingsForTagName:(NSString*)tagName completion:(void(^)(NSArray* recordings))completion{
    
    NSString* path = [NSString stringWithFormat:@"/tags/%@/recordings", tagName];
    [RestHelper get:path withQuery:nil completion:^(NSString *responseStr) {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData){
            completion([[NSArray alloc] init]);
        }
        
        NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSDictionary* recDic in recordingsDic){
            [array addObject:[Recording fromJSON:recDic]];
        }
        
        completion(array);
    }];
}
+(void)getMyRecordings:(void(^)(NSArray* myRecordings))completion{
    NSString* path = [NSString stringWithFormat:@"/users/%@/recordings", [User getUser].qualifiedUsername];
    
    [RestHelper get:path withQuery:nil completion:^(NSString *responseStr) {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!jsonData){
            completion([[NSArray alloc] init]);
        }
        NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSDictionary* recDic in recordingsDic){
            [array addObject:[Recording fromJSON:recDic]];
        }
        
        completion(array);
    }];
}

+(void)updateFacebookFriends{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0;i<100;i++){
            if ([User getUser].displayName){
                break;
            }
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            FBRequest* friendsRequest = [FBRequest requestForMyFriends];
            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                          NSDictionary* result,
                                                          NSError *error) {
                NSArray* friends = [result objectForKey:@"data"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    NSString* friendsJson = @"[";
                    for (NSDictionary<FBGraphUser> *friend in friends){
                        User* user = [User fromFBUser:friend];
                        friendsJson = [NSString stringWithFormat:@"%@\"%@\",", friendsJson, user.qualifiedUsername];
                    }
                    
                    NSRange lastComma = [friendsJson rangeOfString:@"," options:NSBackwardsSearch];
                    
                    
                    if(lastComma.location != NSNotFound) {
                        friendsJson = [friendsJson stringByReplacingCharactersInRange:lastComma
                                                                           withString: @"]"];
                    }
                    
                    NSData* jsonData = [friendsJson dataUsingEncoding:NSUTF8StringEncoding];
                    NSString* path = [NSString stringWithFormat:@"/friends/%@", [User getUser].qualifiedUsername];
                    [RestHelper post:path withBody:jsonData andQuery:nil completion:nil];
                });
            }];
        });
        
    });
}

@end
