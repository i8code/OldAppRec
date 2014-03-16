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

@interface DataSource()

@end

@implementation DataSource


static NSArray* _tags;
static NSMutableArray* tagNames;

+(void)getTimezoneOffset{
    NSString* timezoneOffsetStr = [RestHelper get:@"/time" withQuery:nil];
    long response = [timezoneOffsetStr longLongValue];
    long t = (long)[[NSDate date] timeIntervalSince1970];
    [AuthHelper setTimeOffset:(response-t)];
}

+(NSArray*)getTagNames{
    
    if (tagNames){
        return tagNames;
    }
    
//   NSData *jsonData = [[SampleData getTagNameJson] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[RestHelper get:@"/tag_names" withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return [[NSArray alloc] init];
    }
    NSArray* tagNamesJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    tagNames = [[NSMutableArray alloc] init];
    for (NSString* tagName in tagNamesJson){
        [tagNames addObject:tagName];
    }
    
    return tagNames;

    
}

+(NSArray*)refreshTagNames{
    tagNames = nil;
    return  [self getTagNames];
}

+(NSArray*)getPopularTags{
    
//    NSData *jsonData = [[SampleData getPopularTags] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [[RestHelper get:@"/tags" withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return [[NSArray alloc] init];
    }
    NSArray* tagsJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* tagDic in tagsJson){
        [array addObject:[Tag fromJSON:tagDic]];
    }
    _tags = array;
    return array;
}

+(Tag*)getNextPopularTag{
    static int currentTag =-1;
    if(_tags==nil){
       [self getPopularTags];
    }
    if (!_tags || _tags.count==0){
        return nil;
    }
    currentTag=(currentTag+1)%_tags.count;
    return [_tags objectAtIndex:currentTag];
}

+(Tag*)getTagByName:(NSString*)name{
    
    NSString* path = [NSString stringWithFormat:@"/tags/%@", name];
    NSData *jsonData = [[RestHelper get:path withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return nil;
    }
    NSDictionary* tagJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    return[Tag fromJSON:tagJson];
}

#define NOTIFICATION_KEY @"last_notification_update"

+(NSArray*)getNotifications{
    if (![User getUser].username){
        return nil;
    }
    NSDate* lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATION_KEY];
    if (!lastUpdate) {
        lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    }
    
    NSMutableDictionary* query = [[NSMutableDictionary alloc] init];
    NSString* dateStr = [[Util getDateFormatter] stringFromDate:lastUpdate];
    [query setObject:dateStr forKey:@"after"];
    
    NSString* path = [NSString stringWithFormat:@"/notifications/%@", [User getUser].qualifiedUsername];
    
    NSData *jsonData = [[RestHelper get:path withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return nil;
    }
    
    NSArray* notificiationsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* note in notificiationsDic){
        [array addObject:[Notification fromJSON:note]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDate alloc] initWithTimeIntervalSinceNow:0] forKey:NOTIFICATION_KEY];
    
    return array;

}
+(NSArray*)getRecordingsForTagName:(NSString*)tagName{
    
//    NSData *jsonData = [[SampleData getRecordingsForTagName:tag Name] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* path = [NSString stringWithFormat:@"/tags/%@/recordings", tagName];
    NSData *jsonData = [[RestHelper get:path withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return [[NSArray alloc] init];
    }
    
    NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* recDic in recordingsDic){
        [array addObject:[Recording fromJSON:recDic]];
    }
    
    return array;
}

+(NSArray*)getMyRecordings{
    NSString* path = [NSString stringWithFormat:@"/users/%@/recordings", [User getUser].qualifiedUsername];
    NSData *jsonData = [[RestHelper get:path withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData){
        return [[NSArray alloc] init];
    }
    NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* recDic in recordingsDic){
        [array addObject:[Recording fromJSON:recDic]];
    }
    
    return array;
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
                    [RestHelper post:path withBody:jsonData andQuery:nil];
                    
                    NSLog(@"Found: %i facebook friends", friends.count);
                });
            }];
        });
        
    });
}

@end
