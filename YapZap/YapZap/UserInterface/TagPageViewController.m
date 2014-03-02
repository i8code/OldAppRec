//
//  TagPageViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagPageViewController.h"

#import "Tag.h"
#import "Recording.h"
#import "DataSource.h"
#import "MarqueeLabel.h"
#import "Util.h"
#import "FilteredImageView.h"
#import "TagPageTableViewController.h"
@interface TagPageViewController ()

@property(nonatomic, strong)NSArray* recordings;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeLeft;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeRight;
@property(nonatomic, strong)MarqueeLabel* titleLabel;
@property(nonatomic, strong)TagPageTableViewController* tableController;
@end

@implementation TagPageViewController

@synthesize tag = _tag;

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
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.parent.homeButton.hidden = NO;
    
    if (!self.swipeRight){
        self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
        self.swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:self.swipeRight];
    }
    
    
    if (!self.swipeLeft){
        self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
        self.swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:self.swipeLeft];
    }
    
    self.view.hidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTag:(Tag *)tag
{
    _tag = tag;
    [self loadRecordingsForTag];
}

-(Tag*)tag{
    return _tag;
}

-(void)loadRecordingsForTag{
    self.activityIndicator.hidden=NO;
    
    if (!self.titleLabel){
        MarqueeLabel* marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10,0,300,45) duration:4.0 andFadeLength:15.0f];
        marqueeLabel.text = self.tag.name;
        marqueeLabel.font = [UIFont fontWithName:@"Futura" size:24];
        marqueeLabel.textAlignment = NSTextAlignmentCenter;
        marqueeLabel.autoresizesSubviews = NO;
        marqueeLabel.textColor = [UIColor whiteColor];
        marqueeLabel.backgroundColor = [UIColor clearColor];
        marqueeLabel.opaque=NO;
        [self.view addSubview:marqueeLabel];
        self.titleLabel = marqueeLabel;
    }
    self.titleLabel.text = self.tag.name;
    [self.titleLabel restartLabel];
    
    self.parent.background.filterColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.recordings = [DataSource getRecordingsForTagName:self.tag.name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.tableController){
                [self.tableController removeFromParentViewController];
                [self.tableController.view removeFromSuperview];
            }
            
            self.tableController = [[TagPageTableViewController alloc] initWithNibName:@"TagPageTableViewController" bundle:nil];
            [self.tableController setRecordings:self.recordings];
            
            [self addChildViewController:self.tableController];
            [self.tableArea addSubview:self.tableController.view];
            [self.tableController didMoveToParentViewController:self];
            [self.tableController.view setFrame:self.tableArea.bounds];
            self.activityIndicator.hidden=YES;
            
        });
        
    });
    
}


-(void)swipedRight:(UIGestureRecognizer*)recognizer{
    //Go to Random Tag
    self.view.hidden=YES;
    TagPageViewController* tagPageViewController = [[TagPageViewController alloc] initWithNibName:@"TagPageViewController" bundle:nil];
    [tagPageViewController setParent:self.parent];
    [tagPageViewController setTag:[DataSource getNextPopularTag]];
    [self.navigationController pushViewController:tagPageViewController animated:YES];
    [self removeFromParentViewController];
}
-(void)swipedLeft:(UIGestureRecognizer*)recognizer{
    
    self.view.hidden=YES;
    //Go home
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
