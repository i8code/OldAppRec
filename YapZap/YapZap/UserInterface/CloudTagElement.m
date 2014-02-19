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
@property (nonatomic, strong) UIButton* button;
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
        
        self.button = [[UIButton alloc] init];
        [self.button setFrame:CGRectMake(origin.x+1000, origin.y, 200, 50)];
        [self.button setTitle:tag.name forState:UIControlStateNormal];
        [self.button setTitleColor:[Util colorFromMood:tag.mood andIntesity:tag.intensity] forState:UIControlStateNormal];
        
        UIFont* font = [UIFont fontWithName:@"Futura" size:15*depth/80.0];
        
        [self.button.titleLabel setFont:font];
        
        [self.button setShowsTouchWhenHighlighted:YES];
        [self.button sizeToFit];
        [view addSubview:self.button];
    }
    
    return self;
}

-(void)setPosition:(CGFloat)position{
    _position = position;
    CGRect frame = self.button.frame;
    frame.origin.x = self.startingPoint.x-position*(self.depth-70)*2;
    
    while (frame.origin.x+frame.size.width<0) {
        frame.origin.x+=self.canvasWidth;
    }
    
    [self.button setFrame:frame];
}
-(void)removeFromSuperView{
    [self.button removeFromSuperview];
}

@end
