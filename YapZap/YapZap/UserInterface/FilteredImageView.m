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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}


-(void)setup{
    self.filterColor = [UIColor redColor];
    self.originalImage = [UIImage imageNamed:@"background.png"];
}

-(void)setImage:(UIImage *)image{
    self.originalImage = image;
}

-(void)setFilterColor:(UIColor *)filterColor{
    _filterColor = filterColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.originalImage==nil){
        return;
    }
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
    
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
        CGContextDrawImage(context, self.frame, self.originalImage.CGImage);
        CGContextSetBlendMode (context, kCGBlendModeMultiply);
        CGContextSetFillColor(context, CGColorGetComponents(self.filterColor.CGColor));
    }
    CGContextFillRect (context, self.bounds);
    CGContextRestoreGState(context);
}


@end
