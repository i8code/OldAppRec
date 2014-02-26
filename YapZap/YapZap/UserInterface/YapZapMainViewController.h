//
//  YapZapMainViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/19/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilteredImageView;

@interface YapZapMainViewController : YapZapViewController
@property (nonatomic, strong) FilteredImageView* background;
@property (nonatomic, strong) UIButton* recordButton;
@property (nonatomic, strong) UIButton* settingsButton;
@property (nonatomic, strong) UIButton* homeButton;
@property (nonatomic, strong) UIButton* searchButton;
@property (nonatomic, strong) UIView* bottomBar;
@property (nonatomic, strong) UILabel* yapLabel;
@property (nonatomic, strong) UILabel* zapLabel;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIViewController* mainViewController;

- (IBAction)searchPressed:(id)sender;
- (IBAction)recordingButtonPressed:(id)sender;
-(IBAction)goHome:(id)sender;
@end
