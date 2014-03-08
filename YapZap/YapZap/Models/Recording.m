//
//  Recording.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Recording.h"
@interface Recording()
@property(nonatomic)float* rawWaveformData;

@end

@implementation Recording

@synthesize rawWaveformData = _rawWaveformData;
@synthesize displayName = _displayName;

-(NSString*)displayName{
    return [Util trimUsername:self.username];
}

-(float*)rawWaveformData{
    float* data = (float*)malloc(sizeof(float)*self.waveformData.count);
    for (int i=0;i<self.waveformData.count;i++){
        data[i] = [self.waveformData[i] floatValue];
    }
    return data;
}

+(Recording*)fromJSON:(NSDictionary*)dictionary{
    NSDateFormatter *dateFormatter = [Util getDateFormatter];
    Recording* recording = [[Recording alloc] init];
    recording._id = [dictionary valueForKey:@"_id"];
    recording.username = [dictionary valueForKey:@"username"];
    recording.parentName = [dictionary valueForKey:@"parent_name"];
    recording.tagName = [dictionary valueForKey:@"tag_name"];
    recording.parentType = [dictionary valueForKey:@"parent_type"];
    recording.popularity = [[dictionary valueForKey:@"popularity"] doubleValue];
    recording.likes = [[dictionary valueForKey:@"likes"] integerValue];
    recording.mood = [[dictionary valueForKey:@"mood"] doubleValue];
    recording.intensity = [[dictionary valueForKey:@"intensity"]doubleValue];
    
    recording.audioHash = [dictionary valueForKey:@"audio_hash"];
    recording.audioUrl = [dictionary valueForKey:@"audio_url"];
    recording.waveformData = [dictionary valueForKey:@"waveform_data"];
    
    recording.childrenLength = [[dictionary valueForKey:@"children_length"] integerValue];
    
    recording.createdDate = [dateFormatter dateFromString:[dictionary valueForKey:@"created_date"]];
    recording.lastUpdate = [dateFormatter dateFromString:[dictionary valueForKey:@"last_update"]];
    
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

-(NSDictionary*)toJSON{
    
    //For creation
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.username forKey:@"username"];
    [dictionary setObject:[NSNumber numberWithFloat:self.mood] forKey:@"mood"];
    [dictionary setObject:[NSNumber numberWithFloat:self.intensity] forKey:@"intensity"];
    [dictionary setObject:self.audioUrl forKey:@"audio_url"];
    [dictionary setObject:self.waveformData forKey:@"waveform_data"];
    
    
    return dictionary;
}
@end
