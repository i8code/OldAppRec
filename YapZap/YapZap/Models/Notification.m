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
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    Notification* notification = [[Notification alloc] init];
    notification._id = [dictionary valueForKey:@"_id"];
    notification.usernameBy = [dictionary valueForKey:@"username_by"];
    notification.usernameFor = [dictionary valueForKey:@"username_for"];
    notification.createdDate = [dateFormatter dateFromString:[dictionary valueForKey:@"created_date"]];
    notification.tagName =[dictionary valueForKey:@"tag_name"];
    notification.recordingId =[dictionary valueForKey:@"recording_id"];
    notification.type =[dictionary valueForKey:@"type"];
    
    return notification;
}

@end
