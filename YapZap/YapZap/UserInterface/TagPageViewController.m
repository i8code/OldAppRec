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
@interface TagPageViewController ()

@property(nonatomic, strong)NSArray* recordings;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeLeft;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeRight;
@property(nonatomic, strong)MarqueeLabel* titleLabel;
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
    
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    self.swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRight];
    
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeLeft];
    

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
        MarqueeLabel* marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10,15,300,45) duration:4.0 andFadeLength:15.0f];
        marqueeLabel.text = self.tag.name;
        marqueeLabel.font = [UIFont fontWithName:@"Futura" size:32];
        marqueeLabel.textAlignment = NSTextAlignmentCenter;
        marqueeLabel.autoresizesSubviews = NO;
        marqueeLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:marqueeLabel];
        self.titleLabel = marqueeLabel;
    }
    self.titleLabel.text = self.tag.name;
    [self.titleLabel restartLabel];
    
    self.parent.background.filterColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.recordings = [DataSource getRecordingsForTagName:self.tag.name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activityIndicator.hidden=YES;
        });
        
    });
    
}


-(void)swipedRight:(UIGestureRecognizer*)recognizer{
    //Go to Random Tag
    TagPageViewController* tagPageViewController = [[TagPageViewController alloc] initWithNibName:@"TagPageViewController" bundle:nil];
    [tagPageViewController setParent:self.parent];
    [tagPageViewController setTag:[DataSource getNextPopularTag]];
    [self.navigationController pushViewController:tagPageViewController animated:YES];
    [self removeFromParentViewController];
}
-(void)swipedLeft:(UIGestureRecognizer*)recognizer{
    
    //Go home
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
