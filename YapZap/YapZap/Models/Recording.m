//
//  Recording.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Recording.h"

@implementation Recording



+(Recording*)fromJSON:(NSDictionary*)dictionary{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    Recording* recording = [[Recording alloc] init];
    recording._id = [dictionary valueForKey:@"_id"];
    recording.username = [dictionary valueForKey:@"username"];
    recording.popularity = [[dictionary valueForKey:@"popularity"] doubleValue];
    recording.likes = [[dictionary valueForKey:@"likes"] integerValue];
    recording.mood = [[dictionary valueForKey:@"mood"] doubleValue];
    recording.intensity = [[dictionary valueForKey:@"intensity"]doubleValue];
    
    recording.audioHash = [dictionary valueForKey:@"audio_hash"];
    recording.audioUrl = [dictionary valueForKey:@"audio_url"];
    recording.waveformData = [dictionary valueForKey:@"waveform_data"];
    
    recording.childrenLength = [[dictionary valueForKey:@"children_length"] integerValue];
    
    if (recording.childrenLength>0){
        NSArray* childrenJson = [dictionary valueForKey:@"children"];
        NSMutableArray* children = [[NSMutableArray alloc] initWithCapacity:recording.childrenLength];
        for (int i=0;i<recording.childrenLength;i++){
            Recording* child = [Recording fromJSON:childrenJson[i]];
            [children addObject:child];
        }
        recording.children = children;
    }
    
    return recording;
}
@end
