//
//  TagPageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapMainViewController.h"
#import "StopPlaybackDelegate.h"

@class Tag;
@class Recording;
@class TagTableViewCell;

@interface TagPageViewController : YapZapViewController<YapZapMainControllerProtocol, StopPlaybackDelegate>

- (IBAction)playAll:(id)sender;
@property(nonatomic, strong) Tag* tag;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)swipedRight:(UIGestureRecognizer*)recognizer;
-(void)swipedLeft:(UIGestureRecognizer*)recognizer;
@property (weak, nonatomic) YapZapMainViewController* parent;
@property (weak, nonatomic) IBOutlet UIView *tableArea;
@property (weak, nonatomic) IBOutlet UIView *colorBarLeft;
@property (weak, nonatomic) IBOutlet UIView *colorBarRight;
@property (nonatomic, strong) TagTableViewCell* currentlyPlayingCell;
-(void)loadRecordingsForTag;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
+(void)requestDisplayRecording:(NSString*)recordingId;
@end
