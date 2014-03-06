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
//@class TagTableViewController;
@class WaveformView;

@interface TagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) Recording* recording;
@property (weak, nonatomic) IBOutlet WaveformView *waveFormImage;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//@property (weak, nonatomic) TagTableViewController *delegate;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIView *spacerView;
- (IBAction)likePressed:(id)sender;
- (IBAction)commentSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@property(nonatomic) BOOL comment;
@property(nonatomic) BOOL selected;

-(void)setEnabled:(BOOL)enabled;
- (IBAction)playClicked:(id)sender;

-(void)updateImage;

@end
