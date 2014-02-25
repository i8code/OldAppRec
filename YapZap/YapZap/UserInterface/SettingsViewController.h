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
#import "YapZapMainControllerProtocol.h"

@interface SettingsViewController : YapZapModalViewController<FBLoginViewDelegate, YapZapMainControllerProtocol>
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) YapZapMainViewController* parent;

@end
