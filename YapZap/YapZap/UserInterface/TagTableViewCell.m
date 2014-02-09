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

@implementation TagTableViewCell

@synthesize recording = _recording;

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    self.label.text = recording.firstName;
    
    //TODO set image
    
    [self.waveFormImage setImage:[UIImage imageNamed:@"sample_waveform.png"]];
    self.waveFormImage.filterColor = [Util colorFromMood:recording.mood andIntesity:recording.intensity];
//    [self.waveFormImage setPercent:0.5];
//    [self.waveFormImage setPartialFill:YES];
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
        self.waveFormImage.filterColor = [Util colorFromMood:self.recording.mood andIntesity:self.recording.intensity];
        [self.waveFormImage setAlpha:1];
    }
    else{
        self.waveFormImage.filterColor = [UIColor blackColor];
        [self.waveFormImage setAlpha:0.1];
    }
}

- (IBAction)playClicked:(id)sender {
    [self.delegate setCell:self playing:YES];
}

@end
