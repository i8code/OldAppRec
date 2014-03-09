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
        [cloudEl setTime:self.tagPositions];
    }
}

- (NSArray*)shuffleArray:(NSArray*)array {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
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
            
            NSInteger third = self.popularTags.count/3+1;
            //First create all tag elements
            for (int i=0;i<self.popularTags.count;i++){
                Tag* tag = self.popularTags[i];
                int pop = ((2-i/third)*2)+1;
                CloudTagElement* element = [[CloudTagElement alloc] initWithTag:tag withPopularity:pop inView:self.cloudView andOnclick:self.gotoTagBlock];
                [buttons addObject:element];
            }
            
            NSArray* cloudElements = [self shuffleArray:buttons];
            
            int numberOfFlows=1;
            self.canvasHeight = self.cloudView.frame.size.height;
            
            CGFloat rowHeight = 25.0f;
            CGFloat nRows =(int)(self.canvasHeight/rowHeight-1);
            
            CGFloat* rowDepths = (CGFloat*)malloc(sizeof(CGFloat)*nRows);
            
            for (int i=0;i<nRows;i++){
                rowDepths[i]=0;
            }
            
            int timestamp = 0;
            int numPlaced= 0;
            
            for (int i=0;i<cloudElements.count;){
                if (numPlaced>numberOfFlows){
                    numPlaced=0;
                    timestamp+=(arc4random()%20)+15;
                    continue;
                }
                
                //Try to place this element
                CloudTagElement* element = cloudElements[i];
                
                //Find all the places it can fit
                int elementSpan = element.height/rowHeight+1;
                NSMutableArray* slots = [[NSMutableArray alloc] init];
                for (int j=0;j<nRows;j++){
                    if (j+elementSpan>nRows){
                        break;
                    }
                    BOOL works = true;
                    for (int k=0;k<elementSpan;k++){
                        if (rowDepths[k+j]>=timestamp){
                            works=false;
                            break;
                        }
                    }
                    
                    if (works){
                        [slots addObject:[NSNumber numberWithInt:j]];

                    }
                }
                
                //Check to see if it can be placed
                if (!slots.count){
                    timestamp+=15;
                    continue;
                }
                
                //Pick a random place to put it
                int selection = (arc4random()%slots.count);
                NSInteger slot = [slots[selection] integerValue];
                CGPoint position = CGPointMake(timestamp, slot*rowHeight+30);
                [element setPosition:position];
                numPlaced++;
                
                for (int k=0;k<elementSpan;k++){
                    rowDepths[k+slot]=timestamp+element.width*1.25f;
                }
//                rowDepths[slot+elementSpan/2]=timestamp+element.width;
                
                i++;
                
                NSLog(@"\nTimestamp:%d", timestamp);
                for (int j=0;j<nRows;j++){
                    NSLog(@"%f", rowDepths[j]);
                }
                
                
            }
            
            self.buttons = cloudElements;
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
        UIViewController* topViewController = nil;
        if (nav.childViewControllers.count>1){
            topViewController = [[nav childViewControllers] objectAtIndex:nav.childViewControllers.count-1];
        }
        topViewController.view.hidden = YES;
        [nav pushViewController:tagPageViewController animated:YES];
        [topViewController removeFromParentViewController];
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
-(void)gotoTagWithName:(NSString*)name{
    Tag* tag = [DataSource getTagByName:name];
    self.gotoTagBlock(tag);
}
- (void)swipedRight:(UIGestureRecognizer*)recognizer {
    self.gotoTagBlock([DataSource getNextPopularTag]);
}
@end
