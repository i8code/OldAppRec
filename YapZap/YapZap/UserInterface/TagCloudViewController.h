//
//  TagCloudViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredImageView.h"
#import "Tag.h"

@class NotificationTableViewController;

@interface TagCloudViewController : YapZapViewController<YapZapMainControllerProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *cloudView;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) YapZapMainViewController* parent;
@property (strong, nonatomic) NotificationTableViewController* notificationView;

-(void)updateTagPositions;
-(void)swipedRight:(UIGestureRecognizer*)recognizer;
-(void)gotoTag:(Tag*)tag;

@end
