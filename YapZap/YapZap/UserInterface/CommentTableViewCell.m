//
//  RecordingTableViewCell.m
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
@synthesize recording = _recording;

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

-(void)setRecording:(Recording *)recording{
    _recording = recording;
    //TODO
}

@end