//
//  SetTagViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodProtocol.h"
#import "FilteredImageView.h"
#import "SearchDelegate.h"

@class MoodSelectView;

@interface SetTagViewController : YapZapModalViewController<YapZapMainControllerProtocol,UITextFieldDelegate, MoodProtocol, SearchDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet FilteredImageView *waveformImage;
@property (weak, nonatomic) IBOutlet MoodSelectView *moodSelector;
@property (weak, nonatomic) IBOutlet UIImageView *waveformBorderY;
@property (weak, nonatomic) IBOutlet UIImageView *waveformBorderX;
@property (weak, nonatomic) YapZapMainViewController* parent;
@property (weak, nonatomic) IBOutlet UIView *autoFillZone;
@property (weak, nonatomic) IBOutlet UIImageView *zeusFace;
@property (weak, nonatomic) IBOutlet FilteredImageView *glowBolt;

@end
