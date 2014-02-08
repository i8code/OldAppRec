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
    
    Recording* recording = [[Recording alloc] init];
    
    recording.firstName = [dictionary objectForKey:@"firstName"];
    recording.waveformUrl = [dictionary objectForKey:@"waveformUrl"];
    recording.audioUrl = [dictionary objectForKey:@"audioUrl"];
    recording.mood = [((NSString*)[dictionary objectForKey:@"mood"]) floatValue];
    recording.intensity = [((NSString*)[dictionary objectForKey:@"intensity"]) floatValue];
    
    recording.likes = [[dictionary objectForKey:@"likes"] integerValue];
    recording.dislikes = [[dictionary objectForKey:@"dislikes"] integerValue];
    
    return recording;
}
@end
