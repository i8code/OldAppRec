//
//  LoadingViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexedViewController.h"

@interface LoadingViewController : IndexedViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
