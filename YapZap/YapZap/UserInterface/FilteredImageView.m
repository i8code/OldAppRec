//
//  FilteredImageView.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "FilteredImageView.h"

@interface FilteredImageView(){
    
}
@property (strong, nonatomic) UIImage *originalImage;

@end

@implementation FilteredImageView

@synthesize filterColor = _filterColor;
@synthesize partialFill = _partialFill;
@synthesize percent = _percentt;



-(void)setImage:(UIImage *)image{
    self.originalImage = image;
    [self setNeedsDisplay];
}

-(void)setFilterColor:(UIColor *)filterColor{
    _filterColor = filterColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.originalImage==nil){
        return;
    }
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
//    [[UIColor blackColor] setFill];
//    CGContextFillRect(context, bounds);
    CGContextClearRect(context, bounds);
    
    // Draw picture first
    //
    
    // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
    // over top of image.
    //
    if (self.filterColor==nil){
        CGContextSetBlendMode (context, kCGBlendModeNormal);
        CGContextSetFillColor(context, CGColorGetComponents([UIColor blackColor].CGColor));
    }
    else{
        CGContextDrawImage(context, bounds, self.originalImage.CGImage);
        CGContextSetBlendMode (context, kCGBlendModeMultiply);
        CGContextSetFillColor(context, CGColorGetComponents(self.filterColor.CGColor));
    }
    
    
    if (_partialFill){
        float left = self.bounds.size.width*self.percent;
        bounds = CGRectMake(left, 0, width, height);
    }
    CGContextFillRect (context, bounds);
    
    
    bounds = CGRectMake(0, 0, width, height);
    
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, bounds, self.originalImage.CGImage);
    
    
    CGContextRestoreGState(context);
}

@end
