//
//  YapZapParentViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapViewController.h"
#import "LocalyticsSession.h"


@implementation YapZapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[LocalyticsSession shared] tagScreen:NSStringFromClass([self class])];
}

@end
