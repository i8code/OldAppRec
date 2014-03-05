//
//  SharingBundle.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordingInfo;
@interface SharingBundle : NSObject

@property (nonatomic, strong) RecordingInfo* recordingInfo;
@property (nonatomic, strong) UIImage* waveformImage;
@property CGFloat moodHue;
@property CGFloat intensity;
@property (nonatomic, strong) NSString* tagName;
+(SharingBundle*)getCurrentSharingBundle;
+(void)clearSharingBundle;
-(void)setMoodAndIntensity:(UIColor*)color;
@end
