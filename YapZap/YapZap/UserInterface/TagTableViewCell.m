//
//  TagTableViewCell.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagTableViewCell.h"
#import "Recording.h"
#import "FilteredImageView.h"
#import "Util.h"
#import "TagTableViewController.h"
#import "WaveformView.h"

@interface TagTableViewCell()
@property  (nonatomic, strong) NSTimer* timer;
@property  NSInteger timerCount;
@property BOOL isPlaying;

@end

@implementation TagTableViewCell

@synthesize recording = _recording;
@synthesize timer = _timer;
@synthesize isPlaying = _isPlaying;

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.label.text = recording.username;
    
    [self.waveFormImage setData:recording.rawWaveformData withSize:(int)recording.waveformData.count];
    [self.waveFormImage setColor:[Util colorFromMood:recording.mood andIntesity:recording.intensity]];
    [self.waveFormImage setNeedsDisplay];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEnabled:(BOOL)enabled{
    
    self.playButton.hidden = !enabled;
    if (enabled){
        [self.waveFormImage setAlpha:1];
        
        [self.timer invalidate];
        self.timer=nil;
        [self.waveFormImage setHighlightPercent:1];
        [self.label setAlpha:1];
        [self.waveFormImage setNeedsDisplay];
        self.playButton.hidden = NO;
    }
    else{
        [self.waveFormImage setAlpha:0.1];
        [self.label setAlpha:0.1];
    }
}

-(void)stopPlaying{
    [self.delegate setCell:self playing:NO];
    [self.playButton setImage:[UIImage imageNamed:@"play_small_button.png"] forState:UIControlStateNormal];
        
    [self.timer invalidate];
    self.timer=nil;
    
    [self.waveFormImage setHighlightPercent:1];
    [self.waveFormImage setNeedsDisplay];
    
    self.isPlaying = false;
}

-(void)startPlaying{
    
    self.isPlaying = true;
    [self.delegate setCell:self playing:YES];
    [self.playButton setImage:[UIImage imageNamed:@"stop_button_small.png"] forState:UIControlStateNormal];
    
    self.timerCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    
}


- (IBAction)playClicked:(id)sender {
    if (self.isPlaying){
        [self stopPlaying];
    }
    else {
        [self startPlaying];
    }
}

-(void)updateImage{
    
    self.timerCount++;
    
    [self.waveFormImage setHighlightPercent:(((float)self.timerCount)/50.0f)];
    [self.waveFormImage setNeedsDisplay];
    
    if (self.timerCount>=50){
        [self stopPlaying];
    }
    
}

@end
