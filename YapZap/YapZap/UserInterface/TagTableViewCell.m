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
#import "TagPageTableViewController.h"
#import "WaveformView.h"

@interface TagTableViewCell()
@property  (nonatomic, strong) NSTimer* timer;
@property  NSInteger timerCount;
@property BOOL isPlaying;
@property (nonatomic) BOOL liked;

@end

@implementation TagTableViewCell

@synthesize recording = _recording;
@synthesize timer = _timer;
@synthesize isPlaying = _isPlaying;
@synthesize comment = _comment;
@synthesize selected = _selected;
@synthesize liked = _liked;

-(void)setLiked:(BOOL)liked{
    _liked = liked;
    UIImage* likeImage = _liked?[UIImage imageNamed:@"heart_full.png"]:[UIImage imageNamed:@"heart_empty.png"];
    [self.likeButton setImage:likeImage forState:UIControlStateNormal];
    
    self.likesLabel.textColor = _liked?[UIColor blackColor]:[UIColor whiteColor];
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.recording.likes+(_liked?1:0)];
}

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.label.text = recording.username;
    
    self.liked = NO;
    
    
    self.commentLabel.text = [NSString stringWithFormat:@"%ld", recording.childrenLength];
    self.commentLabel.textColor = recording.childrenLength?[UIColor blackColor]:[UIColor whiteColor];
    
    
    UIImage* commentImage = recording.childrenLength?[UIImage imageNamed:@"comments_full.png"]:[UIImage imageNamed:@"comments_empty.png"];
    [self.commentButton setImage:commentImage forState:UIControlStateNormal];
    
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

-(void)setComment:(BOOL)comment{
    _comment = comment;
    self.backgroundColor = comment?[UIColor colorWithWhite:1 alpha:0.17]:[UIColor clearColor];
    self.topBar.hidden=!comment;
    self.bottomBar.hidden=!self.selected && !self.comment;
    self.commentButton.hidden=self.comment;
    self.commentLabel.hidden=self.comment;
    self.spacerView.hidden=!self.comment;
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    self.bottomBar.hidden=!self.selected && !self.comment;
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
    //[self.delegate setCell:self playing:NO];
    [self.playButton setImage:[UIImage imageNamed:@"play_small_button.png"] forState:UIControlStateNormal];
        
    [self.timer invalidate];
    self.timer=nil;
    
    [self.waveFormImage setHighlightPercent:1];
    [self.waveFormImage setNeedsDisplay];
    
    self.isPlaying = false;
}

-(void)startPlaying{
    
    self.isPlaying = true;
    //[self.delegate setCell:self playing:YES];
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

- (IBAction)likePressed:(id)sender {
    self.liked = !self.liked;
}

- (IBAction)commentSelected:(id)sender {
    UITableView *tv = (UITableView *) self.superview.superview;
    UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    [((TagPageTableViewController*)vc)commentPressed:self];
}
@end
