//
//  CloudTagElement.m
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "CloudTagElement.h"
#import "Tag.h"
#import "Util.h"

@interface CloudTagElement()
@property (nonatomic, strong) Tag* tag;
@property (nonatomic, strong) UIButton* button1;
@property (nonatomic, strong) UIButton* button2;
@property CGPoint startingPoint;
@property CGFloat canvasWidth;
@property CGFloat depth;

@end

@implementation CloudTagElement
-(CloudTagElement*)initWithTag:(Tag*)tag position:(CGPoint)origin andDepth:(CGFloat)depth andCanvasWidth:(CGFloat)canvasWidth inView:(UIView*)view{
    self = [super init];
    if (self){
        self.tag = tag;
        self.startingPoint = origin;
        self.depth = depth;
        self.position = -100;
        self.canvasWidth = canvasWidth;
        
        self.button1 = [[UIButton alloc] init];
        [self.button1 setFrame:CGRectMake(origin.x+1000, origin.y, 200, 50)];
        [self.button1 setTitle:tag.name forState:UIControlStateNormal];
        [self.button1 setTitleColor:[Util colorFromMood:tag.mood andIntesity:tag.intensity] forState:UIControlStateNormal];
        
        UIFont* font = [UIFont fontWithName:@"Futura" size:15*depth/80.0];
        
        [self.button1.titleLabel setFont:font];
        
        [self.button1 setShowsTouchWhenHighlighted:YES];
        [self.button1 sizeToFit];
        [view addSubview:self.button1];
        
        
        
        self.button2 = [[UIButton alloc] init];
        [self.button2 setFrame:CGRectMake(origin.x+canvasWidth+1000, origin.y, 200, 50)];
        [self.button2 setTitle:tag.name forState:UIControlStateNormal];
        [self.button2 setTitleColor:[Util colorFromMood:tag.mood andIntesity:tag.intensity] forState:UIControlStateNormal];
        
        
        [self.button2.titleLabel setFont:font];
        
        [self.button2 setShowsTouchWhenHighlighted:YES];
        [self.button2 sizeToFit];
        [view addSubview:self.button2];
        
    }
    
    return self;
}

-(void)setPosition:(CGFloat)position{
    _position = position;
    CGRect frame1 = self.button1.frame;
    frame1.origin.x = self.startingPoint.x-position*(self.depth-70)*2;
    
    [self.button1 setFrame:frame1];
    
    
    CGRect frame2 = self.button2.frame;
    frame2.origin.x = frame1.origin.x+self.canvasWidth;
    
    [self.button2 setFrame:frame2];
    
}
-(void)removeFromSuperView{
    [self.button1 removeFromSuperview];
    [self.button2 removeFromSuperview];
}

@end
