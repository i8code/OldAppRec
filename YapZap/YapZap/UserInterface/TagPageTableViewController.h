//
//  TagPageTableViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagTableViewCell;
@class TagPageViewController;

@interface TagPageTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableIndexSet *expandedSections;
@property (nonatomic, strong) NSString* tagName;
@property (nonatomic, strong) NSArray* recordings;
@property (weak, nonatomic) TagPageViewController* parentTagViewController;
-(void)refresh;
-(void)commentPressed:(UITableViewCell*)cell;
@property (nonatomic, weak) YapZapMainViewController* delegate;
-(void)playNext:(TagTableViewCell*)sender;
-(void)playAll;
@end
