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
    }
    else{
        self.likePanel.hidden = YES;
        self.commentPanel.hidden = NO;
    }
}
- (IBAction)tagButtonPressed:(id)sender {
}
@end
