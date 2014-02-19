//
//  TagCloudViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"

@interface TagCloudViewController : UIViewController
@property (weak, nonatomic) IBOutlet FilteredImageView *background;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *cloudView;

-(void)updateTagPositions;

@end
