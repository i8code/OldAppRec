//
//  FilteredImageView.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteredImageView : UIView
@property (strong, nonatomic) UIColor *filterColor;

-(id)initWithFrame:(CGRect)frame;
- (void)drawRect:(CGRect)rect;
@end
