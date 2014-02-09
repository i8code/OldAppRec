//
//  SettingsViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

@end
