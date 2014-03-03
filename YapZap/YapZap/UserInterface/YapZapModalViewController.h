//
//  YapZapModalViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/24/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YapZapMainViewController;

@interface YapZapModalViewController : YapZapViewController

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* homeButton;
@property (nonatomic, strong) UIButton* settingsButton;
@property (weak, nonatomic) YapZapMainViewController* parent;
-(void)homePressed:(id)sender;
-(void)backPressed:(id)sender;
@end
