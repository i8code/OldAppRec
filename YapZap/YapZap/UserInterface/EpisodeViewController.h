//
//  EpisodePageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagTableViewController;

@interface EpisodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeLabel;
@property (weak, nonatomic) IBOutlet UIView *tableViewArea;
@property (strong, nonatomic) TagTableViewController* tableView;
@property (assign, nonatomic) NSInteger index;
@end
