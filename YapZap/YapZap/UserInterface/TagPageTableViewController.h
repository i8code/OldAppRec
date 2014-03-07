//
//  TagPageTableViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/27/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagPageTableViewController : UITableViewController
{
    NSMutableIndexSet *expandedSections;
}
@property (nonatomic, strong) NSString* tagName;
@property (nonatomic, strong) NSArray* recordings;
-(void)refresh;
-(void)updateTable;
-(void)commentPressed:(UITableViewCell*)cell;
@property (nonatomic, weak) YapZapMainViewController* delegate;
@end
