//
//  MasterAudioPlayer.m
//  YapZap
//
//  Created by Jason R Boggess on 3/16/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "MasterAudioPlayer.h"
#import "Recording.h"
#import "S3Helper.h"
#import "MasterAudioPlayerCallbackData.h"
#import "MasterPlayerListener.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MasterAudioPlayer()
@property (nonatomic, strong) NSArray* recordingSet;
@property (nonatomic) NSInteger currentRecording;
@property (nonatomic) NSUInteger state;
@property (nonatomic) CGFloat percentPlayed;
@property (nonatomic) CGFloat playTime;
@property (nonatomic) CGFloat totalTime;
@property (nonatomic, strong) NSTimer* timer;
@property(nonatomic, strong) AVAudioPlayer* player;

@end

@implementation MasterAudioPlayer


+(MasterAudioPlayer*)instance{
    static MasterAudioPlayer* me;
    if (!me){
        me = [[MasterAudioPlayer alloc] init];
    }
    return me;
}


-(void)play:(Recording*)recording fromTagSet:(NSArray*)recordings{
    
    self.recordingSet = nil;
    
    //Find out if this is a comment or not
    for (int i=0;i<recordings.count;i++){
        
        Recording* parentRecording = recordings[i];
        
        if ([parentRecording._id isEqualToString:recording._id]){
            //Parent set
            self.recordingSet = recordings;
            self.currentRecording = i;
            goto breakloop;
        }
        
        for (int j=0;j<parentRecording.childrenLength;j++){
            Recording* childRecording = parentRecording.children[j];
            
            if ([childRecording._id isEqualToString:recording._id]){
                //comment set
                self.recordingSet = parentRecording.children;
                self.currentRecording = j;
                goto breakloop;
            }
        }
    }
            
    breakloop:;
    
    if (!self.recordingSet || self.recordingSet.count==0){
        return;
    }
    
    [self play:self.currentRecording];
    
    [self downloadAllInCurrentSet:(self.currentRecording+1)%self.recordingSet.count];
    
}

-(void)setMediaInformation{
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    Recording* rec = self.recordingSet[self.currentRecording];

    if (playingInfoCenter) {
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  rec.tagName, MPMediaItemPropertyTitle,
                                  [Util trimUsername:rec.username ], MPMediaItemPropertyArtist,
                                  [NSNumber numberWithLong:(self.currentRecording+1)], MPMediaItemPropertyAlbumTrackNumber,
                                  [NSNumber numberWithLong:self.recordingSet.count], MPMediaItemPropertyAlbumTrackCount,
                                  @"YapZap", MPMediaItemPropertyAlbumTitle,
                                  nil];
        center.nowPlayingInfo = songInfo;
    }
}

-(void)playCurrent{
    if (!self.recordingSet || self.recordingSet.count==0){
        return;
    }
    [self play: self.currentRecording];
}

-(void)play:(NSInteger)i{
    if (i>=self.recordingSet.count || i<0){
        self.state = MA_STOPPED;
        return;
    }
    self.currentRecording = i;
    self.state = MA_DOWNLOADING;
    self.percentPlayed = 0;
    [self setMediaInformation];
    if (!self.timer){
        self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer
                                     forMode:NSRunLoopCommonModes];
    }
    if (![self recordingDownloaded:self.recordingSet[i]]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadRecording:self.recordingSet[i]];
        });
    }
}

-(void)tick{
    self.percentPlayed = 0;
    if (self.state==MA_DOWNLOADING){
//        NSLog(@"Downloading");
        //Check to see if we've downloaded
        if ([self recordingDownloaded:self.recordingSet[self.currentRecording]]){
            self.state=MA_PLAYING;
            self.percentPlayed = 0;
            self.playTime = 0;
            
            NSURL* path = [self getFileURL:self.recordingSet[self.currentRecording]];
            
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
//            static AVAudioSession* session;
//            
//            if (!session){
//                session = [[AVAudioSession alloc] init];
//                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//            }
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//            [[AVAudioSession sharedInstance] setActive: YES error: nil];
//            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            [self.player play];
        }
    }
    else if (self.state==MA_PLAYING){
//        NSLog(@"Playing");
        self.playTime+=0.1;
        self.percentPlayed = self.playTime/10.0f;
        Recording* recording =self.recordingSet[self.currentRecording];
        
        if (self.playTime>=10*(recording.waveformData.count/430.f)){
            //Goto next
            [self.player stop];
            [self next];
        }
        
    }
    else if (self.state==MA_STOPPED){
//        NSLog(@"Stopped");
        [self.player stop];
        [self.timer invalidate];
        self.timer = nil;
    }
    
    MasterAudioPlayerCallbackData* callbackData = [[MasterAudioPlayerCallbackData alloc] init];
    callbackData.percentPlayed = self.percentPlayed;
    callbackData.recording = self.recordingSet[self.currentRecording];
    callbackData.state = self.state;
    
    [self.audioListener audioStateChanged:callbackData];
}


-(void)togglePlayback{
    if (self.state==MA_PLAYING || self.state==MA_DOWNLOADING){
        self.state = MA_STOPPED;
    }
    else {
        [self playCurrent];
    }
}

-(NSURL*)getFileURL:(Recording*) recording{
    NSURL *furl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:recording.audioUrl]];
    return furl;
}

-(BOOL)recordingDownloaded:(Recording*)recording{
    NSURL* path = [self getFileURL:recording];
    return [[NSFileManager defaultManager] fileExistsAtPath:[path path]];
}
-(void)downloadRecording:(Recording*)recording{
    NSURL* path = [self getFileURL:recording];
    NSData* data = [S3Helper fileFromS3WithName:recording.audioUrl];
    [data writeToFile:[path path] atomically:YES];
}

-(void)downloadAllInCurrentSet:(NSInteger)starting{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i=0;i<self.recordingSet.count;i++) {
            Recording* recording = self.recordingSet[(i+starting)%self.recordingSet.count];
            
            if (![self recordingDownloaded:recording]){
                [self downloadRecording:recording];
            }
        }
    });
    
}
-(void)next{
    [self play:self.currentRecording+1];
    
}
-(void)previous{
    [self play:self.currentRecording-1];
}
-(void)stop{
    self.state = MA_STOPPED;
}

-(void)setUpHeadsetListener{
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioSessionPropertyListener, nil);
}

BOOL isHeadsetPluggedIn()
{
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route
                                              );
    NSLog(@"%@", route);
    return (!error && (route != NULL) && ([(__bridge  NSString*)route rangeOfString:@"Head"].location != NSNotFound));
}

void audioSessionPropertyListener(void* inClientData, AudioSessionPropertyID inID,UInt32 inDataSize, const void* inData)
{
    if (!isHeadsetPluggedIn())
    {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    }
    else
    {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }
    
}
@end
