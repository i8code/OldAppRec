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
- (IBAction)playClicked:(id)sender{
    
}

- (IBAction)trashPressed:(id)sender {
}

@end
