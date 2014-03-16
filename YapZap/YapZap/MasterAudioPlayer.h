//
//  MasterAudioPlayer.h
//  YapZap
//
//  Created by Jason R Boggess on 3/16/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterPlayerListener.h"
@class Recording;

@interface MasterAudioPlayer : NSObject

#define MA_PLAYING 2
#define MA_STOPPED 0
#define MA_DOWNLOADING 1

@property (nonatomic, weak) id<MasterPlayerListener> audioListener;
-(void)play:(Recording*)recording fromTagSet:(NSArray*)recordings;
-(void)next;
-(void)previous;
-(void)stop;


@end
