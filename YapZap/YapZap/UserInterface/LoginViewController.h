//
//  LoginViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : YapZapViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginButtonPlaceholder;
@property (strong, nonatomic) FBLoginView *loginButton;

@end
