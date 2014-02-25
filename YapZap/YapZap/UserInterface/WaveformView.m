//
//  WaveformView.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WaveformView.h"

@interface WaveformView()

@property BOOL hasData;
@property float* data;
@property int dataLength;

@end

@implementation WaveformView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hasData = false;
        self.opaque = false;
        self.highlightPercent=-1;
    }
    return self;
}



-(void)setData:(float*)data withSize:(int)size{
    self.data = data;
    self.dataLength = size;
    self.hasData = true;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!self.hasData){
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGContextClearRect(context, bounds);
    
    [[UIColor yellowColor] setFill];
    
    float step = width/(float)self.dataLength;
    float heightScale = height/7.0;
    float mid = height/2.0;
    
    for (int i=0;i<self.dataLength;i++){
        float height = self.data[i]*heightScale;
        if (i/(float)self.dataLength>self.highlightPercent){
            [[UIColor whiteColor] setFill];
        }
        CGRect rect = CGRectMake(i*step, mid-height, step*1.1   , height*2);
        CGContextFillRect(context, rect);
    }
    
    CGContextRestoreGState(context);
    
}


- (UIImage *) asImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


@end
