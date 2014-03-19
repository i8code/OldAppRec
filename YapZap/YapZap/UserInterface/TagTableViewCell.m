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
#import "CoreDataManager.h"
#import "RecordingCoreData.h"
#import "Recording.h"
#import "MasterAudioPlayer.h"

@interface TagTableViewCell()
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL likeIncludedInCount;
@property (nonatomic) CGFloat highlightPercent;
@property (nonatomic, strong) NSTimer* highlightTimer;
@property (nonatomic) BOOL cancelRequested;

@end

@implementation TagTableViewCell

@synthesize recording = _recording;
@synthesize comment = _comment;
@synthesize isSelected = _isSelected;
@synthesize liked = _liked;
@synthesize isPlaying = _isPlaying;

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
    self.likesLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)likes];
}

-(BOOL)commentFilled{
    NSString* username = [[User getUser] qualifiedUsername];
    for (Recording* recording in self.recording.children){
        if ([recording.username isEqualToString:username]){
            return true;
        }
    }
    
    return false;
}

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.label.text = recording.displayName;
    
    self.likeIncludedInCount = [CoreDataManager liked:recording._id];
    self.liked = self.likeIncludedInCount;
    
    
    self.commentLabel.text = [NSString stringWithFormat:@"%ld", (long)recording.childrenLength];
    BOOL commentFilled = [self commentFilled];
    self.commentLabel.textColor = commentFilled?[UIColor blackColor]:[UIColor whiteColor];
    
    
    UIImage* commentImage = commentFilled?[UIImage imageNamed:@"comments_full.png"]:[UIImage imageNamed:@"comments_empty.png"];
    [self.commentButton setImage:commentImage forState:UIControlStateNormal];
    
    [self.waveFormImage setData:recording.rawWaveformData withSize:(int)recording.waveformData.count];
    [self.waveFormImage setColor:[Util colorFromMood:recording.mood andIntesity:recording.intensity]];
    [self.waveFormImage setNeedsDisplay];
    
    self.isPlaying = NO;
    
    
    RecordingCoreData* recordingData = [CoreDataManager getRecordingData:self.recording._id];
    if (recordingData){
        [self.playButton setImage:[UIImage imageNamed:@"redo_button.png"] forState:UIControlStateNormal];
        self.waveFormImage.highlightPercent = [recordingData.percent_played floatValue];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateBars{
    self.topBar.hidden=!self.comment;
    
    self.bottomBar.hidden=(!self.comment || self.last) && !self.selected;
    self.commentButton.hidden=self.comment;
    self.commentLabel.hidden=self.comment;
    self.spacerView.hidden=!self.comment;
}

-(void)setLast:(BOOL)last{
    _last = last;
    [self updateBars];
}

-(void)setComment:(BOOL)comment{
    _comment = comment;
    self.backgroundColor = comment?[UIColor colorWithWhite:1 alpha:0.17]:[UIColor clearColor];
    [self updateBars];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [self updateBars];
}



#pragma playing arguments

-(void)stopPlaying{
    if (!self.isPlaying){
        return;
    }
    
//    [self.parentTagViewController stopAudioAtCell:self];
    self.isPlaying = false;
    [self.playButton setImage:[UIImage imageNamed:@"redo_button.png"] forState:UIControlStateNormal];
    [self.waveFormImage setHighlightPercent:0];
    [self.waveFormImage setNeedsDisplay];
    
    
    [CoreDataManager setRecording:self.recording._id withPercentage:self.waveFormImage.highlightPercent];
}

- (IBAction)playClicked:(id)sender {
    if (self.isPlaying){
        [self.parentTagViewController stopAudioAtCell:self];
    }
    else {
        [self.parentTagViewController playAudioAtCell:self];
    }
}


-(void)setState:(MasterAudioPlayerCallbackData*)data{
    if (![self.recording._id isEqualToString:data.recording._id]){
        return;
    }

    switch (data.state) {
        case MA_DOWNLOADING:
            self.playButton.hidden=YES;
            self.isPlaying = true;
            self.loadingIndicator.hidden = NO;
            break;
            
        case MA_PLAYING:
            self.playButton.hidden=NO;
            self.isPlaying = true;
            self.loadingIndicator.hidden = YES;
            [self.playButton setImage:[UIImage imageNamed:@"stop_button_small.png"] forState:UIControlStateNormal];
            break;
            
        case MA_STOPPED:
            [self stopPlaying];
            break;
            
        default:
            break;
    }
    
    if (self.isPlaying){
        [self.waveFormImage setHighlightPercent:data.percentPlayed];
        [self.waveFormImage setNeedsDisplay];
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


-(void)highlight{
    self.highlightPercent=1.0;
    self.highlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateHighlight) userInfo:nil repeats:YES];
}
-(void)updateHighlight{
    CGFloat percent = self.highlightPercent;
    if (self.comment){
        percent = percent*0.83+0.17;
    }
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:percent];
    self.highlightPercent*=0.95;
    
    if (self.highlightPercent<0.01){
        [self.highlightTimer invalidate];
        self.highlightTimer = nil;
        self.backgroundColor = self.comment?[UIColor colorWithWhite:1 alpha:0.17]:[UIColor clearColor];
    }
    
}
@end
