//
//  YapZapMainViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/19/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilteredImageView;

@interface YapZapMainViewController : YapZapParentViewController
@property (nonatomic, strong) FilteredImageView* background;
@property (nonatomic, strong) UIButton* recordButton;
@property (nonatomic, strong) UIButton* settingsButton;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* homeButton;
@property (nonatomic, strong) UIButton* likeButton;
@property (nonatomic, strong) UIButton* searchButton;
@property (nonatomic, strong) UIViewController* mainViewController;
@property (nonatomic, strong) UIViewController* fullscreenViewController;

- (IBAction)searchPressed:(id)sender;
- (IBAction)recordingButtonPressed:(id)sender;
- (IBAction)recordingButtonLifted:(id)sender;
-(IBAction)goHome:(id)sender;
-(IBAction)goBack:(id)sender;
@end
