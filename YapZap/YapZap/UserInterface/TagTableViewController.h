//
//  TagTableViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagTableViewCell;

@interface TagTableViewController : UITableViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, strong) NSArray *records;

-(void)setCell:(TagTableViewCell*)cell playing:(bool)playing;

@end
