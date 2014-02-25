//
//  Recorder.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "Recorder.h"
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileWriter.h"
#import "RecordingInfo.h"

@interface Recorder()

@property int blocks;
@property int count;
@property (nonatomic, assign) RingBuffer *ringBuffer;
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileWriter *fileWriter;
@property (nonatomic, strong) NSURL* currentPath;

@end
@implementation Recorder

@synthesize waveformData = _waveformData;
@synthesize lastInfo = _lastInfo;
@synthesize isRecoring = _isRecoring;


-(void)setup:(int)seconds{
    
    self.blocks = (UInt32)(seconds/0.011609977)/2;
    
    _waveformData = (float*)malloc(sizeof(float)*self.blockLength);
    [self resetData:self.blocks];
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];

}


-(int)blockLength{
    return self.blocks;
}

-(Recorder*)initWithSeconds:(int)seconds{
    self = [super init];
    if (self){
        [self setup:seconds];
    }
    
    return self;
    
}


-(void)resetData:(int)size{
    for (int i=0;i<size;i++){
        _waveformData[i]=0;
    }
}

-(NSURL*)genURL{
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"test.m4a",
                               nil];
    NSURL *url = [NSURL fileURLWithPathComponents:pathComponents];
    return url;
}


-(void)start{
    [self resetData:self.blockLength];
    self.count = 0;
    self.currentPath = [self genURL];
    NSLog(@"URL: %@", self.currentPath);
    
    __weak Recorder * wself = self;
    self.fileWriter = [[AudioFileWriter alloc]
                       initWithAudioFileURL:self.currentPath
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numInputChannels];
    
    
    self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
        [wself.fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
        
        float sum = 0;
        for (int y=0;y<numFrames;y++){
            sum+=data[y*numChannels]*data[y*numChannels];
        }
        wself.waveformData[wself.count]=sqrtf(sqrtf(sum));
        wself.count += 1;
        if (wself.count > wself.blocks) {
            wself.audioManager.inputBlock = nil;
            [wself.fileWriter pause];
            [wself stop];
        }
    };
    
    [self.audioManager play];
    self.isRecoring=true;
}
-(void)stop{
    if (!self.isRecoring){
        return;
    }
    self.audioManager.inputBlock = nil;
    [self.fileWriter pause];
    [self.audioManager pause];
    self.fileWriter = nil;
    self.isRecoring=false;
    
    int blocksFinished = MIN(self.count-1, self.blocks);
    self.count = MAXFLOAT;
    
    RecordingInfo* info = [[RecordingInfo alloc] init];
    
    [info setUrl:[self.currentPath relativePath]];
    [info setLength:blocksFinished];
    [info setData:self.waveformData];
    
    self.lastInfo = info;
    
}

@end
