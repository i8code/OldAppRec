//
//  RecordingFill.m
//  YapZap
//
//  Created by Jason R Boggess on 3/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "RecordingFill.h"

@implementation RecordingFill

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGContextClearRect(context, bounds);
    
    float radius = MIN(width, height);
    
    CGRect circleRect = CGRectMake((width-radius)/2.0f, (height-radius)/2.0f, radius, radius);
    
    // Draw picture first
    
    CGContextSetBlendMode (context, kCGBlendModeNormal);
    [[UIColor colorWithRed:1 green:0.2666666 blue:0.721568 alpha:1] setFill];
    CGContextFillEllipseInRect (context, circleRect);
    
    CGRect fillRect = CGRectMake((width-radius)/2.0f, (height-radius)/2.0f, radius, radius*(1-self.percent));
    [[UIColor clearColor] setFill];
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextFillRect (context, fillRect);

    CGContextRestoreGState(context);
    
}


@end
