//
//  TagPage.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagPage.h"
#import "Recording.h"

@implementation TagPage

+(TagPage*)fromJSON:(NSDictionary*)dictionary{
    
    TagPage* page = [[TagPage alloc] init];
    
    page.title = [dictionary objectForKey:@"title"];
    page.subTitle = [dictionary objectForKey:@"subTitle"];
    page.mood = [((NSString*)[dictionary objectForKey:@"mood"]) floatValue];
    page.intensity = [((NSString*)[dictionary objectForKey:@"intensity"]) floatValue];
    
    NSArray* recordingsDictionary = [dictionary objectForKey:@"recordings"];
    NSMutableArray* recordings = [[NSMutableArray alloc] initWithCapacity:recordingsDictionary.count];
    
    for (NSDictionary* recording in recordingsDictionary){
        [recordings addObject:[Recording fromJSON:recording]];
    }
    page.recordings = recordings;
    
    return page;
}

@end
