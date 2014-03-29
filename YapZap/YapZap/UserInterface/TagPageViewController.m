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
#import "MasterAudioPlayer.h"
#import "MasterAudioPlayerCallbackData.h"
#import "TagTableViewCell.h"


@interface TagPageViewController ()

@property(nonatomic, strong)NSArray* recordings;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeLeft;
@property(nonatomic, strong)UISwipeGestureRecognizer* swipeRight;
@property(nonatomic, strong)UILabel* titleLabel;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [YapZapMainViewController getMe].stopPlaybackDelegate = self;
    [MasterAudioPlayer instance].audioListener = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTag:(Tag *)tag
{
    _tag = tag;
    
    self.parent.recordButton.enabled = ![tag.name isEqualToString:@"welcome2yapzap"];
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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,45)];
        
        [self.view addSubview:self.titleLabel];
    }
    NSString* text = [NSString stringWithFormat:@"%@", [self.tag.name uppercaseString] ];
    self.titleLabel.text = text;
    self.titleLabel.font = [UIFont fontWithName:@"Futura" size:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.autoresizesSubviews = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.opaque=NO;
    [self.titleLabel sizeToFit];
    [self.titleLabel setFrame:CGRectMake((self.view.frame.size.width - self.titleLabel.frame.size.width)/2.0, 0, self.titleLabel.frame.size.width, 50)];
    self.colorBarLeft.backgroundColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    self.colorBarRight.backgroundColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    [self.colorBarLeft setFrame:CGRectMake(5, 22.5, self.titleLabel.frame.origin.x-10, 2)];
    [self.colorBarRight setFrame:CGRectMake(5+self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, 22.5, self.view.frame.size.width-10-(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width), 2)];
//    [self.titleLabel restartLabel];
    
    self.parent.background.filterColor =[Util colorFromMood:self.tag.mood andIntesity:self.tag.intensity];
    
    [self.view bringSubviewToFront:self.playButton];
    
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

-(TagTableViewCell*)cellForRecordingId:(NSString*)string{
    for (UIView *view in self.tableController.tableView.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[TagTableViewCell class]]){
                TagTableViewCell* cell = (TagTableViewCell*)subview;
                if ([cell.recording._id isEqualToString:string]){
                    return cell;
                }
            }
        }
    }
    return nil;
}

-(NSIndexPath*)indexPathForRecordingWithID:(NSString*)recordingId{
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
        NSIndexPath *indexPath;// = [NSIndexPath indexPathForRow:j inSection:i];
        
        if (comment){ //Make sure the cell is Expanded
            indexPath = [NSIndexPath indexPathForRow:(j+2) inSection:i];
            return indexPath;
        }
        else {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            return  indexPath;
        }
    }
    return nil;
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
        NSIndexPath *indexPath;// = [NSIndexPath indexPathForRow:j inSection:i];
        
        if (comment){ //Make sure the cell is Expanded
            indexPath = [NSIndexPath indexPathForRow:(j+2) inSection:i];
            NSIndexPath *parentIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            UITableViewCell* cell = [self.tableController.tableView cellForRowAtIndexPath:parentIndexPath];
            TagPageTableViewController* tagPageTableViewController = self.tableController;
            if (![tagPageTableViewController.expandedSections containsIndex:parentIndexPath.section]){
                [tagPageTableViewController commentPressed:cell];
            }
        }
        else {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500*USEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.tableController.tableView scrollToRowAtIndexPath:indexPath
                                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            TagTableViewCell* cell = (TagTableViewCell*)[self.tableController.tableView cellForRowAtIndexPath:indexPath];
            [cell highlight];
        });
        
        
    }
}



#pragma Audio playback

-(void)setCurrentlyPlayingCell:(TagTableViewCell *)currentlyPlayingCell{
    
    if (_currentlyPlayingCell && ![_currentlyPlayingCell.recording._id isEqualToString:currentlyPlayingCell.recording._id]){
        [_currentlyPlayingCell stopPlaying];
        _currentlyPlayingCell = currentlyPlayingCell;
    }
    else if (!_currentlyPlayingCell){
        _currentlyPlayingCell = currentlyPlayingCell;
    }
}

-(void)playAudioAtCell:(TagTableViewCell*)currentlyPlayingCell{
    self.currentlyPlayingCell = currentlyPlayingCell;
    [[MasterAudioPlayer instance] play:currentlyPlayingCell.recording fromTagSet:self.recordings];
}
-(void)stopAudioAtCell:(TagTableViewCell*)currentlyPlayingCell{
    if (self.currentlyPlayingCell!=currentlyPlayingCell){
        return;
    }
    self.currentlyPlayingCell = nil;
    [[MasterAudioPlayer instance] stop];
}
-(void)audioStateChanged:(MasterAudioPlayerCallbackData *)data{
    if (![data.recording.tagName isEqualToString:self.tag.name]){
        //User changed windows
        return;
    }
    NSIndexPath* indexPath = [self indexPathForRecordingWithID:data.recording._id];
    if (!indexPath){
        return;
    }
    self.currentlyPlayingCell = [self cellForRecordingId:data.recording._id];
    [self.currentlyPlayingCell setState:data];
}



-(void)stopPlayback{
    if (self.currentlyPlayingCell){
        [self.currentlyPlayingCell stopPlaying];
        [[MasterAudioPlayer instance] stop];
    }
}

@end
