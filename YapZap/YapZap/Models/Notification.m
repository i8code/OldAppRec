//
//  Notification.m
//  YapZap
//
//  Created by Jason R Boggess on 3/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Notification.h"

@implementation Notification


+(Notification*)fromJSON:(NSDictionary*)dictionary{
    NSDateFormatter *dateFormatter = [Util getDateFormatter];
    
    Notification* notification = [[Notification alloc] init];
    notification._id = [dictionary valueForKey:@"_id"];
    notification.usernameBy = [dictionary valueForKey:@"username_by"];
    notification.usernameFor = [dictionary valueForKey:@"username_for"];
    notification.createdDate = [dateFormatter dateFromString:[dictionary valueForKey:@"created_date"]];
    notification.tagName =[dictionary valueForKey:@"tag_name"];
    notification.recordingId =[dictionary valueForKey:@"recording_id"];
    notification.type =[dictionary valueForKey:@"type"];
    notification.mood = [[dictionary valueForKey:@"mood"] doubleValue];
    notification.intensity = [[dictionary valueForKey:@"intensity"]doubleValue];
    
    return notification;
}

@end
