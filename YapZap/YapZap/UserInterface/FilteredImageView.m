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
    
    // Draw picture first
    //
    CGContextDrawImage(context, self.frame, self.originalImage.CGImage);
    
    // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
    // over top of image.
    //
    CGContextSetBlendMode (context, kCGBlendModeMultiply);
    CGContextSetFillColor(context, CGColorGetComponents(self.filterColor.CGColor));
    CGContextFillRect (context, self.bounds);
    CGContextRestoreGState(context);
}


@end
