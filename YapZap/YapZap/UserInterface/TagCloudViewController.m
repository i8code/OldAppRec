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

@interface TagCloudViewController ()

@property (nonatomic, strong) NSArray* popularTags;
@property (nonatomic, strong) NSArray* buttons;
@property CGFloat canvasWidth;
@property CGFloat canvasHeight;
@property CGFloat tagPositions;
@property (nonatomic, strong) NSTimer* timer;

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
            
            for (Tag* tag in self.popularTags){
                
                int y = (count%10);
                int x = (count/10);
                
                count++;
                
                CGPoint position = CGPointMake(
                                               10+x*self.canvasWidth/12.0 + (arc4random() % 40),
                                               35+y*self.canvasHeight/13.0 + (arc4random() % 30));
                
                int depth = (arc4random() % 40)+80;
                CloudTagElement* element = [[CloudTagElement alloc] initWithTag:tag position:position andDepth:depth andCanvasWidth:self.canvasWidth inView:self.cloudView];
                
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
	// Do any additional setup after loading the view.
    self.background.filterColor = [UIColor whiteColor];
    [self.background setImage:[UIImage imageNamed:@"background.png"]];
    self.canvasWidth = self.cloudView.frame.size.height*2.25;
    self.canvasHeight = self.cloudView.frame.size.height;
    [self fetchTags];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
