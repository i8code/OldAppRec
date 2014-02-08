//
//  EpisodePageViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "EpisodeViewController.h"
#import "TagTableViewController.h"

@interface EpisodeViewController ()

@end

@implementation EpisodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[TagTableViewController alloc] initWithNibName:@"TagTableViewController" bundle:nil];
    
    self.tableView.view.frame = CGRectMake(0, 0, self.tableViewArea.frame.size.width, self.tableViewArea.frame.size.height);
    [self addChildViewController:self.tableView];
    
    
    [[self tableViewArea] addSubview:[self.tableView view]];
    [self.tableView didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
