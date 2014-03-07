//
//  MyRecordingsCell.h
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagTableViewCell.h"
#import "MyRecordingsTableViewController.h"

@interface MyRecordingsCell : UITableViewCell <UIAlertViewDelegate>
@property(nonatomic, weak) MyRecordingsTableViewController* parent;
@property(nonatomic, weak) IBOutlet UILabel* tagLabel;

@property (strong, nonatomic) Recording* recording;
@property (weak, nonatomic) IBOutlet WaveformView *waveFormImage;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
- (IBAction)likePressed:(id)sender;
- (IBAction)commentSelected:(id)sender;
- (IBAction)playClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)trashPressed:(id)sender;

@end
