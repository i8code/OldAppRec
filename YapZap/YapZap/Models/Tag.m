//
//  Tag.m
//  YapZap
//
//  Created by Jason R Boggess on 2/17/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Tag.h"

@implementation Tag


+(Tag*)fromJSON:(NSDictionary*)jsonDictionary{
    
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    
    Tag* tag = [[Tag alloc] init];
    
    tag._id = [jsonDictionary valueForKey:@"_id"];
    tag.name = [jsonDictionary valueForKey:@"name"];
    tag.popularity = [[jsonDictionary valueForKey:@"popularity"] doubleValue];
    tag.childrenLength = [[jsonDictionary valueForKey:@"children_length"] integerValue];
    tag.mood = [[jsonDictionary valueForKey:@"mood"] doubleValue];
    tag.intensity = [[jsonDictionary valueForKey:@"intensity"]doubleValue];
    
    tag.createdDate = [dateFormatter dateFromString:[jsonDictionary valueForKey:@"created_date"]];
    tag.lastUpdate = [dateFormatter dateFromString:[jsonDictionary valueForKey:@"last_update"]];
    
    return tag;
}

@end