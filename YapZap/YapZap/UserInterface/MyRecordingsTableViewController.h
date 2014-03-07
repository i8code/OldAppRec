//
//  MyRecordingsTableViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 3/1/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@interface MyRecordingsTableViewController : UITableViewController
@property(nonatomic, strong) NSArray* recordings;
@property(nonatomic, weak) SettingsViewController* delegate;
- (void)refresh;
@end
