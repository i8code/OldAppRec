//
//  EpisodePageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexedViewController.h"

@class TagTableViewController;
@class TagPage;
@class MarqueeLabel;

@interface EpisodeViewController : IndexedViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) MarqueeLabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewArea;
@property (strong, nonatomic) TagTableViewController* tableView;

@property (strong, nonatomic) TagPage* tagPage;
@end
