//
//  MoodSelectView.h
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodProtocol.h"

@interface MoodSelectView : UIImageView

@property (nonatomic, weak) id<MoodProtocol> colorDelegate;
-(BOOL)canBecomeFirstResponder;

@end
