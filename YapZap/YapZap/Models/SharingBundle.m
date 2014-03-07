//
//  SharingBundle.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SharingBundle.h"
#import "RecordingInfo.h"
#import "Recording.h"
#import "User.h"

@interface SharingBundle()
@property(nonatomic, strong) NSURL* recordingURL;
@end

@implementation SharingBundle

static SharingBundle* _sharingBundle;

+(SharingBundle*)getCurrentSharingBundle{
    if (_sharingBundle==nil){
        _sharingBundle = [[SharingBundle alloc] init];
    }
    
    return _sharingBundle;
}

-(id)init{
    self = [super init];
    if (self) {
        self.comment = NO;
    }
    return self;
}

+(void)clear{
    _sharingBundle = nil;
}

-(void)setMoodAndIntensity:(UIColor*)color{
    self.moodHue = [Util moodFromColor:color];
    self.intensity = [Util intenstiyFromColor:color];
    
}

-(NSURL*)getRecordingPath{
    if (self.recordingURL){
        return self.recordingURL;
    }
    
    NSDateFormatter* dateFormatter = [Util getDateFormatter];
    NSString* dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    self.filename = [NSString stringWithFormat:@"%@_%@.mp4", dateStr, [User getUser].qualifiedUsername];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               self.filename,
                               nil];
    self.recordingURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    return self.recordingURL;
}

-(Recording*)asNewRecording{
    Recording* recording = [[Recording alloc] init];
    
    /*
     
     @property (nonatomic, strong) NSString* _id;
     @property (nonatomic, strong) NSString* username;
     @property (nonatomic, strong) NSString* parentName;
     @property (nonatomic, strong) NSString* parentType;
     @property (nonatomic, strong) NSArray* children;
     @property NSInteger childrenLength;
     @property (nonatomic, strong) NSString* audioUrl;
     @property (nonatomic, strong) NSString* audioHash;
     @property (nonatomic, strong) NSArray* waveformData;
     @property float* rawWaveformData;
     
     @property CGFloat mood;
     @property CGFloat intensity;
     
     @property NSInteger likes;
     @property NSInteger popularity;
     
     @property (nonatomic, strong) NSDate* createdDate;
     @property (nonatomic, strong) NSDate* lastUpdate;
     
*/
    recording.username = [User getUser].qualifiedUsername;
    recording.parentName = self.parentName;
    if (!recording.parentName && !self.comment){
        recording.parentName = self.tagName;
    }
    recording.parentType = self.comment?@"REC":@"TAG";
    recording.children = nil;
    recording.childrenLength = 0;
    recording.audioUrl = self.filename;
    
    //Set by server :recording.audioHash
    NSMutableArray* waveformData = [[NSMutableArray alloc] initWithCapacity:self.recordingInfo.length];
    for (int i=0;i<self.recordingInfo.length;i++){
        [waveformData addObject:[[NSNumber alloc] initWithFloat:self.recordingInfo.data[i]]];
    }
    recording.waveformData = waveformData;
    recording.mood= self.moodHue;
    recording.intensity = self.intensity;
    recording.likes=0;
    recording.popularity=0;
    //Set by server :recording.createdDate
    //Set by server :recording.lastUpdate
    
    return recording;
}

@end
