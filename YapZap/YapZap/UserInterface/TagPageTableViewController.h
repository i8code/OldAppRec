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
@property (nonatomic, strong) NSArray* recordings;
-(void)refresh;
-(void)updateTable;
@end
