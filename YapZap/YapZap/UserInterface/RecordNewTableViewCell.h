//
//  RecordNewTableCell.h
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"

@interface RecordNewTableViewCell : UITableViewCell
- (IBAction)recordPressed:(id)sender;
@property (nonatomic, strong) Recording* parentRecording;
@property (nonatomic, weak) YapZapMainViewController* delegate;
@end
