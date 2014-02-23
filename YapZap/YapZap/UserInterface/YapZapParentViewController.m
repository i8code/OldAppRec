//
//  YapZapParentViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapParentViewController.h"

@interface YapZapParentViewController ()

@end

@implementation YapZapParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
