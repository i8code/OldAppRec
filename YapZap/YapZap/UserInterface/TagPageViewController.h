//
//  TagPageViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapMainViewController.h"

@class Tag;
@class Recording;
@class TagTableViewCell;

@interface TagPageViewController : YapZapViewController<YapZapMainControllerProtocol>

- (IBAction)playAll:(id)sender;
@property(nonatomic, strong) Tag* tag;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
-(void)swipedRight:(UIGestureRecognizer*)recognizer;
-(void)swipedLeft:(UIGestureRecognizer*)recognizer;
@property (weak, nonatomic) YapZapMainViewController* parent;
@property (weak, nonatomic) IBOutlet UIView *tableArea;
@property (weak, nonatomic) IBOutlet UIView *colorBar;
@property (nonatomic, strong) TagTableViewCell* currentlyPlayingCell;
-(void)loadRecordingsForTag;
+(void)requestDisplayRecording:(NSString*)recordingId;
@end
