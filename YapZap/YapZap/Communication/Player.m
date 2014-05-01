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

static AVAudioPlayer* lastPlayer;

-(void)clearCurrent{
    [lastPlayer stop];
    lastPlayer =nil;
}

-(Player*)initWithPath:(NSString*)path{
    self = [super init];
    if (self){
        NSURL *soundFileURL = [NSURL fileURLWithPath:path];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [[AVAudioSession sharedInstance] setActive: YES error: nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        if (lastPlayer){
            [lastPlayer stop];
            lastPlayer = nil;
        }
        
        lastPlayer = self.player;
        
    }
    return self;
}

-(void)play{
    
    float volume = [[AVAudioSession sharedInstance] outputVolume];
    
    if (!volume){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Audio" message:@"Your volume is on mute." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

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
