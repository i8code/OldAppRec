//
//  SharingBundle.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordingInfo;
@class Recording;
@interface SharingBundle : NSObject

@property (nonatomic, strong) RecordingInfo* recordingInfo;
@property (nonatomic, strong) UIImage* waveformImage;
@property CGFloat moodHue;
@property CGFloat intensity;
@property (nonatomic, strong) NSString* tagName;
@property (nonatomic, strong) NSString* parentName;
@property (nonatomic) BOOL comment;
@property(nonatomic, strong) NSString* filename;
+(SharingBundle*)getCurrentSharingBundle;
+(void)clear;
-(void)setMoodAndIntensity:(UIColor*)color;
-(NSURL*)getRecordingPath;
-(Recording*)asNewRecording;
@end
