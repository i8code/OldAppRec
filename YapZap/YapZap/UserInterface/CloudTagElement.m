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
#import <QuartzCore/QuartzCore.h>

@interface CloudTagElement()
@property (nonatomic, strong) Tag* tag;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UIButton* circle;
@property CGPoint startingPoint;
@property CGFloat pop;
@property (nonatomic, strong) void (^onclickBlock)(Tag*);
@end

@implementation CloudTagElement

static int lineHeight = 16;

-(CloudTagElement*)initWithTag:(Tag*)tag withPopularity:(NSUInteger)pop inView:(UIView*)view andOnclick:(void (^)(Tag*))onclick{
    self = [super init];
    if (self){
        self.tag = tag;
        self.time = 0;
        self.onclickBlock = onclick;
        self.pop = pop;
        
        //Set up Button
        self.button = [[UIButton alloc] init];
        [self.button setFrame:CGRectMake(0,0, 200, lineHeight)];
        [self.button setTitle:tag.name forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIFont* font = [UIFont fontWithName:@"Futura" size:lineHeight];
        
        [self.button.titleLabel setFont:font];
        
        [self.button setShowsTouchWhenHighlighted:YES];
        [self.button sizeToFit];
        
        [self.button addTarget:self
                        action:@selector(onClick:)
                      forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.button];
        
        [self.button sizeToFit];
        
        self.circle = [[UIButton alloc] init];
        [self.circle setFrame:CGRectMake(-pop*lineHeight-5, 0, pop*lineHeight/2, pop*lineHeight/2)];
        self.circle.backgroundColor = [Util colorFromMood:tag.mood andIntesity:tag.intensity];
        self.circle.layer.cornerRadius = pop*lineHeight/4.0;
        self.circle.clipsToBounds = YES;
        self.circle.showsTouchWhenHighlighted= YES;
        [self.circle addTarget:self
                        action:@selector(onClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.circle];
    }
    
    return self;
}

-(void)onClick:(id)sender{
    self.onclickBlock(self.tag);
}


-(void)setTime:(CGFloat)time{
    _time = time;
    CGRect buttonFrame =CGRectMake(self.position.x-10*time+self.height,
                                   self.position.y,
                                   self.button.frame.size.width,
                                   self.button.frame.size.height);
    CGRect circleFrame =CGRectMake(self.position.x-self.pop*lineHeight/2-5-10*time+self.height,
                                   self.position.y+(5-self.pop)*lineHeight/5.0,
                                   self.circle.frame.size.width,
                                   self.circle.frame.size.height);

    
    while (buttonFrame.origin.x+self.width<0) {
        buttonFrame.origin.x+=self.canvasWidth;
        circleFrame.origin.x+=self.canvasWidth;
    }
    
    [self.button setFrame:buttonFrame];
    [self.circle setFrame:circleFrame];

}

-(void)removeFromSuperView{
    [self.button removeFromSuperview];
    [self.circle removeFromSuperview];
}

-(CGFloat)height{
    return lineHeight*self.pop/2.0f;
}
-(CGFloat)width{
    CGRect r = [self.tag.name boundingRectWithSize:CGSizeMake(200, 0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:lineHeight]}
                                  context:nil];
    return self.height+r.size.width+5;
}

@end
