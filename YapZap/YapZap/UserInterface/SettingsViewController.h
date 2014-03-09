//
//  SettingsViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class MyRecordingsTableViewController;
@class MyRecordingsCell;

@interface SettingsViewController : YapZapModalViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UIView *manageArea;
@property (strong, nonatomic) MyRecordingsTableViewController* myRecordingsViewController;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
- (IBAction)facebookSwitched:(id)sender;
- (IBAction)twitterSwitched:(id)sender;
@property (nonatomic, strong) MyRecordingsCell* currentlyPlayingCell;

@property (weak, nonatomic) IBOutlet UIButton *helpNeeded;
@property (strong, nonatomic) NSArray* recordings;

@end
