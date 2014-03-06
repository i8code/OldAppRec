//
//  MyRecordingsCell.h
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagTableViewCell.h"

@interface MyRecordingsCell : UITableViewCell
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

- (IBAction)trashPressed:(id)sender;

@end
