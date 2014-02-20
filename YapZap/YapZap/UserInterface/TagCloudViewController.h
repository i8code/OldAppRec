//
//  TagCloudViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"
#import "YapZapMainViewController.h"

@interface TagCloudViewController : YapZapMainViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *cloudView;

-(void)updateTagPositions;

@end
