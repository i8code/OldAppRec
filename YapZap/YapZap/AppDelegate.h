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
@property (nonatomic) BOOL enteredApp;
@property (nonatomic) BOOL showingHelp;
-(void)gotoLoadingView;
-(void)goToHomeView;
@end
