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
    
    self.tagPositions+=0.03;
    for (CloudTagElement* cloudEl in self.buttons){
        [cloudEl setPosition:self.tagPositions];
    }
}

-(void)fetchTags{
    [self.timer invalidate];
    self.timer = nil;
    self.activityIndicator.hidden = NO;
    for (CloudTagElement* cloudEl in self.buttons){
        [cloudEl removeFromSuperView];
    }
    
    self.tagPositions=16;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.popularTags = [DataSource getPopularTags];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* buttons = [[NSMutableArray alloc] init];
            
            
            int numberOfFlows=4;
            self.canvasHeight = self.cloudView.frame.size.height;
            
            CGFloat rowHeight = 17.0f;
            CGFloat nRows =(int)(self.canvasHeight/rowHeight-1);
            
            CGFloat* rowDepths = (CGFloat*)malloc(sizeof(CGFloat)*nRows);
            
            for (int i=0;i<nRows;i++){
                rowDepths[i]=0;
            }
            
            long tagLength = self.popularTags.count;
            int timestamp = 0;
            
            for (int tagIndex=0;tagIndex<tagLength;){
                
                //Find available slots
                NSMutableArray* slots = [[NSMutableArray alloc] init];
                for (int i=0;i<nRows;i++){
                    if (rowDepths[i]<=timestamp){
                        [slots addObject:[NSNumber numberWithInt:i]];
                    }
                }
                
                long numberOfSelections = MIN(numberOfFlows, slots.count);
                
                NSMutableArray* selections = [[NSMutableArray alloc] initWithCapacity:numberOfSelections];
                for (int i=0;i<numberOfSelections;i++){
                    long selectedIndex =(NSUInteger)(arc4random()%slots.count);
                    NSNumber* selection = [slots objectAtIndex:selectedIndex];
                    [selections addObject:selection];
                    [slots removeObjectAtIndex:selectedIndex];
                }
                
                for (int i=0;i<numberOfSelections && tagIndex<tagLength;i++){
                    long selectedRow = [[selections objectAtIndex:i] integerValue];
                    
                    Tag* tag = [self.popularTags objectAtIndex:tagIndex];
                    
                    if (timestamp<rowDepths[selectedRow]){
                        NSLog(@"ERROR");
                    }
                    
                    
                    CGPoint position = CGPointMake(timestamp+self.cloudView.frame.size.width, (selectedRow+0.5)*rowHeight);
                    
                    int depth = 80;//(arc4random() % 20)+80;
                    CloudTagElement* element = [[CloudTagElement alloc] initWithTag:tag position:position andDepth:depth  inView:self.cloudView andOnclick:self.gotoTagBlock];
                    
                    [buttons addObject:element];
                    
                    rowDepths[selectedRow]=timestamp+self.cloudView.frame.size.width*80.0/depth/5.0+(arc4random()%5);

                    tagIndex++;
                }
                
                timestamp+=(arc4random()%20)+15;
            }
            
            CGFloat max=0;
            for (int i=0;i<nRows;i++){
                max = MAX(max, rowDepths[i]);
            }
            
            self.canvasWidth = MAX(self.cloudView.frame.size.width, max);
            self.buttons = buttons;
            
            for (CloudTagElement* element in self.buttons){
                [element setCanvasWidth:self.canvasWidth];
            }
            
            self.activityIndicator.hidden = YES;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateTagPositions) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer
                                         forMode:NSRunLoopCommonModes];
            
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
    self.parent.background.filterColor = nil;
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
