//
//  RecordNewTableCell.m
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "RecordNewTableViewCell.h"
#import "RecordControllerViewController.h"
#import "SharingBundle.h"

@implementation RecordNewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)recordPressed:(id)sender{
    [[SharingBundle getCurrentSharingBundle] setParentName:self.parentRecording._id];
    [[SharingBundle getCurrentSharingBundle] setComment:YES];
    [self.delegate recordingButtonPressed:sender];
}
@end
