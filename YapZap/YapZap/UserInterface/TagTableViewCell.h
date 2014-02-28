//
//  TagTableViewCell.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recording;
@class FilteredImageView;
@class TagTableViewController;
@class WaveformView;

@interface TagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) Recording* recording;
@property (weak, nonatomic) IBOutlet WaveformView *waveFormImage;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) TagTableViewController *delegate;

-(void)setEnabled:(BOOL)enabled;
- (IBAction)playClicked:(id)sender;

-(void)updateImage;

@end
