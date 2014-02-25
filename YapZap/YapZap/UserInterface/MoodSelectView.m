//
//  MoodSelectView.m
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "MoodSelectView.h"

@implementation MoodSelectView


-(void)setup{
    self.image = [UIImage imageNamed:@"color_wheel.png"];
    self.userInteractionEnabled = YES;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
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

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.colorDelegate setMoodColor:[self colorFromTouches:touches]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.colorDelegate setMoodColor:[self colorFromTouches:touches]];
}

-(UIColor*)colorFromTouches:(NSSet*)touches{
    
    NSArray *Touches = [touches allObjects];
    UITouch *first = [Touches objectAtIndex:0];
    CGPoint c = [first locationInView:self];
    
    return [self colorFromX:c.x andY:c.y];
}

-(UIColor*) colorFromX:(CGFloat)x andY:(CGFloat)y{
    
    CGFloat size = MIN(self.bounds.size.width, self.bounds.size.height);
    
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    CGFloat dx = (x-centerX);
    CGFloat dy = (y-centerY);
    
    
    CGFloat hueAngle = atan2f(dy, dx);
    hueAngle-=atan2f(1, 0);
    
    CGFloat pi2 =2*atan2f(0, -1);
    
    if (hueAngle<0){
        hueAngle+=pi2; //2pi
    }
    
    CGFloat hue = hueAngle/pi2; //hue between 0 and 1
    
    CGFloat intensity = sqrtf(dx*dx+dy*dy)/size;
    if (intensity>1){
        intensity=1;
    }
    
    return [UIColor colorWithHue:hue saturation:intensity brightness:(0.7+intensity*0.3) alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
