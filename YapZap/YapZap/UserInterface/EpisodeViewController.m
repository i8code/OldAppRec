//
//  EpisodePageViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "EpisodeViewController.h"
#import "TagTableViewController.h"
#import "MarqueeLabel.h"
#import "TagPage.h"
#import "Util.h"

@interface EpisodeViewController ()


@property (nonatomic, strong) TagPage* myPage;

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
    
    MarqueeLabel* marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10,50,275,35) duration:4.0 andFadeLength:15.0f];
    marqueeLabel.text = @"Season 1 Episode 500";
    marqueeLabel.font = [UIFont fontWithName:@"Futura" size:25];
    marqueeLabel.textAlignment = NSTextAlignmentCenter;
    marqueeLabel.autoresizesSubviews = NO;
    marqueeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:marqueeLabel];
    self.subTitleLabel = marqueeLabel;
    
    [[self tableViewArea] addSubview:[self.tableView view]];
    [self.tableView didMoveToParentViewController:self];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self.subTitleLabel restartLabel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.subTitleLabel restartLabel];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)getBackgroundColor{
    return [Util colorFromMood:self.myPage.mood andIntesity:self.myPage.intensity];
}

-(void)setTagPage:(TagPage*)page{
    self.myPage=page;
    self.titleLabel.text = page.title;
    self.subTitleLabel.text = page.subTitle;
    
    [self.tableView setRecords:page.recordings];
    
}

@end
