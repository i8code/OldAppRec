//
//  CloudTagElement.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tag;


@interface CloudTagElement : NSObject
-(CloudTagElement*)initWithTag:(Tag*)tag position:(CGPoint)origin andDepth:(CGFloat)depth inView:(UIView*)view andOnclick:(void (^)(Tag*))onclick;

@property (nonatomic) CGFloat position;
@property (nonatomic) CGFloat canvasWidth;

-(void)removeFromSuperView;
@end
