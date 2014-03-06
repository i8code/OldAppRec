//
//  Player.m
//  YapZap
//
//  Created by Jason R Boggess on 3/6/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Player.h"
#import <AVFoundation/AVFoundation.h>

@interface Player()
@property(nonatomic, strong) AVAudioPlayer* player;
@end
@implementation Player

-(Player*)initWithPath:(NSString*)path{
    self = [super init];
    if (self){
        
        NSURL *soundFileURL = [NSURL fileURLWithPath:path];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
    }
    return self;
}

-(void)play{
    
    [self.player play];
}
-(void)pause{
    [self.player pause];
}
-(void)resume{
    [self.player play];
}
-(void)stop{
    [self.player stop];
}

@end
