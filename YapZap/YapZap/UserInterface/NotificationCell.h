//
//  NotificationCell.h
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Notification;

@interface NotificationCell : UITableViewCell

@property (nonatomic) Notification* notification;
@property (weak, nonatomic) IBOutlet UIView *commentPanel;
- (IBAction)tagButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userBy;
@property (weak, nonatomic) IBOutlet UIButton *commentedButton;
@property (weak, nonatomic) IBOutlet UIButton *likedButton;
@property (weak, nonatomic) IBOutlet UIView *likePanel;
@property (weak, nonatomic) IBOutlet UIButton *welcomeButton;
@property (weak, nonatomic) IBOutlet UIView *welcomePanel;

@end
