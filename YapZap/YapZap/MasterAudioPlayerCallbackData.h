//
//  MasterAudioPlayerCallbackData.h
//  YapZap
//
//  Created by Jason R Boggess on 3/16/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recording.h"

@interface MasterAudioPlayerCallbackData : NSObject

@property (nonatomic) NSUInteger state;
@property (nonatomic) CGFloat percentPlayed;
@property (nonatomic, strong) Recording* recording;

@end
