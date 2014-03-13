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
    if ([_notification.type isEqualToString:@"LIKE"]) {
        self.likePanel.hidden = NO;
        self.commentPanel.hidden = YES;
        
        [self.likedButton setTitle:notification.tagName forState:UIControlStateNormal];
        [self.likedButton setBackgroundColor:[Util colorFromMood:notification.mood andIntesity:notification.intensity]];
    }
    else{
        self.likePanel.hidden = YES;
        self.commentPanel.hidden = NO;
        
        
        [self.commentedButton setTitle:notification.tagName forState:UIControlStateNormal];
        [self.commentedButton setBackgroundColor:[Util colorFromMood:notification.mood andIntesity:notification.intensity]];
    }
}
- (IBAction)tagButtonPressed:(id)sender {
    YapZapMainViewController* mainController = [YapZapMainViewController getMe];
    [mainController gotoTagWithName:self.notification.tagName andRecording:self.notification.recordingId];
}
@end
