//
//  TagCloudViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"

@interface TagCloudViewController : YapZapParentViewController<YapZapMainControllerProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *cloudView;
@property (weak, nonatomic) YapZapMainViewController* parent;

-(void)updateTagPositions;
-(void)swipedRight:(UIGestureRecognizer*)recognizer;

@end
