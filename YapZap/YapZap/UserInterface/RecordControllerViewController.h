//
//  RecordControllerViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YapZapMainViewController.h"

@interface RecordControllerViewController : YapZapMainViewController
-(void) updateBackgroundColor;
-(void)updatePlayLocation;
@property (weak, nonatomic) IBOutlet UIView *finishedPanel;
@property (weak, nonatomic) IBOutlet UIView *stopPanel;
@property (weak, nonatomic) IBOutlet UIView *backgroundColor;
@property (weak, nonatomic) IBOutlet UIButton *recordActiveButton;
- (IBAction)recordButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;
-(void)initialize;
-(void)stopRecording;

@end
