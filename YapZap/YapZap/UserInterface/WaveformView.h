//
//  WaveformView.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveformView : UIView


-(void)setData:(float*)data withSize:(int)size;
-(void)setColor:(UIColor*)color;
@property float highlightPercent;
- (UIImage *) asImage;
@end
