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
#import "YapZapMainViewController.h"

@class MoodSelectView;

@interface SetTagViewController : YapZapMainViewController <UITextFieldDelegate, MoodProtocol>
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet FilteredImageView *waveformImage;
@property (weak, nonatomic) IBOutlet MoodSelectView *moodSelector;
@property (weak, nonatomic) IBOutlet UIImageView *waveformBorderY;
@property (weak, nonatomic) IBOutlet UIImageView *waveformBorderX;

@end
