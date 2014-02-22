//
//  SettingsViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "YapZapMainViewController.h"

@interface SettingsViewController : YapZapMainViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

@end
