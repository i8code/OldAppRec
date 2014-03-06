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

@interface DataSource()

@end

@implementation DataSource


static NSArray* _tags;

+(NSArray*)getTagNames{
    
    static NSMutableArray* tagNames;
    if (tagNames){
        return tagNames;
    }
    
    //Mock NSData *jsonData = [[SampleData getTagNameJson] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [[RestHelper get:@"/tag_names" withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* tagNamesJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    tagNames = [[NSMutableArray alloc] init];
    for (NSString* tagName in tagNamesJson){
        [tagNames addObject:tagName];
    }
    
    return tagNames;

    
}

+(NSArray*)getPopularTags{
    
//Mock    NSData *jsonData = [[SampleData getPopularTags] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [[RestHelper get:@"/tags" withQuery:nil] dataUsingEncoding:NSUTF8StringEncoding];
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
    currentTag=(currentTag+1)%_tags.count;
    return [_tags objectAtIndex:currentTag];
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
    
    NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* recDic in recordingsDic){
        [array addObject:[Recording fromJSON:recDic]];
    }
    
    return array;
}

@end
