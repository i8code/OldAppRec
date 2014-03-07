//
//  MyRecordingsCell.m
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "MyRecordingsCell.h"
#import "Recording.h"
#import "WaveformView.h"
#import "S3Helper.h"
#import "Player.h"

@interface MyRecordingsCell()
@property(nonatomic, strong)Player* player;
@property  (nonatomic, strong) NSTimer* timer;
@property  NSInteger timerCount;
@property BOOL isPlaying;

@end

@implementation MyRecordingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.tagLabel.text = recording.parentName;
    
    
    self.commentLabel.text = [NSString stringWithFormat:@"%ld", recording.childrenLength];
    self.commentLabel.textColor = recording.childrenLength?[UIColor blackColor]:[UIColor whiteColor];
    UIImage* commentImage = recording.childrenLength?[UIImage imageNamed:@"comments_full.png"]:[UIImage imageNamed:@"comments_empty.png"];
    [self.commentButton setImage:commentImage forState:UIControlStateNormal];
    
    
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", recording.likes];
    self.likesLabel.textColor = recording.likes?[UIColor blackColor]:[UIColor whiteColor];
    UIImage* likeImage = recording.likes?[UIImage imageNamed:@"heart_full.png"]:[UIImage imageNamed:@"heart_empty.png"];
    [self.likeButton setImage:likeImage forState:UIControlStateNormal];

    
    [self.waveFormImage setData:recording.rawWaveformData withSize:(int)recording.waveformData.count];
    [self.waveFormImage setColor:[Util colorFromMood:recording.mood andIntesity:recording.intensity]];
    [self.waveFormImage setNeedsDisplay];
    
}


- (IBAction)likePressed:(id)sender{
    
}
- (IBAction)commentSelected:(id)sender{
    
}

-(void)stopPlaying{
    //[self.delegate setCell:self playing:NO];
    
    [self.player stop];
    [self.playButton setImage:[UIImage imageNamed:@"play_small_button.png"] forState:UIControlStateNormal];
    
    [self.timer invalidate];
    self.timer=nil;
    
    [self.waveFormImage setHighlightPercent:0];
    [self.waveFormImage setNeedsDisplay];
    
    self.isPlaying = false;
}

-(void)updateImage{
    
    self.timerCount++;
    
    [self.waveFormImage setHighlightPercent:(((float)self.timerCount)/50.0f)];
    [self.waveFormImage setNeedsDisplay];
    
    if (self.timerCount>=50*(self.recording.waveformData.count/430.f)){
        [self stopPlaying];
    }
    
}

-(void)startPlaying{
    
    [self.player play];
    
    self.isPlaying = true;
    //[self.delegate setCell:self playing:YES];
    [self.playButton setImage:[UIImage imageNamed:@"stop_button_small.png"] forState:UIControlStateNormal];
    
    self.timerCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    
}
-(NSURL*)getFileURL{
    NSURL *furl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:self.recording.audioUrl]];
    
    return furl;
}


- (IBAction)playClicked:(id)sender {
    if (self.isPlaying){
        [self stopPlaying];
    }
    else {
        self.playButton.hidden = YES;
        self.loadingIndicator.hidden = NO;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL* path = [self getFileURL];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:[path path]]){
                //Download
                NSData* data = [S3Helper fileFromS3WithName:self.recording.audioUrl];
                [data writeToFile:[path path] atomically:YES];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.player = [[Player alloc] initWithPath:[path path]];
                self.loadingIndicator.hidden = YES;
                self.playButton.hidden = NO;
                [self startPlaying];
            });
        });
    }
}

- (IBAction)trashPressed:(id)sender {
}

@end
