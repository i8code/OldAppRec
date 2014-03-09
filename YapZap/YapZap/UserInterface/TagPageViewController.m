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
#import "SharingBundle.h"
#import "TagTableViewCell.h"

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

- (IBAction)playAll:(id)sender {
    [self.tableController playAll];
}

-(Tag*)tag{
    return _tag;
}

-(void)loadRecordingsForTag{
    self.activityIndicator.hidden=NO;
    
    [[SharingBundle getCurrentSharingBundle] setTagName:[self.tag.name uppercaseString]];
    
    if (!self.titleLabel){
        MarqueeLabel* marqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10,0,300,45) duration:4.0 andFadeLength:15.0f];
        self.titleLabel = marqueeLabel;
        
        [self.view addSubview:marqueeLabel];
    }
    NSString* text = [NSString stringWithFormat:@"   %@", [self.tag.name uppercaseString] ];
    self.titleLabel.text = text;
    self.titleLabel.font = [UIFont fontWithName:@"Futura" size:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.autoresizesSubviews = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor blackColor];
    self.titleLabel.opaque=YES;
    [self.titleLabel sizeToFit];
    [self.titleLabel setFrame:CGRectMake((self.view.frame.size.width - self.titleLabel.frame.size.width)/2.0-10, 0, self.titleLabel.frame.size.width, 50)];
    self.colorBar.backgroundColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
//    [self.titleLabel restartLabel];
    
    self.parent.background.filterColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.recordings = [DataSource getRecordingsForTagName:self.tag.name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.tableController){
                [self.tableController removeFromParentViewController];
                [self.tableController.view removeFromSuperview];
            }
            
            self.tableController = [[TagPageTableViewController alloc] initWithNibName:@"TagPageTableViewController" bundle:nil];
            [self.tableController setTagName:self.tag.name];
            [self.tableController setRecordings:self.recordings];
            self.tableController.delegate = self.parent;
            self.tableController.parentTagViewController = self;
            
            [self addChildViewController:self.tableController];
            [self.tableArea addSubview:self.tableController.view];
            [self.tableController didMoveToParentViewController:self];
            [self.tableController.view setFrame:self.tableArea.bounds];
            self.activityIndicator.hidden=YES;
            
            if (requestedRecording){
                [self scrollToRecording:requestedRecording];
                requestedRecording = nil;
            }
            
        });
        
    });
    
}


-(void)setCurrentlyPlayingCell:(TagTableViewCell *)currentlyPlayingCell{
    if (_currentlyPlayingCell && _currentlyPlayingCell!=currentlyPlayingCell){
        [_currentlyPlayingCell stopPlaying];
    }
    _currentlyPlayingCell = currentlyPlayingCell;
}


-(void)swipedRight:(UIGestureRecognizer*)recognizer{
    //Go to Random Tag
    [_currentlyPlayingCell stopPlaying];
    self.view.hidden=YES;
    TagPageViewController* tagPageViewController = [[TagPageViewController alloc] initWithNibName:@"TagPageViewController" bundle:nil];
    [tagPageViewController setParent:self.parent];
    [tagPageViewController setTag:[DataSource getNextPopularTag]];
    [self.navigationController pushViewController:tagPageViewController animated:YES];
    [self removeFromParentViewController];
}
-(void)swipedLeft:(UIGestureRecognizer*)recognizer{
    
    [_currentlyPlayingCell stopPlaying];
    self.view.hidden=YES;
    //Go home
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

static NSString* requestedRecording;
+(void)requestDisplayRecording:(NSString*)recordingId{
    requestedRecording = recordingId;
}

-(void)scrollToRecording:(NSString*)recordingId{
    int i=0, j=0;
    BOOL found=false;
    BOOL comment=false;
    for (i=0;i<self.recordings.count;i++){
        Recording* parentRecording = self.recordings[i];
        if ([parentRecording._id isEqualToString:recordingId]){
            found = true;
            comment = false;
            break;
        }
        
        for (j=0;j<parentRecording.childrenLength;j++){
            Recording* recording = parentRecording.children[j];
            if ([recording._id isEqualToString:recordingId]){
                found = true;
                comment = true;
                break;
            }
        }
        if (found){
            break;
        }
    }
    
    if (found){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
        
        if (comment){ //Make sure the cell is Expanded
            NSIndexPath *parentIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            UITableViewCell* cell = [self.tableController.tableView cellForRowAtIndexPath:parentIndexPath];
            TagPageTableViewController* tagPageTableViewController = self.tableController;
            if (![tagPageTableViewController.expandedSections containsIndex:parentIndexPath.section]){
                [tagPageTableViewController commentPressed:cell];
            }
        }
        
        [self.tableController.tableView scrollToRowAtIndexPath:indexPath
                                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
