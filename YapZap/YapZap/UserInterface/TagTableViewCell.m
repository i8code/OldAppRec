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
#import "RestHelper.h"
#import "User.h"
#import "CoreDataManager.h"
#import "S3Helper.h"
#import "Player.h"
#import "TagPageViewController.h"

@interface TagTableViewCell()
@property  (nonatomic, strong) NSTimer* timer;
@property  NSInteger timerCount;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL likeIncludedInCount;
@property (nonatomic, strong) Player* player;

@end

@implementation TagTableViewCell

@synthesize recording = _recording;
@synthesize timer = _timer;
@synthesize isPlaying = _isPlaying;
@synthesize comment = _comment;
@synthesize isSelected = _isSelected;
@synthesize liked = _liked;

-(void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (isPlaying){
        [self.parentTagViewController setCurrentlyPlayingCell:self];
    }
}

-(void)setLiked:(BOOL)liked{
    _liked = liked;
    UIImage* likeImage = _liked?[UIImage imageNamed:@"heart_full.png"]:[UIImage imageNamed:@"heart_empty.png"];
    [self.likeButton setImage:likeImage forState:UIControlStateNormal];
    
    self.likesLabel.textColor = _liked?[UIColor blackColor]:[UIColor whiteColor];
    NSUInteger likes = self.recording.likes;
    if (!self.liked && self.likeIncludedInCount){
        likes--;
    }
    else if (self.liked && !self.likeIncludedInCount){
        likes++;
    }
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", likes];
}

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.label.text = recording.displayName;
    
    self.likeIncludedInCount = [CoreDataManager liked:recording._id];
    self.liked = self.likeIncludedInCount;
    
    
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
    self.bottomBar.hidden=!self.isSelected && !self.comment;
    self.commentButton.hidden=self.comment;
    self.commentLabel.hidden=self.comment;
    self.spacerView.hidden=!self.comment;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.bottomBar.hidden=!self.isSelected && !self.comment;
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
    
    if (!self.isPlaying){
        return;
    }
    //[self.delegate setCell:self playing:NO];
    
    [self.player stop];
    [self.playButton setImage:[UIImage imageNamed:@"play_small_button.png"] forState:UIControlStateNormal];
        
    [self.timer invalidate];
    self.timer=nil;
    
    [self.waveFormImage setHighlightPercent:0];
    [self.waveFormImage setNeedsDisplay];
    
    self.isPlaying = false;
}

-(void)startPlaying{
    if (self.isPlaying){
        return;
    }
    self.isPlaying = true;
    [self.player play];
    
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

-(void)updateImage{
    
    self.timerCount++;
    
    [self.waveFormImage setHighlightPercent:(((float)self.timerCount)/50.0f)];
    [self.waveFormImage setNeedsDisplay];
    
    if (self.timerCount>=50*(self.recording.waveformData.count/430.f)){
        
        UITableView *tv = (UITableView *) self.superview.superview;
        UITableViewController *vc = (UITableViewController *) tv.dataSource;
        
        [((TagPageTableViewController*)vc)playNext:self];
        [self stopPlaying];
    }
    
}

- (IBAction)likePressed:(id)sender {
    self.liked = !self.liked;
    
    User* user = [User getUser];
    
    if (self.liked){
        [CoreDataManager like:self.recording._id];
        NSString* body = [NSString stringWithFormat:@"{\"username\":\"%@\"}", user.qualifiedUsername];
        NSData* bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSString* path = [NSString stringWithFormat:@"/recordings/%@/likes", self.recording._id];
        
        [RestHelper post:path withBody:bodyData andQuery:nil];
    }
    else {
        [CoreDataManager unlike:self.recording._id];
        NSString* path = [NSString stringWithFormat:@"/recordings/%@/likes/%@", self.recording._id, user.qualifiedUsername];
        [RestHelper del:path withQuery:nil];
    }
}

- (IBAction)commentSelected:(id)sender {
    UITableView *tv = (UITableView *) self.superview.superview;
    UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    [((TagPageTableViewController*)vc)commentPressed:self];
}
@end
