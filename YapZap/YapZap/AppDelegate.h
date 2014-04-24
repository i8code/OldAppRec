//
//  AppDelegate.h
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL hasAuthedWithFacebook;
@property (nonatomic) BOOL enteredApp;

-(void)goToLoginView;
-(void)goToHomeView;
-(void)gotoLoadingView;
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
@end
