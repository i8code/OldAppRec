//
//  TagCloudViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "TagCloudViewController.h"
#import "DataSource.h"
#import "Tag.h"
#import "Util.h"
#import "CloudTagElement.h"
#import "TagPageViewController.h"
#import "NotificationTableViewController.h"

@interface TagCloudViewController ()

@property (nonatomic, strong) NSArray* popularTags;
@property (nonatomic, strong) NSArray* buttons;
@property CGFloat canvasWidth;
@property CGFloat canvasHeight;
@property CGFloat tagPositions;
@property (nonatomic, strong) NSTimer* timer;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeRight;

@property (nonatomic, strong) void (^gotoTagBlock)(Tag*);

@end

@implementation TagCloudViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)updateTagPositions{
    self.tagPositions+=.005;
    for (CloudTagElement* cloudEl in self.buttons){
        [cloudEl setPosition:self.tagPositions];
    }
    
    if (self.tagPositions>self.canvasWidth){
        self.tagPositions=-2;
    }
    
//    NSLog(@"%f", self.tagPositions/self.canvasWidth);
    
}

-(void)fetchTags{
    [self.timer invalidate];
    self.timer = nil;
    self.activityIndicator.hidden = NO;
    for (CloudTagElement* cloudEl in self.buttons){
        [cloudEl removeFromSuperView];
    }
    
    self.tagPositions=-2;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.popularTags = [DataSource getPopularTags];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* buttons = [[NSMutableArray alloc] init];
            
            
            int count=0;
            self.canvasWidth = self.cloudView.frame.size.width*self.popularTags.count/40;
            self.canvasHeight = self.cloudView.frame.size.height;
            
            for (Tag* tag in self.popularTags){
                
                int y = (count%7);
                int x = (count/7);
                
                count++;
                
                CGPoint position = CGPointMake(
                                               10+x*self.canvasWidth/10.0 + (arc4random() % 5)+30*(y%2),
                                               10+y*self.canvasHeight/8.0 + (arc4random() % 10)+15*(x%3));
                
                int depth = (arc4random() % 20)+80;
                CloudTagElement* element = [[CloudTagElement alloc] initWithTag:tag position:position andDepth:depth andCanvasWidth:self.canvasWidth inView:self.cloudView andOnclick:self.gotoTagBlock];
                
                [buttons addObject:element];
            }
            
            self.buttons = buttons;
            
            self.activityIndicator.hidden = YES;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateTagPositions) userInfo:nil repeats:YES];
            
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak YapZapMainViewController* __parent = self.parent;
    __block UINavigationController* nav = self.navigationController;
    __block UIView* __view = self.view;
    self.gotoTagBlock = ^(Tag* tag) {
        __view.hidden = YES;
        TagPageViewController* tagPageViewController = [[TagPageViewController alloc] initWithNibName:@"TagPageViewController" bundle:nil];
        [tagPageViewController setParent:__parent];
        [tagPageViewController setTag:tag];
        [nav pushViewController:tagPageViewController animated:YES];
    };
	// Do any additional setup after loading the view.
    [self fetchTags];
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRight];
    
    if (!self.notificationView){
        self.notificationView = [[NotificationTableViewController alloc] initWithNibName:@"NotificationTableViewController" bundle:nil];
        [self addChildViewController:self.notificationView];
        [self.notificationView.view setFrame:self.historyView.bounds];
        [self.historyView addSubview:self.notificationView.view];
    }
    
    self.parent.homeButton.hidden=YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.hidden=NO;
    self.parent.homeButton.hidden=YES;
    self.parent.background.filterColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)swipedRight:(UIGestureRecognizer*)recognizer {
    self.gotoTagBlock([DataSource getNextPopularTag]);
}
@end
