//
//  TagPageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapMainViewController.h"

@class Tag;
@class Recording;

@interface TagPageViewController : YapZapViewController<YapZapMainControllerProtocol>

@property(nonatomic, strong) Tag* tag;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)swipedRight:(UIGestureRecognizer*)recognizer;
-(void)swipedLeft:(UIGestureRecognizer*)recognizer;
@property (weak, nonatomic) YapZapMainViewController* parent;
@property (weak, nonatomic) IBOutlet UIView *tableArea;

@end