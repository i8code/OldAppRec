//
//  NotificationCell.m
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "NotificationCell.h"
#import "Notification.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setNotification:(Notification *)notification{
    _notification  = notification;
    self.userBy.text = [Util trimUsername:[notification usernameBy]];
    if ([_notification.type isEqualToString:@"LIKE"] || [_notification.type isEqualToString:@"FRIEND_LIKE"]) {
        self.likePanel.hidden = NO;
        self.commentPanel.hidden = YES;
        self.yappedPanel.hidden = YES;
        
        if ([_notification.type isEqualToString:@"FRIEND_LIKE"]){
            self.likedLabel.text = @"Liked post";
        }
        else {
            self.likedLabel.text = @"Liked your";
        }
        
        
        [self.likedButton setTitle:notification.tagName forState:UIControlStateNormal];
        [self.likedButton setBackgroundColor:[Util colorFromMood:notification.mood andIntesity:notification.intensity]];
    }
    else if ([_notification.type isEqualToString:@"COMMENT"] || [_notification.type isEqualToString:@"FRIEND"] || [_notification.type isEqualToString:@"FRIEND_REC"]){
        self.likePanel.hidden = YES;
        self.commentPanel.hidden = NO;
        self.yappedPanel.hidden = YES;
        
        [self.commentedButton setTitle:notification.tagName forState:UIControlStateNormal];
        [self.commentedButton setBackgroundColor:[Util colorFromMood:notification.mood andIntesity:notification.intensity]];
    }
    else if ([_notification.type isEqualToString:@"FRIEND_TAG"]){
        self.likePanel.hidden = YES;
        self.commentPanel.hidden = YES;
        self.yappedPanel.hidden = NO;
        
        [self.yappedButton setTitle:notification.tagName forState:UIControlStateNormal];
        [self.yappedButton setBackgroundColor:[Util colorFromMood:notification.mood andIntesity:notification.intensity]];
        
    }
    else {
        self.welcomePanel.hidden = NO;
        [self.welcomeButton setTitle:notification.tagName forState:UIControlStateNormal];
    }
}
- (IBAction)tagButtonPressed:(id)sender {
    YapZapMainViewController* mainController = [YapZapMainViewController getMe];
    [mainController gotoTagWithName:self.notification.tagName andRecording:self.notification.recordingId];
}
@end
