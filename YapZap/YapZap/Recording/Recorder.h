//
//  Recorder.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordingInfo;

@interface Recorder : NSObject


@property float* waveformData;
@property (nonatomic, strong) RecordingInfo* lastInfo;
@property BOOL isRecoring;
-(void)start;
-(RecordingInfo*)stop;

-(Recorder*)initWithSeconds:(int)seconds;

@end
