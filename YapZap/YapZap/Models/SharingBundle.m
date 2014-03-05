//
//  SharingBundle.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SharingBundle.h"
#import "RecordingInfo.h"
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

+(void)clearSharingBundle{
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
    
    NSString* filename = [NSString stringWithFormat:@"%@_%@", dateStr, [User getUser].qualifiedUsername];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               filename,
                               nil];
    self.recordingURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    return self.recordingURL;
}

@end
